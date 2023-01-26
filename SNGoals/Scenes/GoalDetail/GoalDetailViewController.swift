//
//  TreatmentViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class GoalDetailViewController: SNViewController<GoalDetailStates, GoalDetailViewModel> {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelActualStep: UILabel!
    @IBOutlet weak var labelFinalStep: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelPercentage: UILabel!
    @IBOutlet weak var textFieldValue: SNTextField!
    @IBOutlet weak var stepper: UIStepper!
    
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var constraintBottomStack: NSLayoutConstraint!

    var group: GoalsModel?
    var goal: GoalModel?
    var action: CreateActions?
    private var disposeBag = DisposeBag()
    weak var delegate: GoalDetailProtocol?
    
    deinit {
        Sanada.print("deinit: \(self)")
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
    }
    
    private var rightButton: UIBarButtonItem = {
        let image = UIImage(systemName: "ellipsis.circle")
        let button = UIBarButtonItem(image: image)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        addNotification()
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if notification.name == UIResponder.keyboardWillChangeFrameNotification || notification.name == UIResponder.keyboardWillShowNotification {
            let safeArea = self.view.safeAreaInsets.bottom
            constraintBottomStack.constant = keyboardSize.height - safeArea + 5
        } else {
            constraintBottomStack.constant = 20
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let percentage = goal?.percentage() ?? 0
        configureProgress(percentage: percentage)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (self.navigationController?.isBeingDismissed ?? false) {
            delegate?.clear()
        }
    }
    
    override func configureViews() {
        configureColor()
        configureLabels()
        configureTextField()
        configureNavigationButton()
        configureStepper()
        if let color = group?.color {
            buttonSave.tintColor = UIColor.fromHex(color)
        }
    }
    
    override func configureBindings() {
        viewModel?.goal.onNext(goal)
        viewModel?.goalType.onNext(goal?.type)
        
        stepper.rx
            .value
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] step in
                self?.viewModel?.didChangeStepper.onNext(step)
            })
            .disposed(by: disposeBag)
    }
    
    override func render(states: GoalDetailStates) {
        switch states {
        case .success:
            delegate?.dismiss()
        case .loading(let loading):
            view.isUserInteractionEnabled = !loading
            buttonIsLoading(loading)
        case .didChangeTextValue(let value):
            self.labelActualStep.text = value
        case .didChangeStepValue(let step):
            self.stepper.stepValue = step
        case .didChangeProgress(let progress):
            configureProgress(percentage: progress)
        case .error(let string):
            Sanada.print(string)
        }
    }
    
    @IBAction func actionStepper(_ sender: UIStepper) {
    }

    @IBAction func actionSave(_ sender: Any) {
        guard let uuid = goal?.uuid, let group = group  else { return }
        viewModel?.save.onNext((uuid: uuid,
                                group: group,
                                value: stepper.value))
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        delegate?.dismiss()
    }
    
    private func addNotification() {
        SNNotificationCenter.shared.addObserver(self, selector: #selector(changedGoals(_:)),
                                                name: SNNotificationCenter.didChangeGoal.name,
                                                object: nil)
    }
    
    @objc private func changedGoals(_ notification: NSNotification) {
        if notification.userInfo?.keys.contains("goal") ?? false {
            guard let _goal = notification.userInfo?["goal"] as? GoalModel else { return }
            if !(goal?.uuid?.isEmpty ?? true) && goal?.uuid == _goal.uuid {
                self.goal = _goal
                configureViews()
                viewModel?.goal.onNext(_goal)
                viewModel?.goalType.onNext(_goal.type)
                let percentage = goal?.percentage() ?? 0
                configureProgress(percentage: percentage)
                delegate?.new(goal: _goal)
            }
        }
    }
    
    private func configureStepper() {
        guard let goal = goal, let type = goal.type else { return }
        switch type {
        case .number:
            stepper.maximumValue = (goal.goal ?? 0).rounded(.down)
            stepper.minimumValue = 0
        case .money:
            stepper.maximumValue = goal.goal ?? 0
            stepper.minimumValue = 0
        }
        stepper.value = goal.value ?? 0
    }
    
    private func buttonIsLoading(_ loading: Bool) {
        buttonSave.isEnabled = !loading
        buttonCancel.isEnabled = !loading
        self.isModalInPresentation = loading
        
        buttonSave.configuration?.showsActivityIndicator = loading
    }
    
    private func configureColor() {
        guard let color = group?.color else { return }
        let uiColor = UIColor.fromHex(color)
        labelActualStep.textColor = uiColor
        progressView.progressTintColor = uiColor
        labelPercentage.textColor = uiColor
        textFieldValue.tintColor = uiColor
        stepper.tintColor = uiColor
    }
    
    private func configureLabels() {
        labelTitle.text = goal?.name
        labelActualStep.text = goal?.stringValue()
        labelFinalStep.text = goal?.stringGoal()
        labelPercentage.text = goal?.stringPercentage()
    }
    
    private func configureTextField() {
        guard let type = goal?.type else { return }
        switch type {
        case .number:
            textFieldValue.configure(delegate: self, type: .number)
            textFieldValue.configureError(validate: .equalMore(count: 1))
            textFieldValue.placeholder("1")
        case .money:
            textFieldValue.configure(delegate: self, type: .currency)
            textFieldValue.configureError(validate: .equalMore(count: 1))
            textFieldValue.placeholder(1.asMoney(digits: 2, minimum: 2))
        }
        stepper.value = 1
    }
    
    private func configureProgress(percentage: Double) {
        self.progressView.setProgress(Float(percentage), animated: true)
    }
    
    private func configureNavigationButton() {
        self.navigationItem.rightBarButtonItems = [rightButton]
        if let hex = group?.color {
            rightButton.tintColor = UIColor.fromHex(hex)
        }
        rightButton.menu = createMenu()
    }
    
    private func createMenu() -> UIMenu {
        let menu = UIMenu(options: .destructive, children: createMenuActions())
        return menu
    }
    
    private func createMenuActions() -> [UIAction] {
        let stringActions: [NavMenuActions] = [.edit, .delete]
        var actions: [UIAction] = []
        stringActions.forEach { action in
            let newElement = UIAction(title: action.title(),
                                      image: action.image(),
                                      attributes: action.attributes()) { [weak self] _ in
                self?.handlerMenu(action: action)
            }
            actions.append(newElement)
        }
        return actions
    }
    
    private func handlerMenu(action: NavMenuActions) {
        switch action {
        case .edit:
            delegate?.edit()
        case .delete:
            guard let uuid = goal?.uuid, let group = group else { return }
            viewModel?.delete.onNext((uuid: uuid, group: group))
        case .share:
            break
        }
    }
}

extension GoalDetailViewController: SNTextFieldDelegate {
    func textField(_ textField: SNTextField?, didChange value: Any?, with type: TextFieldTypes) {
        viewModel?.didChangeTextValue.onNext(value as? Double)
    }
}

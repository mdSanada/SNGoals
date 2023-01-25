//
//  TreatmentViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class CreateGoalViewController: SNViewController<CreateGoalStates, CreateGoalViewModel> {
    weak var delegate: CreateGoalProtocol?
    @IBOutlet weak var collectionCreateGoal: CreateGoalsCollectionView!
    
    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var constraintBottomStack: NSLayoutConstraint!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var actions: CreateActions?
    var group: GoalsModel?
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
        configureCollection()
        mock()
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        Sanada.print("deinit: \(self)")
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
        delegate?.clear()
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
    
    private func mock() {
    }
    
    private func configureCollection() {
        collectionCreateGoal.register()
        collectionCreateGoal.interactor = self
        collectionCreateGoal.force(selection: group?.color)
        collectionCreateGoal.set(CreateModel.createGoal())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (self.navigationController?.isBeingDismissed ?? false) {
            delegate?.clear()
        }
    }
    
    override func configureBindings() {
        if let uuid = group?.uuid {
            viewModel?.groupUUID.onNext(uuid)
        }
        
        collectionCreateGoal.isValidSubject
            .bind(to: buttonSave.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    override func configureViews() {
        if let color = group?.color {
            buttonSave.tintColor = UIColor.fromHex(color)
        }
    }
    
    override func render(states: CreateGoalStates) {
        switch states {
        case .success:
            delegate?.dismiss()
        case .loading(let loading):
            view.isUserInteractionEnabled = !loading
            buttonIsLoading(loading)
        case .error(let string):
            Sanada.print(string)
        }
    }
    
    private func buttonIsLoading(_ loading: Bool) {
        buttonSave.isEnabled = !loading
        buttonCancel.isEnabled = !loading
        self.isModalInPresentation = loading
        
        buttonSave.configuration?.showsActivityIndicator = loading
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        delegate?.dismiss()
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        guard let action = actions else { return }
        viewModel?.save.onNext((action: action, data: collectionCreateGoal.getData()))
    }
}

extension CreateGoalViewController: CreateGoalsCollectionInteractor {
    func collectionView(_ collectionView: CreateGoalsCollectionView, didChange color: HEXColor) {
    }
    
    func collectionView(_ collectionView: CreateGoalsCollectionView, didChange segmented: GoalType, at indexPath: IndexPath) {
        switch segmented {
        case .number:
            collectionCreateGoal.change(textField: "VALUE", type: .number, at: indexPath)
        case .money:
            collectionCreateGoal.change(textField: "VALUE", type: .currency, at: indexPath)
        }
    }
}

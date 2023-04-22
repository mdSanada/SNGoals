//
//  TreatmentViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class CreateGoalsViewController: SNViewController<CreateGoalsStates, CreateGoalsViewModel> {
    weak var delegate: CreateGoalsProtocol?
    @IBOutlet weak var collectionCreateGoals: CreateGoalsCollectionView!
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var stackButtons: UIStackView!
    @IBOutlet weak var constraintBottomStack: NSLayoutConstraint!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    var actions: CreateActions?
    var goals: GoalsModel?
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
        Sanada.print("Deinitializing: \(self)")
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
        collectionCreateGoals.register()
        collectionCreateGoals.interactor = self
        collectionCreateGoals.set(CreateModel.create(goals: goals))
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
        collectionCreateGoals.isValidSubject
            .bind(to: buttonSave.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    override func configureViews() {
        if let actions = actions {
            switch actions {
            case .create:
                buttonSave.setTitle("Salvar", for: .normal)
            case .edit:
                buttonSave.setTitle("Editar", for: .normal)
            }
        }
    }
    
    override func render(states: CreateGoalsStates) {
        switch states {
        case .success:
            Vibration.light.vibrate()
            delegate?.dismiss()
        case .loading(let loading):
            view.isUserInteractionEnabled = !loading
            buttonIsLoading(loading)
        case .error(let string):
            Vibration.error.vibrate()
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
        collectionCreateGoals.interactor = nil
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        guard let action = actions else { return }
        viewModel?.save.onNext((action: action, data: collectionCreateGoals.getData()))
    }
}

extension CreateGoalsViewController: CreateGoalsCollectionInteractor {
    func collectionView(_ collectionView: CreateGoalsCollectionView, didChange segmented: GoalType, at indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: CreateGoalsCollectionView, didChange color: HEXColor) {
        buttonSave.tintColor = UIColor.fromHex(color)
    }
}

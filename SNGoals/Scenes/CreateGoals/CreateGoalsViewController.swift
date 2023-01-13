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
        collectionCreateGoals.set(CreateModel.create())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func configureBindings() {
    }
    
    override func configureViews() {
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        delegate?.dismiss()
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        Sanada.print(collectionCreateGoals.getData())
    }
}

extension CreateGoalsViewController: CreateGoalsCollectionInteractor {
    func collectionView(_ collectionView: CreateGoalsCollectionView, didChange color: HEXColor) {
        buttonSave.tintColor = UIColor.fromHex(color)
    }
}

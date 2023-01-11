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
    private var disposeBag = DisposeBag()
    @IBOutlet weak var collectionCreateGoals: CreateGoalsCollectionView!
    @IBOutlet weak var collectionFlowLayout: UICollectionViewFlowLayout!
    
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
        configureCollection()
        mock()
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
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func configureBindings() {
    }
    
    @IBAction func actionCancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        Sanada.print(collectionCreateGoals.getData())
    }
}

extension CreateGoalsViewController: CreateGoalsCollectionInteractor {
    func collectionView(_ collectionView: CreateGoalsCollectionView, didChange color: String) {
        buttonSave.tintColor = UIColor.fromHex(color)
    }
}

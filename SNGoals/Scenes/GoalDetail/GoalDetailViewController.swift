//
//  TreatmentViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class GoalDetailViewController: SNViewController<GoalDetailStates, GoalDetailViewModel> {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelActualStep: UILabel!
    @IBOutlet weak var labelFinalStep: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var labelPercentage: UILabel!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    var group: GoalsModel?
    var goal: GoalModel?
    var action: CreateActions?
    private var disposeBag = DisposeBag()
    weak var delegate: GoalDetailProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        mock()
    }
    
    private func mock() {
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
    
    @IBAction func actionStepper(_ sender: UIStepper) {
    }
    
    override func configureViews() {
        configureColor()
        configureLabels()
        configureTextField()
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
        textFieldValue.text = "1"
    }
    
    private func configureProgress(percentage: Double) {
        self.progressView.setProgress(Float(percentage), animated: true)
    }

    override func configureBindings() {
    }
    
    override func render(states: GoalDetailStates) {
    }
}

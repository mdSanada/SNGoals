//
//  TreatmentProtocol.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit

protocol GoalProtocol: AnyObject {
    func addGoal()
    func presentEditGroup()
    func detail(goal: GoalModel)
    func didChangeGoals(_ goals: GoalsModel)
    func back()
}

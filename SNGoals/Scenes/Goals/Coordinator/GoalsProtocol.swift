//
//  TreatmentProtocol.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import Foundation

protocol GoalsProtocol: AnyObject {
    func pushGoal(from group: GoalsModel)
    func presentCreateNewGoals()
    func presentEditGoal(goal: GoalsModel)
}

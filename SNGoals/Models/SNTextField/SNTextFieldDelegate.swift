//
//  SNTextFieldDelegate.swift
//  SNGoals
//
//  Created by Matheus D Sanada on 25/01/23.
//

import Foundation

protocol SNTextFieldDelegate: AnyObject {
    func textField(_ textField: SNTextField?, didChange value: Any?, with type: TextFieldTypes)
}

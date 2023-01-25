//
//  SettingsViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class SettingsViewController: UIViewController {
    weak var delegate: SettingsProtocol?
    @IBOutlet weak var buttonSignOut: UIButton!
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonSignOut.rx
            .tap
            .subscribe(onNext: { [weak self] _ in
                do {
                    try Auth.auth().signOut()
                    self?.delegate?.signout()
                } catch {
                    Sanada.print("Something Happens")
                }
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  CameraHandler.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 04/11/22.
//

import UIKit

class CameraHandler: NSObject {
    fileprivate var currentVC: UIViewController!
    var imagePickedBlock: ((UIImage?) -> Void)?
    
    deinit {
        imagePickedBlock = nil
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .camera
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(controller: UIViewController,
                         completion: @escaping ((UIImage?) -> Void)) {
        imagePickedBlock = completion
        currentVC = controller
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Câmera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Galeria", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Remover", style: .destructive, handler: { (alert:UIAlertAction!) -> Void in
            self.imagePickedBlock?(nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        controller.present(actionSheet, animated: true, completion: nil)
    }
}

extension CameraHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Something went wrong")
        }
        
        imagePickedBlock?(image)
    }
}

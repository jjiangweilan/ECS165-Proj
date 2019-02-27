//
//  userInfoViewController.swift
//  Proj
//
//  Created by Xiaofang Jiang on 1/27/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
// 

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
class ProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var profilePhoto: UIImageView!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DatabaseBridge.getUserInfo(snapshotFunc: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.name.text =  value?["name"] as? String ?? ""
            self.username.text =  value?["username"] as? String ?? ""
            self.email.text =  value?["email"] as? String ?? ""
            self.gender.text =  value?["gender"] as? String ?? ""
            self.phone.text =  value?["phone"] as? String ?? ""
            
//            let userPictureBase64 = value?["profile picture"] as? String ?? ""
//
//            if let p = Data(base64Encoded: userPictureBase64) {
//                let image = UIImage(data: p)
//                self.profilePhoto.image = image
//            }
            
        })
        self.tableView.isScrollEnabled = false
        self.tableView.alwaysBounceVertical = false
        
        name.delegate = self
        username.delegate = self
        email.delegate = self
        phone.delegate = self
        gender.delegate = self
    }
    
    func openCamera(action : UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery(action : UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have perission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
        info: [UIImagePickerController.InfoKey : Any]) {
        
        let action = UIAlertController(title: "Confirm", message: "Do you want to use this picture", preferredStyle: .actionSheet)
        
        let actionConfirm = UIAlertAction(title: "Yes", style: .default) { (_) in
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.profilePhoto.image = image
            DatabaseBridge.uploadProfilePic(userID: Auth.auth().currentUser!.uid, imageData: image.pngData()!)
            picker.dismiss(animated: true, completion: nil)
            
//            if let base64 = image.jpegData(compressionQuality: 0.1)?.base64EncodedString() {
//                DatabaseBridge.updateUserInfo(key: "profile picture", value: base64)
//            }
            
        }
        
        let actionNope = UIAlertAction(title: "No", style: .destructive) { (_) in
            action.dismiss(animated: true, completion: nil)
        }
        
        action.addAction(actionConfirm)
        action.addAction(actionNope)
        
        picker.present(action, animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        DatabaseBridge.updateUserInfo(key: textField.accessibilityIdentifier!, value: textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DatabaseBridge.updateUserInfo(key: textField.accessibilityIdentifier!, value: textField.text ?? "")
        textField.endEditing(true)
        return true
    }
    
    @IBAction func changeProfilePicture(_ sender: Any) {
        let chooseAction = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let chooseCamera = UIAlertAction(title: "Camera", style: .default, handler: openCamera)
        let chooseGallery = UIAlertAction(title: "Gallery", style: .default, handler: openGallery)
        let actionNope = UIAlertAction(title: "Dismiss", style: .destructive) { (_) in
            chooseAction.dismiss(animated: true, completion: nil)
        }
        
        chooseAction.addAction(chooseCamera)
        chooseAction.addAction(chooseGallery)
        chooseAction.addAction(actionNope)
        self.present(chooseAction, animated: true, completion: nil)
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

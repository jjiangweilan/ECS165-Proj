//
//  postViewController.swift
//  Proj
//
//  Created by Xiaofang Jiang on 2/22/19.
//  Copyright © 2019 jiehong jiang. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class PostViewController: UIViewController,
UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var photoPost: UIButton!
    @IBOutlet weak var libraryPost: UIButton!
    
    @IBOutlet weak var imageChoose: UIImageView!
    @IBOutlet weak var textContent: UITextView!
    
    
    @IBAction func takePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
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
    

    @IBAction func libraryPost(_ sender: Any) {
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
            self.imageChoose.image = image
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
    
    
    @IBAction func handlePost(_ sender: Any) {
        let content = textContent.text
        let postTime = uint(NSDate().timeIntervalSince1970)
        let userID = Auth.auth().currentUser!.uid
        let likes : [Int : String]? = nil
        let postID = "\(Auth.auth().currentUser!.uid)_\(postTime)"
        let postData : [String : Any] = [
            "userID" : userID,
            "content" : content ?? "",
            "time" : postTime,
            "likes" : "",
            ]
        
        DatabaseBridge.updateData(path: "posts/\(postID)", data: postData)
        
        if let imageData = imageChoose.image?.pngData() {
            DatabaseBridge.uploadImage(postID: postID, imageData: imageData) //image data is stored in storage
        }
        
        //After Post
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

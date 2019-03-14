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
UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate{
    
    @IBOutlet weak var photoPost: UIButton!
    @IBOutlet weak var libraryPost: UIButton!
    @IBOutlet weak var imageChoose: UIImageView!
    @IBOutlet weak var textContent: UITextView!
    
    var tags : [String] = [String]()
    
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
        
        let postData : [String : Any] = [
            "userID" : userID,
            "content" : content ?? "",
            "timeStamp" : postTime,
            "likes" : "",
            ]
        
        DatabaseBridge.updateData(path: "posts/\(userID)/\(postTime)", data: postData)
        DatabaseBridge.updateData(path: "posts/\(userID)/\(postTime)/tags", data: tags)
        DatabaseBridge.updateData(path: "posts/\(userID)/\(postTime)/likes", data: [String]())
        for tag in tags {
            DatabaseBridge.updateData(path: "tags/\(tag)/\(userID)/\(postTime)", data: postTime)
            DatabaseBridge.updateData(path: "tags/\(tag)/\(userID)/lastPost", data: postTime)
        }
        
        
        if let imageData = imageChoose.image?.pngData() {
            DatabaseBridge.uploadImage(userID: userID, timeStampAsPostID: postTime, imageData: imageData) //image data is stored in storage
            self.displayAlert(userMessage: "Posted")
        }
    }
    
    func displayAlert(userMessage:String, okAction : (() -> Void)? = nil) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                { (action:UIAlertAction!) in
                    if let action = okAction {
                        action()
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController,animated: true, completion: nil)
                
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        textContent.layer.borderWidth = 1.0
        textContent.layer.borderColor = UIColor.black.cgColor
        
        self.textContent.delegate = self
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let tagArr = findTagInText(text: textView.attributedText.string)
        
        let newAttributedText = NSMutableAttributedString(string: textView.attributedText.string)
        tags.removeAll()
        for tag in tagArr {
            newAttributedText.addAttribute(.foregroundColor, value: UIColor.blue, range: (textView.attributedText.string as NSString).range(of: tag))
            tags.append(String(tag.dropFirst()))
        }
        
       newAttributedText.addAttribute(.font, value:  UIFont.systemFont(ofSize: 15), range: NSRange(location: 0, length: newAttributedText.length))
        
        textView.attributedText = newAttributedText.copy() as! NSAttributedString

    }
    
    private func findTagInText(text : String) -> [String] {
        var rlt = [String]()
        let tokens = text.split(separator: " ")
        for word in tokens {
            if word.hasPrefix("#") {
                rlt.append(String(word))
            }
        }
        
        return rlt
    }
}

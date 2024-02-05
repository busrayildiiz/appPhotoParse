//
//  UploadViewController.swift
//  appPhotoParse
//
//  Created by MacBook Pro on 1.02.2024.
//

import UIKit
import Parse

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(hiddenKeyboard))
        view.addGestureRecognizer(keyboardRecognizer)
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        uploadButton.isEnabled = false
    }
    
    @IBAction func clickedUpload(_ sender: Any) {
        uploadButton.isEnabled = false
        let post = PFObject(className: "Post")
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        
        if let data = data {
            if PFUser.current() != nil {
                let parseImage = PFFileObject(name: "image.jpg", data: data)
                post["postImage"] = parseImage
                post["postComment"] = commentTextField.text
                post["postUser"] = PFUser.current()?.username
                
                post.saveInBackground{(success, error) in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription , preferredStyle: UIAlertController.Style.alert)
                        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
                        alert.addAction(okButton)
                        self.present(alert, animated:  true)
                    }else {
                        
                        self.commentTextField.text = ""
                        self.imageView.image = UIImage(named: "chooseImage")
                        self.tabBarController?.selectedIndex = 0
                        
                        NotificationCenter.default.post(name: NSNotification.Name("newpost"), object: nil)
                    }
                }
            }
        }
    }
    
    @objc func hiddenKeyboard() {
        view.endEditing(true)
    }
    
    @objc func selectImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated:true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        uploadButton.isEnabled = true
    }
}

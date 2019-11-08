//
//  memeEditorViewController.swift
//  MemeMe 1.0
//
//  Created by Lola M on 5/12/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        share.isEnabled = false
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        setupTextfeild(textfeild: topTextField, text: "TOP")
        setupTextfeild(textfeild: bottomTextField, text: "BOTTOM")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        share.isEnabled = false
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // All `UIImagePickerControllerDelegate` methods here
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        imagePicker.image = image
        share.isEnabled = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePicker.image!, memedImage: generateMemedImage())
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
        dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(imagePicker.frame.size)
        view.drawHierarchy(in: imagePicker.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memedImage
    }
    
    func pickAnImage(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickAnImage(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickAnImage(source: .camera)
    }
    
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
            activity, success, items, error in
            if success { self.save() }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        if topTextField.text == "TOP" && bottomTextField.text == "BOTTOM" && imagePicker.image == nil {
            dismiss(animated: true, completion: nil)
        }
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePicker.image = nil
        share.isEnabled = false
    }
}

extension MemeEditorViewController: UITextFieldDelegate {
    // All `UITextFieldDelegate` methods here
    
    func setupTextfeild(textfeild: UITextField, text: String) {
        textfeild.defaultTextAttributes = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -4
        ]
        
        textfeild.textAlignment = .center
        textfeild.text = text
        textfeild.delegate = self
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = "" }
//        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            textField.resignFirstResponder()
//            return true }
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}


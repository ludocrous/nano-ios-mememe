//
//  CreateMemeViewController.swift
//  MemeMe
//
//  Created by Derek Crous on 23/07/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTitleTextField: UITextField!
    @IBOutlet weak var bottomTitleTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    
    private var screenShifted: Bool = false
    private var appDelegate: AppDelegate!
    var meme = Meme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as! AppDelegate
        
        //Set the image view content mode to aspect fit
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        //disbale camera button if device has no camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        topTitleTextField.delegate = self
        bottomTitleTextField.delegate = self
        
        var memeTextAttributes : [NSObject : AnyObject] = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : NSNumber(double: -3.0)        ]

        //Could assign meme array, but what happens to existing elements that aren't being overwritten??
        //        topTitleTextField.defaultTextAttributes += memeTextAttributes
        
        for (key , val) in memeTextAttributes {
            topTitleTextField.defaultTextAttributes[key] = val
            bottomTitleTextField.defaultTextAttributes[key] = val
        }
        topTitleTextField.textAlignment = NSTextAlignment.Center
        bottomTitleTextField.textAlignment = NSTextAlignment.Center
        topTitleTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        bottomTitleTextField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        
    }
    
    
    // MARK: Keyboard Handling
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        populateFields()
        checkMemeCompletion()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    private func subscribeToKeyboardNotifications() {
        //Subscribe to know when keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    private func unsubscribeToKeyboardNotifications () {
        //Unsubscribe
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // As Keyboard appears, if the bottom textfield if being edited the view must be adjusted upwards to keep it visible
        if bottomTitleTextField.isFirstResponder() {
            view.frame.origin.y -= getKeyboardHeight(notification)
            screenShifted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if screenShifted {
//            view.frame.origin.y = 0.0  // Could use 0 but would be too heavy handed if ever these were ever stacked
            view.frame.origin.y += getKeyboardHeight(notification)
             screenShifted = false
        }
    }
    
    private func getKeyboardHeight(notification : NSNotification) -> CGFloat {
        //Returns height of chosen keyboard
        let userinfo = notification.userInfo
        let keyboardSize = userinfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    // MARK: Button actions
    
    @IBAction func cancel(sender: AnyObject) {
        //Close this view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createAndShareMeme(sender: AnyObject) {
        //Fill in the meme object properties, and generate the meme image
        meme.topText = topTitleTextField.text
        meme.bottomText = bottomTitleTextField.text
        meme.memedImage = generateMemedImage()
        shareMeme()
    }
    
    @IBAction func takeImage(sender: UIBarButtonItem) {
        // Present the Image Picker with source Camera
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickImage(sender: AnyObject) {
        // Present the Image Picker with source Library
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // MARK: Image picker delegate methods
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageView.image = image
                meme.originalImage = image
            }
            dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        checkMemeCompletion()
    }
    
    // MARK: TextField Delegate methods
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topTitleTextField {
            if textField.text == "TOP" {
                textField.text = ""
            }
        } else if textField == bottomTitleTextField {
            if textField.text == "BOTTOM" {
                textField.text = ""
            }
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        checkMemeCompletion()
        return true
    }
    
    // MARK: Utility methods
    
    private func populateFields() {
        if meme.id != nil {
            topTitleTextField.text = meme.topText
            bottomTitleTextField.text = meme.bottomText
            imageView.image = meme.originalImage
        }
    }
    
    private func isCompleteMeme() -> Bool {
        // Making the assumption that user might want to set only top or bottom 
//        let result = (topTitleTextField.text == "TOP")  || (bottomTitleTextField.text == "BOTTOM")  ||
        let result = (topTitleTextField.text == "" && bottomTitleTextField.text == "") || meme.originalImage == nil
        // Return NOT result
        return !result
        
    }
    
    private func checkMemeCompletion() {
        // Function to control whether share button is enabled to ensure incomplete meme is not sent
        activityButton.enabled = isCompleteMeme()
    }
    
    private func saveMeme() {
        // Append the meme to array in the shared data model
        if meme.id == nil {
            appDelegate.memes.append(meme)
        } else {
            appDelegate.memes.replace(meme)
        }
    }
    
    private func shareMeme() {
        // Present memed image to activity controller for sharing/etc.
        if let image = meme.memedImage {
            let array: [AnyObject] = [image]
            let activityController = UIActivityViewController(activityItems: array, applicationActivities: nil)
            
            //Set the callback for the dismisal of the activityController
            activityController.completionWithItemsHandler = returnFromShare
            presentViewController(activityController, animated: true, completion: nil)
        }
    }
    
    func returnFromShare (activityType: String?, completed: Bool, returnedItems: [AnyObject]?, activityError: NSError?){
        // if successful then persist the meme in the memes array
        if completed {
            saveMeme()
        }
        //dismiss this create view controller to return to previous table/collection
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func generateMemedImage() -> UIImage {
        //Hide the controls to exclude them from the meme
        toolbar.hidden = true
        navigationBar.hidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        self.view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        //reshow the controls
        toolbar.hidden = false
        navigationBar.hidden = false
        
        return memedImage
    }
    
    
    
}

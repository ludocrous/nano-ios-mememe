//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Derek Crous on 23/07/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController {
    
    var meme: Meme?
    private var appDelegate: AppDelegate!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editMeme")
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as! AppDelegate
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    
        tabBarController?.tabBar.hidden = true
    
        imageView!.image = meme?.memedImage
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
    @IBAction func editMeme(sender: UIBarButtonItem) {
        if meme != nil {
            let createMemeController = storyboard!.instantiateViewControllerWithIdentifier("CreateMemeViewController") as! CreateMemeViewController
            //Hide the Table / Collection view options when creating
            createMemeController.hidesBottomBarWhenPushed = true
            createMemeController.meme = meme!
            presentViewController(createMemeController, animated: true, completion: nil)
        }
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func deleteMeme(sender: UIBarButtonItem) {
        if meme != nil {
            let controller = UIAlertController()
            controller.title = "Confirm"
            controller.message = "Are you sure you want to delete this meme?"
            let okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { action in
                self.appDelegate.memes.delete(self.meme!)
                self.dismissViewControllerAnimated(true, completion: nil)
                self.navigationController?.popViewControllerAnimated(true)
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { action in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            controller.addAction(cancelAction)
            presentViewController(controller, animated: true, completion: nil)
        }
    }
}
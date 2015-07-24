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
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editMeme")
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
    
    
    func editMeme() {
        // TODO: Implement view controller launch to Create View Controller
    }
}
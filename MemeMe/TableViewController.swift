//
//  ViewController.swift
//  MemeMe
//
//  Created by Derek Crous on 22/07/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UITableViewDataSource, UITableViewDelegate {
    
    var memes: [Meme]!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = memes[indexPath.row]
        
        cell.textLabel?.text = meme.topText
        cell.imageView?.image = meme.memedImage
        return cell
    }
    
    @IBAction func createMeme(sender: AnyObject) {
        let createMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeViewController") as! CreateMemeViewController
        createMemeController.hidesBottomBarWhenPushed = true
        self.presentViewController(createMemeController, animated: true, completion: nil)
    }
   
}


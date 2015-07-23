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
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! TableViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.originalImage
        cell.memeLabel.text = meme.topText! + " ... " + meme.bottomText!
        cell.memeTopTextLabel.text = meme.topText!
        cell.memeTopTextLabel.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 8)
        cell.memeTopTextLabel.textColor = UIColor.whiteColor()
        cell.memeTopTextLabel.shadowColor = UIColor.blackColor()

        cell.memeBottomTextLabel.text = meme.bottomText!
        cell.memeBottomTextLabel.font = UIFont(name: "HelveticaNeue-CondensedBlack", size: 8)
        cell.memeBottomTextLabel.textColor = UIColor.whiteColor()
        cell.memeBottomTextLabel.shadowColor = UIColor.blackColor()

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
//        detailController.villain = self.allVillains[indexPath.row]
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func createMeme(sender: AnyObject) {
        let createMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeViewController") as! CreateMemeViewController
        createMemeController.hidesBottomBarWhenPushed = true
        self.presentViewController(createMemeController, animated: true, completion: nil)
    }
   
}


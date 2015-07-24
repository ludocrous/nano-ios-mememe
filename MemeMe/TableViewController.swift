//
//  ViewController.swift
//  MemeMe
//
//  Created by Derek Crous on 22/07/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController,UITableViewDataSource, UITableViewDelegate {
    
    private var appDelegate: AppDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as! AppDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //Need to perform reloadData as when the view reappears of a new meme is added it should be refreshed to call numberOfRows etc.
        tableView.reloadData()
        //If Memes contains no data, automatically launch meme creator
        // This does imply that without sent memes the user will never get to the table view
        if appDelegate.autoCreateIfNoMemes && appDelegate.memes.count == 0 {
            createMeme(self)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! TableViewCell
        let meme = appDelegate.memes[indexPath.row]
        // Use original image with overlaid text fields rather than trying to display memedImage
        cell.memeImageView.image = meme.originalImage
        cell.memeLabel.text = meme.topText! + " ... " + meme.bottomText!
        
        // Replicate font as best as possible
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
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        detailController.meme = appDelegate.memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func createMeme(sender: AnyObject) {
        let createMemeController = storyboard!.instantiateViewControllerWithIdentifier("CreateMemeViewController") as! CreateMemeViewController
        //Hide the Table / Collection view options when creating
        createMemeController.hidesBottomBarWhenPushed = true
        presentViewController(createMemeController, animated: true, completion: nil)
    }
   
}


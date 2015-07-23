//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Derek Crous on 23/07/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
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
        self.collectionView?.reloadData()
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        let meme = memes[indexPath.row]
        cell.memeImageView?.image = meme.originalImage
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        //        detailController.villain = self.allVillains[indexPath.row]
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return memes.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
//        let meme = memes[indexPath.row]
//        
//        cell.textLabel?.text = meme.topText
//        cell.imageView?.image = meme.memedImage
//        return cell
//    }
    
    @IBAction func createMeme(sender: AnyObject) {
        let createMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeViewController") as! CreateMemeViewController
        createMemeController.hidesBottomBarWhenPushed = true
        self.presentViewController(createMemeController, animated: true, completion: nil)
    }
    
}

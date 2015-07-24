//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Derek Crous on 23/07/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
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
        self.collectionView?.reloadData()
        //If Memes contains no data, automatically launch meme creator
        // This does imply that without sent memes the user will never get to the collection view
        if appDelegate.autoCreateIfNoMemes && appDelegate.memes.count == 0 {
            createMeme(self)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        let meme = appDelegate.memes[indexPath.row]
        cell.memeImageView?.image = meme.originalImage
        
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
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        detailController.meme = appDelegate.memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    @IBAction func createMeme(sender: AnyObject) {
        let createMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeViewController") as! CreateMemeViewController
        createMemeController.hidesBottomBarWhenPushed = true
        presentViewController(createMemeController, animated: true, completion: nil)
    }
    
}

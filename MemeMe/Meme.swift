//
//  Meme.swift
//  MemeMe
//
//  Created by Derek Crous on 22/07/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit

struct Meme {
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var memedImage: UIImage?
    
    //TODO: Remove this code before release
    static func prepArray () -> [Meme] {
        var array = [Meme]()
        var meme = Meme()
        meme.bottomText = "Purple Patch ?"
        meme.topText = "should be something"
        meme.originalImage = UIImage(named: "Purple")
        meme.memedImage = UIImage(named: "MPurple")
        array.append(meme)
        
        meme.bottomText = "should be something"
        meme.topText = "Does a bear?"
        meme.originalImage = UIImage(named: "Forest")
        meme.memedImage = UIImage(named: "MForest")
        array.append(meme)
        return array
    }
}
//
//  Meme.swift
//  MemeMe
//
//  Created by Derek Crous on 22/07/2015.
//  Copyright (c) 2015 Ludocrous Software. All rights reserved.
//

import UIKit

struct Meme {
    var id: Int?
    var topText: String?
    var bottomText: String?
    var originalImage: UIImage?
    var memedImage: UIImage?
    
}

class MemeCollection {
    
    private var memes = [Meme]()
    private var nextMemeID = 0
    
    var count:  Int {
        get {
            return memes.count
        }
    }

    subscript(index: Int) -> Meme {
        return memes[index]
    }
    
    func append(var newMeme: Meme) {
        if newMeme.id == nil {
            newMeme.id = nextMemeID++
            memes.append(newMeme)
        }
    }
    
    func replace(currentMeme: Meme) {
        if let findID = currentMeme.id {
            let memeIndex = findIndexOfMemeById(findID)
            if memeIndex >= 0 {
                memes[memeIndex] = currentMeme
            } else {
                //TODO: Convert to exception
                println("Cannot find meme to replace - ID: \(currentMeme.id)")
            }
        }
    }
    
    func delete(currentMeme: Meme) {
        if let findID = currentMeme.id {
            let memeIndex = findIndexOfMemeById(findID)
            if memeIndex >= 0 {
                memes.removeAtIndex(memeIndex)
            } else {
                //TODO: Convert to exception
                println("Cannot find meme to delete - ID: \(currentMeme.id)")
            }
        }
        
    }
    
    private func findIndexOfMemeById (id: Int) -> Int {
        for (index,meme) in enumerate(memes) {
            if meme.id == id {
                return index
            }
        }
        return -1
    }
}
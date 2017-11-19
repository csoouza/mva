//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//

import SpriteKit

//use a swift extension to extend the intrinsic string class to have a length property. 

extension String {
    var length: Int {
        return self.characters.count
    }
}


extension SKEmitterNode {
    
    //Helper method to fetch the passed in particle effect file.
    class func pdc_nodeWithFile(fileName: String) -> SKEmitterNode? {
        //we will check the file basename and extension and if there is no extension, set it to "sks"
        let basename = (fileName as NSString).stringByDeletingPathExtension
        var fileExt = (fileName as NSString).pathExtension
        if fileExt.length == 0 {
            fileExt = "sks"
        }
        
        //grab the main bundle of our project and ask for the path to a resource that has the calculated basename and file extension. 
        if let path = NSBundle.mainBundle().pathForResource(basename, ofType: fileExt) {
            //Particle effects are automatically archived when created and we need to unarchive the effect file so it can be used as an SKEmitterNode object.
            let node = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! SKEmitterNode
        
            return node
            
        }
        
        return nil
        
    }
    
    //we want to add explosions to the two collisions involving photons vs obstacle and ship vs obstacle. We don't want the emitters to keep running indefinitely for these explosions so we will make them die out after a short duration.
    func pdc_dieOutInDuration(duration: NSTimeInterval) {
        
        //define two waiting periods for dellays because once we set the birthrate to zero, we will still need to wait before the particles die out. Otherwise the particles will vanish from the screen immediately. 
        let firstWait = SKAction.waitForDuration(duration)
        
        //set the birthrate property to zero in order to make the particle effect disappear using a SKAction code block.
        let stop = SKAction.runBlock {
            [weak self] in
            if let weakSelf = self {
                weakSelf.particleBirthRate = 0
            }
            
        }
        
        //get the second wait.
        let secondWait = SKAction.waitForDuration(NSTimeInterval(self.particleLifetime))
        
        let remove = SKAction.removeFromParent()
        
        runAction(SKAction.sequence([firstWait, stop, secondWait, remove]))
        
    }
    
}
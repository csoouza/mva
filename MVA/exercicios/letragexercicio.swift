//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//


import UIKit
import AVKit
import AVFoundation

class letragexercicio: UIViewController {
    
    var somintro = AVAudioPlayer()
    var gatinho = AVAudioPlayer()
    
    
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer:AVPlayer?
    
    
    @IBOutlet weak var introducao: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("animalletrag", ofType: "wav")!)
        
        do {
            // Preperation
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        
        // Play the sound
        do {
            somintro = try AVAudioPlayer(contentsOfURL: alertSound)
        } catch _{
        }
        
        
        somintro.prepareToPlay()
        somintro.play()
        
        
        
        
        
    }
    
    @IBAction func gatinho(sender: AnyObject) {
        // Set the sound file name & extension
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("gato", ofType: "wav")!)
        
        do {
            // Preperation
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        
        // Play the sound
        do {
            gatinho = try AVAudioPlayer(contentsOfURL: alertSound)
        } catch _{
        }
        
        
        gatinho.prepareToPlay()
        gatinho.play()
    }

    
}

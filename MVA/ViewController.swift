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

class ViewController: UIViewController {
    
    var somintro = AVAudioPlayer()
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer:AVPlayer?
    
    
    @IBOutlet weak var introducao: UIImageView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("intro", ofType: "wav")!)
        
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
        
        introducao.animationImages = [
            UIImage(named: "1.png")!,
            UIImage(named: "2.png")!,
            UIImage(named: "3.png")!,
            UIImage(named: "4.png")!,
            UIImage(named: "5.png")!,
            UIImage(named: "6.png")!,
            
        ]
        introducao.animationDuration = 5
        introducao.animationRepeatCount = 1
        introducao.startAnimating()
        
        
        
    }
    
    
    
    
}

//
//  ViewController.swift
//  teste
//
//  Created by Cleyton Souza on 20/05/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class letrab: UIViewController {
    
    var letraminuscula = AVAudioPlayer()
    var baleia = AVAudioPlayer()
    var letramaiuscula = AVAudioPlayer()
    
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer:AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let movieURL:NSURL? = NSURL(string: "http://colegiosoer.com.br/letrab.3gp")
        
        if let url = movieURL{
            self.avPlayer = AVPlayer(URL: url)
            self.avPlayerViewController.player = self.avPlayer
        }
        
        
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func animal(sender: AnyObject) {
        // Set the sound file name & extension
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("letrabbaleia", ofType: "wav")!)
        
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
            baleia = try AVAudioPlayer(contentsOfURL: alertSound)
        } catch _{
        }
        
      
        baleia.prepareToPlay()
        baleia.play()
        
        
    }

    @IBAction func letraminuscula(sender: AnyObject) {
        // Set the sound file name & extension
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("letrabminuscula", ofType: "wav")!)
        
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
            letraminuscula = try AVAudioPlayer(contentsOfURL: alertSound)
        } catch _{
        }
        
        
        letraminuscula.prepareToPlay()
        letraminuscula.play()
        
        
        
    }

    @IBAction func letramaiuscula(sender: AnyObject) {
        // Set the sound file name & extension
        let alertSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("letrabmaiuscula", ofType: "wav")!)
        
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
            letramaiuscula = try AVAudioPlayer(contentsOfURL: alertSound)
        } catch _{
        }
        
        
        letramaiuscula.prepareToPlay()
        letramaiuscula.play()
        
        
        
    }
    
    
    
    @IBAction func videoa(sender: UIButton) {
            self.presentViewController(self.avPlayerViewController, animated: true) { () -> Void in
                
                self.avPlayerViewController.player?.play()
            }

    }
    
}

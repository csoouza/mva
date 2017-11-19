//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//

import Foundation
import SpriteKit


class Properties
{

    static var fadeTime = 10.0
    
    static let startingLives = 3
    static let maxLives = 7
    
    static let maxHeartChance = 0.5
    static let maxLightChance = 0.55
    static var heartChance = 0.20
    static var lightChance = 0.20
    

    static let colour_ui = SKColor(red: 25/255.0, green: 30/255.0, blue: 45/255.0, alpha: 1.0)
    static let colour_wall = SKColor(red: 35/255.0, green: 40/255.0, blue: 55/255.0, alpha: 1.0)
    static let colour_space = SKColor.whiteColor()
    static let colour_start = SKColor(red: 0/255.0, green: 135/255.0, blue: 252/255.0, alpha: 1.0)
    static let colour_goal = SKColor(red: 0/255.0, green: 255/255.0, blue: 150/255.0, alpha: 1.0)
    static let colour_hit = SKColor.redColor()
    static let colour_hit_fade = SKColor(red: 0.45, green: 0.0, blue: 0, alpha: 1.0)
    static let colour_visit = SKColor(red: 102/255.0, green: 233/255.0, blue: 250/255.0, alpha: 1.0)

    
}

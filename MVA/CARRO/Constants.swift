//
//  Constants.swift
//  MVA
//
//  Created by Cleyton Souza on 11/05/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//

import UIKit

enum IndicatorState{
    case right
    case left
    case off
}
enum TrafficLightState{
    case green
    case red
}

struct Layer {
    static let Background : CGFloat = 0
    static let Car : CGFloat = 1
    static let Brakes : CGFloat = 2
    static let otherStuff : CGFloat = 3
    static let gameOver : CGFloat = 4
    
}
typealias CompletionBlock = NSString? -> Void

struct BezierType {
    static let Straight = "Straight"
    static let Right = "Right"
    static let Left = "Left"
}
struct Category {
    static let Car: UInt32 = 1
}
struct Names {
    static let Car = "car"
    static let Brakes = "brakes"
    static let Block = "block"
}

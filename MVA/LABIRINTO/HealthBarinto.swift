//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//
import Foundation
import SpriteKit

class HealthBar: SKSpriteNode
{
    let heartSize:CGFloat = 22.0
    var hearts = [SKSpriteNode]()
    var heartsContainer = SKSpriteNode()
    var deadLabel = SKLabelNode(fontNamed: "Avenir Next Heavy")
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        deadLabel.fontColor = SKColor.whiteColor()
        deadLabel.fontSize = 20
        deadLabel.text = "JOGAR NOVAMENTE!"
        deadLabel.position = CGPoint(x: 0, y: -deadLabel.frame.size.height / 2)
        deadLabel.hidden = true
        self.addChild(deadLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLives(lives:Int)
    {
        for heart in hearts
        {
            heart.hidden = true
            heart.removeFromParent()
        }
        hearts.removeAll()
        
        if lives > 0
        {
            
            let gap = heartSize + 10
            let startingX = gap * CGFloat(lives) / 2.0
            for i in 0 ... lives - 1
            {
                let heart = SKSpriteNode(imageNamed: "heart")
                heart.size = CGSize(width: heartSize, height: heartSize)
                heart.position = CGPoint(x: gap * CGFloat(i) + heartSize / 2 - startingX, y: 0)
                hearts.append(heart)
                self.addChild(heart)
            }
        }
        else
        {
            deadLabel.hidden = false
        }
    }
}
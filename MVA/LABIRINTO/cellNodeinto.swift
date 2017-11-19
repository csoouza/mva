//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//

import SpriteKit

class cellNode: SKSpriteNode {
    
    var cell:SKSpriteNode!
    var i:Int!
    var j:Int!
    var type:Cell!
    var visited = false
    var visitable = false
    var hasHeart = false
    var hasLight = false
    
    var top_node:cellNode?
    var rig_node:cellNode?
    var bot_node:cellNode?
    var lef_node:cellNode?
    var mask:SKSpriteNode!
    
    
    func create(name: String, pos: CGPoint, size: CGSize, i:Int, j:Int)
    {
        cell = SKSpriteNode(color: SKColor.whiteColor(), size: size)
        mask = SKSpriteNode(color: Properties.colour_visit, size: size)
        mask.alpha = 0.0
        position = CGPoint(x: pos.x + size.width / 2, y: pos.y + size.height / 2)
        self.i = i
        self.j = j
        self.name = name
        type = Cell.Space
        
        

        self.addChild(cell)
        self.addChild(mask)
        

    }
    
    
    func toStart()
    {
        //cell.color = Properties.colour_start
        type = Cell.Start
    }
    
    func toGoal()
    {
        cell.color = Properties.colour_goal
        type = Cell.Goal
    }
    
    func toWall()
    {
        cell.color = Properties.colour_wall
        type = Cell.Wall
    }
    
    
    func toSpace()
    {
        cell.color = Properties.colour_space
        type = Cell.Space
    }
    
    func visit()
    {
        visited = true
        visitable = false
        if type != Cell.Goal
        {
            mask.alpha = 1.0
        }
    }
    func unvisit()
    {
        visited = false
        mask.runAction(SKAction.fadeOutWithDuration(0.75))
        
    }
    
    func makeVisitable()
    {
        visitable = true
        //cell.color = UIColor.greenColor()
    }
    
    func hitWall()
    {
        if type == Cell.Wall
        {
            mask.alpha = 0.0
            cell.color = Properties.colour_hit
            let changeColorAction = SKAction.colorizeWithColor(Properties.colour_hit_fade, colorBlendFactor: 1.0, duration: 1.0)
            cell.runAction(changeColorAction)
        }
    }
    
    func fade()
    {
        let changeColorAction = SKAction.colorizeWithColor(Properties.colour_wall, colorBlendFactor: 1.0, duration: Properties.fadeTime)
        cell.runAction(changeColorAction, withKey: "fade")
    }
    
    func resetFade()
    {
        cell.removeActionForKey("fade")
        if type == Cell.Space
        {
            cell.color = Properties.colour_space
            fade()
        }
    }
    
    func removeNodes()
    {
        cell.removeFromParent()
        mask.removeFromParent()
        self.removeFromParent()
    }
    
    func placeHeart()
    {
        hasHeart = true
        let heart = SKSpriteNode(imageNamed: "heart")
        heart.name = "heart"
        heart.size = CGSize(width: 22.0, height: 22.0)
        self.addChild(heart)
    }
    
    func removeHeart()
    {
        hasHeart = false
        if let node = childNodeWithName("heart")
        {
            node.removeFromParent()
        }
    }
    
    func placeLight()
    {
        hasLight = true
        let light = SKSpriteNode(imageNamed: "light")
        light.name = "light"
        light.size = CGSize(width: 14.3, height: 22.0)
        self.addChild(light)
    }
    
    func removeLight()
    {
        hasLight = false
        if let node = childNodeWithName("light")
        {
            node.removeFromParent()
        }
    }
    
    
    func dead()
    {
        print("dead")
        //cell.hidden = true
        mask.hidden = true
        cell.texture = SKTexture(imageNamed: "dead")
        removeHeart()
        removeLight()
    }
    
    
    
    
}
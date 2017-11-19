//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//
//
//TODO: Edit position and alignment for healthGroup, healthTitle, and healthValue
//TODO: Add weapons power up time remaining.

import SpriteKit

//Create a HUD (Heads-Up-Display) that will hold all our display areas.
//Once the node is added ot the scene we'll tell it to lay out it's child nodes.
//The child nodes will not contain labels as we will use blank nodes as group containers and lay out the label nodes inside of them.
class HUDNode: SKNode {
    
    //Build two parent nodes as groups to hold the score and elabsed time info. Each group will have title and value labels.
    private let ScoreGroupName = "scoreGroup"
    private let ScoreValueName = "scoreValue"
    
    private let ElapsedGroupName = "elapsedGroup"
    private let ElapsedValueName = "elapsedValue"
    private let TimerActionName = "elapsedGameTimer"
    
    private let HealthGroupName = "healthGroup"
    private let HealthValueName = "healthValue"
    
    private let PowerupGroupName = "powerupGroup"
    private let PowerupValueName = "powerupValue"
    private let PowerupTimerActionName = "powerupGameTimer"

    
    var elapsedTime: NSTimeInterval = 0.0
    var score: Int = 0
    var health = "50%"
    
    lazy private var scoreFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter
    }()
    
    lazy private var timeFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        
        return formatter
    }()

    //Our class initializer 
    override init() {
        super.init()
        let scoreGroup = SKNode()
        scoreGroup.name = "scoreGroup"
        
        addChild(scoreGroup)
        
        let scoreTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        scoreTitle.name = "scoreTitle"
        scoreTitle.fontSize = 12.0
        scoreTitle.fontColor = SKColor.whiteColor()
        
        //set the vertical and horizontal alignment modes in a way that will help us to lay out the labels inside this group node.
        scoreTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        scoreTitle.text = "PONTOS"
        
        //The child nodes are positioned relative to the parent nodes origin point (the group)
        scoreTitle.position = CGPoint(x: -20.0, y: -510.0)
        
        scoreGroup.addChild(scoreTitle)
        let scoreValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreValue.name = ScoreValueName
        scoreValue.fontSize = 20.0
        scoreValue.fontColor = SKColor.whiteColor()

        scoreValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        scoreValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        scoreValue.text = "0"
        
        scoreValue.position = CGPoint(x: -20.0, y: -510.0)
        scoreGroup.addChild(scoreValue)
        
        
        //We need to do the same setup for our elapsed time.
        let elapsedGroup = SKNode()
        elapsedGroup.name = "elapsedGroup"
        
        addChild(elapsedGroup)
        
        let elapsedTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        elapsedTitle.name = "elapsedTitle"
        elapsedTitle.fontSize = 12.0
        elapsedTitle.fontColor = SKColor.whiteColor()
        
        //set the vertical and horizontal alignment modes in a way that will help us to lay out the labels inside this group node.
        elapsedTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        elapsedTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        elapsedTitle.text = "TEMPO"
        
        //The child nodes are positioned relative to the parent nodes origin point (the group)
        elapsedTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        elapsedGroup.addChild(elapsedTitle)
        let elapsedValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        elapsedValue.name = ElapsedValueName
        elapsedValue.fontSize = 20.0
        elapsedValue.fontColor = SKColor.whiteColor()
        
        elapsedValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        elapsedValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        elapsedValue.text = "0.0s"
        
        elapsedValue.position = CGPoint(x: 0.0, y: -4.0)
        elapsedGroup.addChild(elapsedValue)

        
        //We need to do the same setup for our health time.
        let healthGroup = SKNode()
        healthGroup.name = "healthGroup"
        
        addChild(healthGroup)
        
        let healthTitle = SKLabelNode(fontNamed: "AvenirNext-Medium")
        healthTitle.name = "healthTitle"
        healthTitle.fontSize = 12.0
        healthTitle.fontColor = SKColor.whiteColor()
        
        //Edit these values for health
        healthTitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        healthTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        healthTitle.text = "VIDA"
        
        //Edit position value for health
        healthTitle.position = CGPoint(x: 0.0, y: -30.0)
        
        healthGroup.addChild(healthTitle)
        let healthValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        healthValue.name = HealthValueName
        healthValue.fontSize = 20.0
        healthValue.fontColor = SKColor.whiteColor()
        
        healthValue.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        healthValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        healthValue.text = "50%"
        
        healthValue.position = CGPoint(x: 0.0, y: -50.0)
        healthGroup.addChild(healthValue)
        
        //Do the same setup for weapons power up time.
        let powerupGroup = SKNode()
        powerupGroup.name = "powerupGroup"
        
        addChild(powerupGroup)
        
        let powerupTitle = SKLabelNode(fontNamed: "AvenirNext-Bold")
        powerupTitle.name = "powerupTitle"
        powerupTitle.fontSize = 14.0
        powerupTitle.fontColor = SKColor.redColor()

        powerupTitle.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Bottom
        powerupTitle.text = "TIRO EXTRA!!"
        
        powerupTitle.position = CGPoint(x: 0.0, y: 4.0)
        
        //set up actions to make our powerup timer pulse.
        let pulse = SKAction.sequence([SKAction.scaleTo(1.3, duration: 0.3), SKAction.scaleTo(1.0, duration: 0.3)])
        
        powerupTitle.runAction(SKAction.repeatActionForever(pulse))
        
        powerupGroup.addChild(powerupTitle)
        
        let powerupValue = SKLabelNode(fontNamed: "AvenirNext-Bold")
        powerupValue.name = PowerupValueName
        powerupValue.fontSize = 20.0
        powerupValue.fontColor = SKColor.redColor()
        
        powerupValue.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        powerupValue.text = "0s Restantes"
        
        powerupValue.position = CGPoint(x: 0.0, y: -4.0)
        powerupGroup.addChild(powerupValue)
        
        powerupGroup.alpha = 0 // make it invisible to start.
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Our labels are properly layed out within their parent group nodes, but the group nodes are centered on the scene. We need to create some layout method so that these group nodes are properly positioned to the top left and top right corners of the scene.
    func layoutForScene(){
        
        //Note: when a node exists in the Scene Graph, it can get access to the scene (GameScene) via its scene property. That property is nil if the node doesn't belong to a scene yet, so this method would be useless if the node is not yet added to a scene. 
        if let scene = scene {
            let sceneSize = scene.size
            var groupSize = CGSizeZero //used to calculate position of each group.
            if let scoreGroup = childNodeWithName(ScoreGroupName){
                //Get calculated size of our scoreGroup node(rectangular)
                groupSize = scoreGroup.calculateAccumulatedFrame().size
                scoreGroup.position = CGPoint(x: 0.0 - sceneSize.width/2.0 + 20.0, y: sceneSize.height/2.0 - groupSize.height)
                
            } else {
                assert(false, "No score group node was found in the scene graph tree")
            }
            
            if let elapsedGroup = childNodeWithName(ElapsedGroupName){
                groupSize = elapsedGroup.calculateAccumulatedFrame().size
                elapsedGroup.position = CGPoint(x: sceneSize.width/2.0 - 20.0, y: sceneSize.height/2.0 - groupSize.height)
                
            } else {
                assert(false, "No elapsed group node was found in the scene graph tree")
            }
            
            if let healthGroup = childNodeWithName(HealthGroupName){
                groupSize = healthGroup.calculateAccumulatedFrame().size
                healthGroup.position = CGPoint(x: 0.0 - sceneSize.width/4.0 + 60.0, y: sceneSize.height/2.0 - groupSize.height)
                
            } else {
                assert(false, "No health group node was found in the scene graph tree")
            }
            
            if let powerupGroup = childNodeWithName(PowerupGroupName){
                groupSize = powerupGroup.calculateAccumulatedFrame().size
                powerupGroup.position = CGPoint(x: 0.0, y: sceneSize.height/2.0 - groupSize.height - 75.0)
                
            } else {
                assert(false, "No powerup group node was found in the scene graph tree")
            }


            
        }
        
    }
    
    func showPowerupTimer(time: NSTimeInterval) {
        
        if let powerupGroup = childNodeWithName(PowerupGroupName){
            
            //remove any existing action with the following key because we want to restart the timer as we are calling this method as a result of the player collecting another weapons powerup.
            powerupGroup.removeActionForKey(PowerupTimerActionName)
            
            //look up our powerValue label by name
            if let powerupValue = powerupGroup.childNodeWithName(PowerupValueName) as! SKLabelNode?{
                
                //run the countdown timer sequence. 
                let start = NSDate.timeIntervalSinceReferenceDate()
                let block = SKAction.runBlock{
                    [weak self] in
                    
                    if let weakSelf = self {
                        
                        let elapsed = NSDate.timeIntervalSinceReferenceDate() - start
                        
                        let timeLeft = max(time - elapsed, 0)
                        
                        let timeLeftFormat = weakSelf.timeFormatter.stringFromNumber(timeLeft)!
                        
                        powerupValue.text = "\(timeLeftFormat)s Restantes"
                        
                    }
                
                }
                
                let countdownSequence = SKAction.sequence([block, SKAction.waitForDuration(0.05)])
                let countdown = SKAction.repeatActionForever(countdownSequence)
                
                let fadeIn = SKAction.fadeAlphaTo(1.0, duration: 0.1)
                let wait = SKAction.waitForDuration(time)
                let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.1)
                let stopAction = SKAction.runBlock({ () -> Void in
                    powerupGroup.removeActionForKey(self.PowerupTimerActionName)
                })
                
                let visuals = SKAction.sequence([fadeIn, wait, fadeOut, stopAction])
                powerupGroup.runAction(SKAction.group([countdown, visuals]), withKey: self.PowerupTimerActionName)
                
            }
            
        }

    }
    
    func addPoints(points: Int) {
     
        score += points
        //look up the score value by name in the Scene Graph. Note: the ScoreValueName is a direct child of ScoreGroupName which is a direct child of the scene. So we need to reference it via a path.
        if let scoreValue = childNodeWithName("\(ScoreGroupName)/\(ScoreValueName)") as! SKLabelNode? {
            
            //format our score with the thousands separator so we will use our cached self.scoreFormatter property.
            
            scoreValue.text = scoreFormatter.stringFromNumber(score)
            
            //Scale the node up for a brief period then scale it back down to create a pulse effect.
            let scale = SKAction.scaleTo(1.1, duration: 0.02)
            let shrink = SKAction.scaleTo(1, duration: 0.07)
            scoreValue.runAction(SKAction.sequence([scale, shrink]))
            
        }
        
    }
    
    func startGame() {
        
        //calculate the time stamp when starting the game. 
        let startTime = NSDate.timeIntervalSinceReferenceDate()
        if let elapsedValue = childNodeWithName("\(ElapsedGroupName)/\(ElapsedValueName)") as! SKLabelNode? {
            
            //use a code block to update the elapsedTime property to be the difference between the startTime timestamp and the current timestamp
            let update = SKAction.runBlock({ [weak self] in
                
                if let weakSelf = self {
                    let now = NSDate.timeIntervalSinceReferenceDate()
                    weakSelf.elapsedTime = now - startTime
                    
                    elapsedValue.text = weakSelf.timeFormatter.stringFromNumber(weakSelf.elapsedTime)
                }
                
            })
            
            let updateAndDelay = SKAction.sequence([update, SKAction.waitForDuration(0.05)])
            let timer = SKAction.repeatActionForever(updateAndDelay)
            runAction(timer, withKey: TimerActionName)
            
        }
    }
    
    func endGame() {
        
        //To stop the timer sequence set up in startGame(), we need to remove the action for the key we used (TimerActionName)
        removeActionForKey(TimerActionName)
        
    }
    
    func changeHealth(newHealthValue: Double) {
        if let healthValue = childNodeWithName("\(HealthGroupName)/\(HealthValueName)") as! SKLabelNode? {
            switch newHealthValue {
            case 0:
                health = "0%"
            case 1:
                health = "25%"
            case 2:
                health = "50%"
            case 3:
                health = "75%"
            case 4:
                health = "100%"
            default:
                health = "50%"
            }
            healthValue.text = health
        }
    }

    
}
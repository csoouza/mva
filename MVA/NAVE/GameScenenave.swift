//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//
import SpriteKit

class GameScenenave: SKScene {
    
    //Class Properties
    private let SpaceshipNodeName = "ship"
    private let PhotonTorpedoNodeName = "photon"
    private let ObstacleNodeName = "obstacle"
    private let PowerUpNodeName = "powerup"
    private let HealthPowerUpNodeName = "healthpowerup"
    private let ShieldNodeName = "shield"
    private let HUDNodeName = "hud"
    private let TenPointPowerupNodeName = "tenPointBooster"
    private let TwentyPointPowerupNodeName = "twentyPointBooster"
    
    //properties to hold sound actions. We will be preloading our sounds into these properties. 
    private let shootSound: SKAction = SKAction.playSoundFileNamed("laserShot.wav", waitForCompletion: false)
    private let obstacleExplodeSound: SKAction = SKAction.playSoundFileNamed("darkExplosion.wav", waitForCompletion: false)
    private let shipExplodeSound: SKAction = SKAction.playSoundFileNamed("explosion.wav", waitForCompletion: false)
    
    private weak var shipTouch: UITouch?
    private var lastUpdateTime: NSTimeInterval = 0
    private var lastShotFireTime: NSTimeInterval = 0
    
    private let defaultFireRate: Double = 0.5
    private var shipFireRate: Double = 0.5
    private let powerUpDuration: NSTimeInterval = 5.0
    
    private var shipHealthRate: Double = 2.0
    
    
    //we will be using the particle emitters for our explosions repeatedly. We do not want to load them from their files every time. Instead we will create class properties and cache them for quick reuse. Very much like we did for our sound related properties. (preloading)
    private let shipExplodeTemplate: SKEmitterNode = SKEmitterNode.pdc_nodeWithFile("ShipExplode.sks")!
    private let obstacleExplodeTemplate: SKEmitterNode = SKEmitterNode.pdc_nodeWithFile("ObstacleExplode.sks")!
    
    override init(size: CGSize) {
        
        super.init(size: size)
        setupGame(size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
        setupGame(self.size)
    }
    
    func setupGame(size: CGSize) {
        
        let ship = SKSpriteNode(imageNamed: "Spaceship.png")
        ship.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        
        ship.size = CGSize(width: 40.0, height: 40.0)
        
        ship.name = SpaceshipNodeName
        addChild(ship)
        
        
        let shield = SKSpriteNode(imageNamed: "shield")
        shield.name = ShieldNodeName
        shield.position = CGPoint(x: size.width/2.0, y: size.height/2.0)
        shield.size = CGSize(width: 100.0, height: 100.0)
        shield.alpha = 0.5
        
        addChild(shield)
        //add our starfield parallax effect to the scene by creating an instance of our starfield class and adding as a child to the scene.
        addChild(StarField())
        
        
        //add ship thruster particle to our ship as a child.
        if let shipThruster = SKEmitterNode.pdc_nodeWithFile("Thrust.sks") {
            shipThruster.position = CGPoint(x:0.0 , y:-22.0)
            ship.addChild(shipThruster)
        }
        
        // Set up our HUD
        let hudNode = HUDNode() //instantiating our HUDNode class
        hudNode.name = HUDNodeName
        
        // by default, nodes will overlap (stack) according to the order in which they are added to the scene. If we want to change this order, we can use a node's zPosition property to do so.
        
        hudNode.zPosition = 100.0
        
        //set the position of our HUD to the center of the screen. Noting that all child nodes are positioned relative to the parent node's origin point.
        hudNode.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(hudNode)
        
        //Lay out of score, elapsed time, and health nodes. 
        hudNode.layoutForScene()
        hudNode.startGame()
    }
    
    /*override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Hello, World!"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }*/
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        /*for touch in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }*/
        
        //Grab any touches noting that touches is a "set" of any touch event that has occured. 
        //stored in an if statement to guard against value being nil.
        if let touch = touches.first {
            //locate the touch point
            /*let touchPoint = touch.locationInNode(self)
            
            if let ship = self.childNodeWithName(SpaceshipNodeName){
                
                ship.position = touchPoint

            
            }*/
            self.shipTouch = touch
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        //calculate the time change (delta) since the last frame executed. 
        let timeDelta = currentTime - lastUpdateTime
        
        
        
        if let shipTouch = self.shipTouch {
            
            //Use the GameScene's childNodeWithName() method to reobtain a reference to our ship using it's name property value from the SpriteKit's Scene Graph (node family tree)
            
            /*if let ship = self.childNodeWithName(SpaceshipNodeName){
                
                ship.position = shipTouch.locationInNode(self)
                
                
            }*/
            
            moveShipTowardPoint(shipTouch.locationInNode(self), timeChange: timeDelta)
            moveShieldTowardPoint(shipTouch.locationInNode(self), timeChange: timeDelta)
            
            // We only want photon torpedos to launch from our ship when the user's finger is in contact with the screen and if the difference between current time and last time a torpedo was fired is greater than half a second. 
            if currentTime - lastShotFireTime > shipFireRate {
                
                //fire a photon torpedo
                shoot()
                
                lastShotFireTime = currentTime
                
            }
            
        }
        
        //Release asteroid obstacles 1.5% of the time a frame is drawn
        //This number could be altered to 
        
        if arc4random_uniform(1000) <= 15 {
            
            //dropAsteroid()
            dropThing()
            
        }
        
        checkCollisions()
        updateHealth()
        
        //update lastUPdateTime
        lastUpdateTime = currentTime
    }
    
    func moveShieldTowardPoint(point: CGPoint, timeChange: NSTimeInterval) {
        
        let shieldSpeed = CGFloat(300)
        
        if let shield = self.childNodeWithName(ShieldNodeName){
            
            //using the Pythagorean Theorem, determine the distance between the ship's current position and the touch point.
            let distanceLeftToTravel = sqrt(pow(shield.position.x - point.x, 2) + pow(shield.position.y - point.y, 2))
            //If the distance left to travel is greater than 4 points keep moving the shield.
            //Otherwise, stop moving the shield because we may expereince "jitter" aroudn the touch point (due to impercision in floating point numbrs) if we get too close.
            
            if distanceLeftToTravel > 4 {
                //Calculate how far we should move the shield during this frame.
                let howFarToMove = CGFloat(timeChange) * shieldSpeed
                
                //Convert the distance remaining back into (x,y) coordinates using the atan2 function to determine the proper angle based on shield's position and destination.
                let angle = atan2(point.y - shield.position.y, point.x - shield.position.x)
                
                //Then, using the angel with sine and cosine trig functions determine the x and y offset values
                let xOffset = howFarToMove * cos(angle)
                let yOffset = howFarToMove * sin(angle)
                
                //Use the offsets to reposition the shield
                shield.position = CGPoint(x: shield.position.x + xOffset, y: shield.position.y + yOffset)
                
                
                
            }
            
        }
    }

    
    //nudge the ship towards the touch point (CGPoint) by an appropriate amount based on elapsed time (timeDelta) since the last frame.
    func moveShipTowardPoint(point: CGPoint, timeChange: NSTimeInterval) {

        let shipSpeed = CGFloat(300)
        
        if let ship = self.childNodeWithName(SpaceshipNodeName){
            
            //using the Pythagorean Theorem, determine the distance between the ship's current position and the touch point. 
            let distanceLeftToTravel = sqrt(pow(ship.position.x - point.x, 2) + pow(ship.position.y - point.y, 2))
            //If the distance left to travel is greater than 4 points keep moving the ship.
            //Otherwise, stop moving the ship because we may expereince "jitter" aroudn the touch point (due to impercision in floating point numbrs) if we get too close. 
            
            if distanceLeftToTravel > 4 {
                //Calculate how far we should move the ship during this frame.
                let howFarToMove = CGFloat(timeChange) * shipSpeed
                
                //Convert the distance remaining back into (x,y) coordinates using the atan2 function to determine the proper angle based on ship's position and destination. 
                let angle = atan2(point.y - ship.position.y, point.x - ship.position.x)
                
                //Then, using the angel with sine and cosine trig functions determine the x and y offset values
                let xOffset = howFarToMove * cos(angle)
                let yOffset = howFarToMove * sin(angle)
                
                //Use the offsets to reposition the ship
                ship.position = CGPoint(x: ship.position.x + xOffset, y: ship.position.y + yOffset)

                
                
            }
            
        }
        
    }
    
    
    //shoot a photon torpedo from our shield
    
    func shoot() {
        
        if let ship = self.childNodeWithName(SpaceshipNodeName){
         
            let photon = SKSpriteNode(imageNamed: "photon")
            
            photon.name = PhotonTorpedoNodeName
            photon.position = ship.position
            self.addChild(photon)
            
            //Create a sequence of actions (SKAction class) that will move the torpedos up and off the top of the screen and then remove them so they don't continue to take up memory. Otherwise we'd have a memory leak. 
            
            //Move the torpedo from it's original position (ship) past the top edge of the screen (scene) (by the size of the photon over half a second. The y-axis in SpriteKit is flipped back to normal (0,0) is the bottom left corner and scene height (self.size.height) is the top edge of the scene. 
            let fly = SKAction.moveByX(0, y: self.size.height + photon.size.height, duration: 0.5)
            
            //Run the previous action
            //photon.runAction(fly)
            
            let remove = SKAction.removeFromParent()
            
            let fireAndRemove = SKAction.sequence([fly, remove])
            
            photon.runAction(fireAndRemove)
            
            self.runAction(self.shootSound)
            
        }
        
    }
    
    func dropThing(){
        
        let dieRoll = arc4random_uniform(100) //value between 0 and 99
        
        if dieRoll < 3 {
            dropHealth()
        }else if dieRoll < 7 {
            dropTwentyBooster()
        }else if dieRoll < 15{
            dropTenBooster()
        }else if dieRoll < 20 {
            dropWeaponsPowerUp()
        } else if dieRoll < 35 {
            dropEnemyShip()
        } else {
            dropAsteroid()
        }
    
    }
    
    func dropTenBooster() {
        let sideSize = 30.0
        
        let startX = Double(arc4random_uniform(uint(self.size.width - 60)) + 30)
        
        let startY = Double(self.size.height) + sideSize
        
        let endY = 0 - sideSize
        
        let tenBooster = SKSpriteNode(imageNamed: "tenPointBooster")
        tenBooster.name = TenPointPowerupNodeName
        tenBooster.size = CGSize(width: sideSize, height: sideSize)
        tenBooster.position = CGPoint(x: startX, y: startY)
        
        addChild(tenBooster)
        
        let move = SKAction.moveTo(CGPoint(x: startX, y: endY), duration: 8)
        let remove = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([move, remove])
        let scale = SKAction.scaleTo(0.5, duration: 8)
        let fade = SKAction.fadeOutWithDuration(8)
        
        tenBooster.runAction(SKAction.group([moveAndRemove, scale, fade]))
        

        
    }
    
    func dropTwentyBooster() {
        let sideSize = 20.0
        
        let startX = Double(arc4random_uniform(uint(self.size.width - 60)) + 30)
        
        let startY = Double(self.size.height) + sideSize
        
        let endY = 0 - sideSize
        
        let twentyBooster = SKSpriteNode(imageNamed: "twentyPointBooster")
        twentyBooster.name = TwentyPointPowerupNodeName
        twentyBooster.size = CGSize(width: 20.0, height: 20.0)
        twentyBooster.position = CGPoint(x: startX, y: startY)
        
        addChild(twentyBooster)
        
        let move = SKAction.moveTo(CGPoint(x: startX, y: endY), duration: 3)
        let remove = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([move, remove])
        let scale = SKAction.scaleTo(0.5, duration: 3)
        let fade = SKAction.fadeOutWithDuration(3)
        
        twentyBooster.runAction(SKAction.group([moveAndRemove, scale, fade]))

    }
    
    
    //Drop health power up function.
    func dropHealth() {
        
        let sideSize = 20.0
        
        let startX = Double(arc4random_uniform(uint(self.size.width - 60)) + 30)
        
        let startY = Double(self.size.height) + sideSize
        
        let endY = 0 - sideSize
        
        let shipHealth = SKSpriteNode(imageNamed: "healthPowerUp")
        shipHealth.name = HealthPowerUpNodeName
        shipHealth.size = CGSize(width: 20.0, height: 20.0)
        shipHealth.position = CGPoint(x: startX, y: startY)
        
        addChild(shipHealth)
        
        let move = SKAction.moveTo(CGPoint(x: startX, y: endY), duration: 5)
        let remove = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([move, remove])
        let scale = SKAction.scaleTo(0.5, duration: 5)
        let fade = SKAction.fadeOutWithDuration(5)
        
        shipHealth.runAction(SKAction.group([moveAndRemove, scale, fade]))
        
    }
    
    func dropAsteroid() {
        
        //Define asteroid size - will be a random number between 15 and 44
        
        let sideSize = Double(arc4random_uniform(30) + 15)
        
        //Maximium X-Value for the scene
        let maxX = Double(self.size.width)
        
        let quarterX = maxX / 4.0
        
        let randRange = UInt32(maxX + (quarterX * 2))
        
        //arc4random_uniform() wants a UInt32 value passed into it...
        //Determine random starting value for asteroid's x-position
        let startX = Double(arc4random_uniform(randRange)) - quarterX
        
        let startY = Double(self.size.height) + sideSize
    
        let endX = Double(arc4random_uniform(UInt32(maxX)))
        
        let endY = 0.0 - sideSize //below the bottom edge
        
        //create the asteroid sprite
        let asteroid = SKSpriteNode(imageNamed: "asteroidnew")
        asteroid.size = CGSize(width: sideSize, height: sideSize)
        
        asteroid.position = CGPoint(x: startX, y: startY)
        asteroid.name = ObstacleNodeName
        self.addChild(asteroid)
        
        
        //Run some actions to get our asteroid moving...
        //Move the asteroid to a randomly generated point over a duration of 3 to 6 seconds. 
        
        let move = SKAction.moveTo(CGPoint(x: endX, y: endY), duration: Double(arc4random_uniform(4) + 3))
        
        let remove = SKAction.removeFromParent()
        
        let travelAndRemove = SKAction.sequence([move, remove])
        
        //rotate the asteroid by 3 radians (just less than 180 degrees) over 1 to 3 seconds duration.
        let spin = SKAction.rotateByAngle(3, duration: Double(arc4random_uniform(3) + 1))
        
        let spinForever = SKAction.repeatActionForever(spin)
        
        let all = SKAction.group([travelAndRemove, spinForever])
        
        asteroid.runAction(all)

        
    }
    
    func dropEnemyShip() {
        
        let sideSize = 30.0
        
        //Determine random starting value for enemy ship's x and y positions.
        let startX = Double(arc4random_uniform(uint(self.size.width - 40)) + 20)
        
        let startY = Double(self.size.height) + sideSize
        
        //create enemy ship and set its properties.
        let enemy = SKSpriteNode(imageNamed: "enemy")
        
        enemy.size = CGSize(width: sideSize, height: sideSize)
        enemy.position = CGPoint(x: startX, y: startY)
        enemy.name = ObstacleNodeName
        self.addChild(enemy)
        
        //set up enemy movement
        //We want the enemy ship to follow a curved (Bezier) path which uses control points to define how teh curved path is formed. 
        //The following method will return that path.
        let shipPath = buildEnemyShipMovementPath()
        
        //Use the provided path to move our enemy ship
        //asOffset parameter: if set to true, lets us treat the actual point values of the path as offsets from the enemy ship's starting point. A false value would treat the path's points as absolute positions on the screen. 
        //orientToPath: if set to true, causes the enemy ship to turn and face the direction of the path automatically. 
        
        let followPath = SKAction.followPath(shipPath, asOffset: true, orientToPath: true, duration: 7.0)
        
        let remove = SKAction.removeFromParent()
        
        enemy.runAction(SKAction.sequence([followPath, remove]))

    }
    
    func buildEnemyShipMovementPath() -> CGPathRef {
        
        let yMax = -1.0 * self.size.height
        
        //Bezier path produced using PaintCode app (www.paintcodeapp.com)
        //Usie the UIBezierPath Class
        
        let bezierPath = UIBezierPath()
        
        bezierPath.moveToPoint(CGPointMake(0.5, -0.5))
        
        bezierPath.addCurveToPoint(CGPointMake(-2.5, -59.5), controlPoint1: CGPointMake(0.5, -0.5), controlPoint2: CGPointMake(4.55, -29.48))
        
        bezierPath.addCurveToPoint(CGPointMake(-27.5, -154.5), controlPoint1: CGPointMake(-9.55, -89.52), controlPoint2: CGPointMake(-43.32, -115.43))
        
        bezierPath.addCurveToPoint(CGPointMake(30.5, -243.5), controlPoint1: CGPointMake(-11.68, -193.57), controlPoint2: CGPointMake(17.28, -186.95))
        
        bezierPath.addCurveToPoint(CGPointMake(-52.5, -379.5), controlPoint1: CGPointMake(43.72, -300.05), controlPoint2: CGPointMake(-47.71, -335.76))
        
        bezierPath.addCurveToPoint(CGPointMake(54.5, -449.5), controlPoint1: CGPointMake(-57.29, -423.24), controlPoint2: CGPointMake(-8.14, -482.45))
        
        bezierPath.addCurveToPoint(CGPointMake(-5.5, -348.5), controlPoint1: CGPointMake(117.14, -416.55), controlPoint2: CGPointMake(52.25, -308.62))
        
        bezierPath.addCurveToPoint(CGPointMake(10.5, -494.5), controlPoint1: CGPointMake(-63.25, -388.38), controlPoint2: CGPointMake(-14.48, -457.43))
        
        bezierPath.addCurveToPoint(CGPointMake(0.5, -559.5), controlPoint1: CGPointMake(23.74, -514.16), controlPoint2: CGPointMake(6.93, -537.57))
        
        //bezierPath.addCurveToPoint(CGPointMake(-2.5, -644.5), controlPoint1: CGPointMake(-5.2, -578.93), controlPoint2: CGPointMake(-2.5, -644.5))
        
        bezierPath.addCurveToPoint(CGPointMake(-2.5, yMax), controlPoint1: CGPointMake(-5.2, yMax), controlPoint2: CGPointMake(-2.5, yMax))
        
        return bezierPath.CGPath
        
    }
    
    //create a powerup sprite that spins and moves from top to bottom of screen
    //Idea: Add the opposite of a power up. Maybe make the ship bigger for a period of time.
    func dropWeaponsPowerUp() {
        
        
        let sideSize = 30.0
        
        //Determine random starting value for enemy ship's x and y positions.
        let startX = Double(arc4random_uniform(uint(self.size.width - 60)) + 30)
        
        let startY = Double(self.size.height) + sideSize
        
        let endY = 0 - sideSize
        
        //create powerUp and set its properties.
        let powerUp = SKSpriteNode(imageNamed: "powerup")
        
        powerUp.size = CGSize(width: sideSize, height: sideSize)
        powerUp.position = CGPoint(x: startX, y: startY)
        powerUp.name = PowerUpNodeName
        self.addChild(powerUp)

        let move = SKAction.moveTo(CGPoint(x: startX, y: endY), duration: 6)
        
        let remove = SKAction.removeFromParent()
        
        let travelAndRemove = SKAction.sequence([move, remove])
        
        let spinForever = SKAction.repeatActionForever(SKAction.rotateByAngle(1, duration: 1))
        
        powerUp.runAction(SKAction.group([spinForever, travelAndRemove]))
        
    }
    
    func updateHealth() {
        
        if let shield = self.childNodeWithName(ShieldNodeName) {
            switch self.shipHealthRate {
                case 0:
                    shield.alpha = 0
                case 1:
                    shield.alpha = 0.25
                case 2:
                    shield.alpha = 0.50
                case 3:
                    shield.alpha = 0.75
                case 4:
                    shield.alpha = 1.0
                default:
                    shield.alpha = 0.50
                }
        }
        
    }
    
    //Implement collision detection by looping (iterating) over all the nodes involved potentially in the collision in the Scene Graph node tree and checking if their frames intersect.
    func checkCollisions() {
        
        if let ship = self.childNodeWithName(SpaceshipNodeName){
            
            enumerateChildNodesWithName(PowerUpNodeName) {
                powerUp, _ in
                
                if ship.intersectsNode(powerUp) {
                    if let hud = self.childNodeWithName(self.HUDNodeName) as! HUDNode? {
                        hud.showPowerupTimer(self.powerUpDuration)
                    }
                    
                    powerUp.removeFromParent()
                    
                    //increase the ship's fire rate
                    self.shipFireRate = 0.1
                    
                    //but we need to power back down after a delay so we are not unbeatable.
                    let powerDown = SKAction.runBlock {
                        
                        self.shipFireRate = self.defaultFireRate
                        
                    }
                    
                    //Now let's set up a 5 second delay before the powerup powers down.
                    let wait = SKAction.waitForDuration(self.powerUpDuration)
                    let waitAndPowerDown = SKAction.sequence([wait, powerDown])
                    //ship.runAction(waitAndPowerDown)
                    
                    // Ok, we have an issue.  If our ship collides with another powerup while a powerup is already in progress we don't get the benefit of a full powerup reset.
                    // Why?
                    // The first powerDown runBlock will run and restore the normal rate of fire too soon.
                    // Sprite Kit lets us run actions with a descriptive key that we can use to identify and remove the action before they've had a chance to run or finish.
                    // If no key is found, nothing changes...
                    let powerDownActionKey = "waitAndPowerDown"
                    ship.removeActionForKey(powerDownActionKey)
                    
                    ship.runAction(waitAndPowerDown, withKey: powerDownActionKey)
                    
                }
                
            }
            
            
            enumerateChildNodesWithName(HealthPowerUpNodeName) {
                healthPowerUp, _ in
                
                if ship.intersectsNode(healthPowerUp) {
                    self.shipHealthRate = 4.0
                    if let hud = self.childNodeWithName(self.HUDNodeName) as! HUDNode? {
                        hud.changeHealth(self.shipHealthRate)
                    }
                    healthPowerUp.removeFromParent()
                    
                }
                
            }
            
            enumerateChildNodesWithName(TenPointPowerupNodeName) {
                tenPointPowerUp, _ in
                
                if ship.intersectsNode(tenPointPowerUp) {
                    if let hud = self.childNodeWithName(self.HUDNodeName) as! HUDNode? {
                        let score = 10
                        hud.addPoints(score)

                    }
                    tenPointPowerUp.removeFromParent()
                    
                }
                
            }
            
            enumerateChildNodesWithName(TwentyPointPowerupNodeName) {
                twentyPointPowerUp, _ in
                
                if ship.intersectsNode(twentyPointPowerUp) {
                    if let hud = self.childNodeWithName(self.HUDNodeName) as! HUDNode? {
                        let score = 20
                        hud.addPoints(score)
                        
                    }
                    twentyPointPowerUp.removeFromParent()
                    
                }
                
            }


            
            //This method will execute its code block for every node in the Scene Graph tree that is an "obstacle" node. 
            //This method will automatically populate the local identifier obstacle with a reference to each (next) "obstacle" node it found...
            enumerateChildNodesWithName(ObstacleNodeName) {
                
                obstacle, _ in
                
                //check for collision between our obstacle and the ship. 
                if ship.intersectsNode(obstacle) {
                    
                    //Set shipTouch property to nil so it will not be used by our shooting logic in the update method to continue to track the touch and shoot photon torpedos. If this doesn't work, the torpedos will be shot up from (0, 0) since ship is gone.

                    
                    //remove ship and obstacle
                    //ship.removeFromParent()
                    obstacle.removeFromParent()
                    if self.shipHealthRate == 0 {
                        ship.removeFromParent()
                        self.runAction(self.shipExplodeSound)
                        self.shipTouch = nil
                        
                        //call copy on the shipExplodeTemplate node because nodes can only be added to the scene once. If we try to add a node that already exists in a scene the game will crash with an error message. We must add copies of particle emitter nodes and we will use the emitterNode in our cached class property as a template. from which to make these copies.
                        let explosion = self.shipExplodeTemplate.copy() as! SKEmitterNode
                        explosion.position = ship.position
                        explosion.pdc_dieOutInDuration(0.3)
                        self.addChild(explosion)
                        
                        //stop game timer
                        if let hud = self.childNodeWithName(self.HUDNodeName) as! HUDNode?{
                            hud.endGame()
                        }
                        
                    } else {
                        self.shipHealthRate = self.shipHealthRate - 1
                        if let hud = self.childNodeWithName(self.HUDNodeName) as! HUDNode? {
                            hud.changeHealth(self.shipHealthRate)
                        }

                    }
                    
                }
                
                //Add an inner loop inside our check for ship v. obstacle collisions to check if any of our photon torpedos collide with our obstacle. 
                self.enumerateChildNodesWithName(self.PhotonTorpedoNodeName) {
                    
                    myPhoton, stop in
                    
                    if myPhoton.intersectsNode(obstacle){
                        
                        myPhoton.removeFromParent()
                        obstacle.removeFromParent()
                        
                        self.runAction(self.obstacleExplodeSound)
                        
                        let explosion = self.obstacleExplodeTemplate.copy() as! SKEmitterNode
                        explosion.position = obstacle.position
                        explosion.pdc_dieOutInDuration(0.1)
                        self.addChild(explosion)
                        
                        //Update our score in the HUD.
                        if let hud = self.childNodeWithName(self.HUDNodeName) as! HUDNode?{
                            let score = 10
                            hud.addPoints(score)
                        }
                        
                        
                        //set stop.memory to true to end this inner loop 
                        //This is a lot like a break statement in other languages
                        stop.memory = true
                        
                    }
                    
                }
                
            }
        
        }
        
    }

}

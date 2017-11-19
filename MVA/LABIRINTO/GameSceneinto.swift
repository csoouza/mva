//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//

import SpriteKit
import AudioToolbox

enum State {
    case Playing, Over
}

class GameSceneinto: SKScene {
    
    var GameState = State.Playing
    var numCols = 10
    var numRows = 10
    var cellSize:CGFloat!
    var nodes:Array2D!
    var startNode:cellNode?
    var goalNode:cellNode!

    
    var buttonHeight:CGFloat = 50
    var legendHeight:CGFloat = 100
    var score = 0
    var scoreLabel = SKLabelNode(fontNamed: "Avenir Next Heavy")
    
    var lives = Properties.startingLives
    {
        didSet{
            healthBar.setLives(lives)
            if lives <= 0
            {
                lives = 0
                //startNode?.dead()
            }
            if lives >= Properties.maxLives
            {
                lives = Properties.maxLives
            }
        }
    }
    
    var healthBar:HealthBar!
    let search:DepthFirstSearch = DepthFirstSearch()
    
    var blueDude = SKSpriteNode(imageNamed: "alive")

    
    override func didMoveToView(view: SKView) {
        createGrid()
        let legend = SKSpriteNode(color: Properties.colour_ui, size: CGSize(width: self.frame.width, height: legendHeight))
        legend.position = CGPoint(x: CGRectGetMidX(self.frame), y: self.frame.height - legendHeight / 2)
        self.addChild(legend)
        scoreLabel.fontSize = 40
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        scoreLabel.fontColor = SKColor.whiteColor()
        scoreLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y:470)
        scoreLabel.text = "\(score)"
        self.addChild(scoreLabel)
        
        healthBar = HealthBar(color: Properties.colour_ui, size: CGSize(width: self.frame.width, height: buttonHeight))
        healthBar.position = CGPoint(x: CGRectGetMidX(self.frame), y: buttonHeight / 2)
        self.addChild(healthBar)
        
        healthBar.setLives(lives)
        
        blueDude.size = CGSize(width: cellSize, height: cellSize)
        self.addChild(blueDude)
        
        
    }
    

    func createGrid()
    {
        print("Create Grid")
        
        let gridHeight = self.frame.height - legendHeight - buttonHeight
        cellSize = self.frame.width / CGFloat(numCols)
        numRows = Int( gridHeight / cellSize)
        
        nodes = Array2D(cols: numRows+1, rows: numCols+1)
        var validMaze = false
        
        while(!validMaze)
        {
            initGrid()
            setNodePointers()
            applyMaze()
            
            let endFound = search.search(startNode!)
            if endFound
            {
                print("End was found")
                validMaze = true
            }
            else
            {
                print("No through path")
            }
        }
        placeItems()

        startNode!.makeVisitable()
        fadeNodes()
    }
    
    func initGrid() {
        let bar:CGFloat = buttonHeight
        // Bot Left
        let widthCheck = self.frame.width - cellSize * CGFloat(numCols)
        var xShift:CGFloat = 0
        if widthCheck > 0
        {
            xShift = widthCheck / 2
        }
        var point = CGPoint(x:CGFloat(0) * cellSize + xShift, y: bar + CGFloat(0) * cellSize)
        var cell = cellNode()
        cell.create("botLeft", pos: point,size: CGSize(width: cellSize, height:cellSize),i: 0, j: 0)
        nodes![0,0] = cell
        
        // Bot Right
        point = CGPoint(x:CGFloat(numCols - 1) * cellSize + xShift, y: bar + CGFloat(0) * cellSize)
        cell = cellNode()
        cell.create("botRight", pos: point,size: CGSize(width: cellSize, height:cellSize),i: 0, j: numCols-1)
        nodes![0,numCols-1] = cell
        
        // Top Left
        point = CGPoint(x:CGFloat(0) * cellSize + xShift, y: bar + CGFloat(numRows) * cellSize)
        cell = cellNode()
        cell.create("topLeft", pos: point,size: CGSize(width: cellSize, height:cellSize),i: numRows, j: 0)
        nodes![numRows,0] = cell
        
        // Top Right
        point = CGPoint(x:CGFloat(numCols - 1) * cellSize + xShift, y: bar + CGFloat(numRows) * cellSize)
        cell = cellNode()
        cell.create("topRight", pos: point,size: CGSize(width: cellSize, height:cellSize),i: numRows, j: numCols-1)
        nodes![numRows,numCols-1] = cell
        
        
        // Bot Row
        for j in 1...numCols-2 {
            point = CGPoint(x:CGFloat(j) * cellSize + xShift, y: bar + CGFloat(0) * cellSize)
            cell = cellNode()
            cell.create("botRow", pos: point,size: CGSize(width: cellSize, height:cellSize),i: 0, j: j)
            nodes![0,j] = cell
        }
        
        // Top Row
        for j in 1...numCols-2 {
            point = CGPoint(x:CGFloat(j) * cellSize + xShift, y: bar + CGFloat(numRows) * cellSize)
            cell = cellNode()
            cell.create("topRow", pos: point,size: CGSize(width: cellSize, height:cellSize),i: numRows, j: j)
            nodes![numRows,j] = cell
        }
        
        // Left Col
        for i in 1...numRows-1 {
            point = CGPoint(x:CGFloat(0) * cellSize + xShift, y: bar + CGFloat(i) * cellSize)
            cell = cellNode()
            cell.create("leftCol", pos: point,size: CGSize(width: cellSize, height:cellSize),i: i, j: 0)
            nodes![i,0] = cell
        }
        
        // Right Col
        for i in 1...numRows-1 {
            point = CGPoint(x:CGFloat(numCols - 1) * cellSize + xShift, y: bar + CGFloat(i) * cellSize)
            cell = cellNode()
            cell.create("rightCol", pos: point,size: CGSize(width: cellSize, height:cellSize),i: i, j: numCols-1)
            nodes![i,numCols-1] = cell
        }
        
        for j in 1...numCols-2 {
            for i in 1...numRows-1 {
                let point = CGPoint(x:CGFloat(j) * cellSize + xShift, y: bar + CGFloat(i) * cellSize)
                cell = cellNode()
                cell.create("middle", pos: point,size: CGSize(width: cellSize, height:cellSize),i: i, j: j)
                nodes![i,j] = cell
            }
        }
    }
    
    func setNodePointers()     {
        for i in 0...numRows {
            for j in 0...numCols {
                if let cell = nodes![i,j] as? cellNode
                {
                    addChild(cell)
                    
                    switch cell.name! {
                    case "botLeft":
                        cell.toWall()
                        cell.top_node = nodes![i+1,j] as? cellNode
                        cell.rig_node = nodes![i,j+1] as? cellNode
                        break
                    case "botRight":
                        cell.toWall()
                        cell.top_node = nodes![i+1,j] as? cellNode
                        cell.lef_node = nodes![i,j-1] as? cellNode
                        break
                    case "topLeft":
                        cell.toWall()
                        cell.bot_node = nodes![i-1,j] as? cellNode
                        cell.rig_node = nodes![i,j+1] as? cellNode
                        break
                    case "topRight":
                        cell.toWall()
                        cell.bot_node = nodes![i-1,j] as? cellNode
                        cell.lef_node = nodes![i,j-1] as? cellNode
                        break
                    case "leftCol":
                        cell.toWall()
                        cell.top_node = nodes![i+1,j] as? cellNode
                        cell.rig_node = nodes![i,j+1] as? cellNode
                        cell.bot_node = nodes![i-1,j] as? cellNode
                        break
                    case "rightCol":
                        cell.toWall()
                        cell.top_node = nodes![i+1,j] as? cellNode
                        cell.lef_node = nodes![i,j-1] as? cellNode
                        cell.bot_node = nodes![i-1,j] as? cellNode
                        break
                    case "topRow":
                        cell.toWall()
                        cell.rig_node = nodes![i,j+1] as? cellNode
                        cell.lef_node = nodes![i,j-1] as? cellNode
                        cell.bot_node = nodes![i-1,j] as? cellNode
                        break
                    case "botRow":
                        cell.toWall()
                        cell.rig_node = nodes![i,j+1] as? cellNode
                        cell.lef_node = nodes![i,j-1] as? cellNode
                        cell.top_node = nodes![i+1,j] as? cellNode
                        break
                    case "middle":
                        cell.rig_node = nodes![i,j+1] as? cellNode
                        cell.lef_node = nodes![i,j-1] as? cellNode
                        cell.top_node = nodes![i+1,j] as? cellNode
                        cell.bot_node = nodes![i-1,j] as? cellNode
                        break
                    default:
                        break
                    }
                    cell.name = "node"
                }
            }
        }
        
    }
    
    func applyMaze()
    {
        let maze = Maze(width: numCols+1, height: numRows+1)
        //maze.show()
        
        for i in 0...numRows-1 {
            for j in 0...numCols-1 {
                let cell = maze.data[i+1][j+1] as Cell
                let node = nodes[i,j] as! cellNode
                if cell == Cell.Space && node.type != Cell.Wall
                {
                    //node.toStart()
                }
                if cell == Cell.Wall
                {
                    node.toWall()
                }
                if cell == Cell.Start
                {
                    node.toStart()
                    startNode = node
                    startNode?.visit()
                    blueDude.position = startNode!.position
                }
                if cell == Cell.Goal
                {
                    node.toGoal()
                }
                    
                
            }
        }
    }
    
    func getRandNode() -> cellNode?
    {
        var node:cellNode?
        while node == nil
        {
            let randI = RandomInt(min: 0, max: numRows - 1)
            let randJ = RandomInt(min: 0, max: numCols - 1)
            let tempNode = nodes[randI, randJ] as! cellNode
            if tempNode.type == Cell.Space
            {
                node = tempNode
            }
        }
        return node
    }
    
    func placeItems()
    {
        var rand = Double(arc4random() % 100) / 100.0;
        if rand < Properties.heartChance
        {
            print("heart spawned!")
            if let node = getRandNode()
            {
                node.placeHeart()
            }
            
        }
        rand = Double(arc4random() % 100) / 100.0;
        if rand < Properties.lightChance
        {
            if let node = getRandNode()
            {
                node.placeLight()
            }
        }

    }

    
    func setVisitableNodes(node:cellNode)
    {

        if let n1 = node.top_node
        {
            n1.makeVisitable()
        }
        if let n2 = node.lef_node
        {
            n2.makeVisitable()
        }
        if let n3 = node.bot_node
        {
            n3.makeVisitable()
        }
        if let n4 = node.rig_node
        {
            n4.makeVisitable()
        }
    }
    
    func fadeNodes()
    {
        for i in 0...numRows-1 {
            for j in 0...numCols-1 {
                let node = nodes[i,j] as! cellNode
                if node.type == Cell.Space
                {
                    node.fade()
                }
            }
        }
    }
    func resetNodeFade()
    {
        print("resetting node fade")
        for i in 0...numRows-1 {
            for j in 0...numCols-1 {
                let node = nodes[i,j] as! cellNode
                if node.type == Cell.Space
                {
                    node.resetFade()
                }
            }
        }
    }
    
    func clearVistedNodes()
    {
        for i in 0...numRows-1 {
            for j in 0...numCols-1 {
                let node = nodes[i,j] as! cellNode
                if node.visited
                {
                    node.unvisit()
                }
                if node.visitable
                {
                    node.visitable = false
                }
                
            }
        }
    }
    
    func deleteGrid()
    {
        
        self.enumerateChildNodesWithName("node", usingBlock: {
            (node: SKNode!, stop: UnsafeMutablePointer <ObjCBool>) -> Void in
            if let cell = node as? cellNode
            {
                cell.removeNodes()
            }
        })
    }
    
    func nextLevel()
    {
        deleteGrid()
        //numCols++
        score++
        scoreLabel.xScale = 1.5
        scoreLabel.yScale = 1.5
        let growAction = SKAction.scaleBy(0.75, duration: 0.25)
        scoreLabel.runAction(growAction)
        scoreLabel.text = "\(score)"
        createGrid()
        
        if Properties.heartChance < Properties.maxHeartChance
        {
            let rand = Double(arc4random() % 100) / 10000.0;
            Properties.heartChance += rand
            print("increasing heart chance to: \(Properties.heartChance)")
            
        }
        
        if Properties.lightChance < Properties.maxLightChance
        {
            let rand = Double(arc4random() % 100) / 10000.0;
            Properties.lightChance += rand
            print("increasing light chance to: \(Properties.lightChance)")
            
        }
    }
    
    func nodeTouched(location:CGPoint)
    {
        let nodes = nodesAtPoint(location)
        for node in nodes {
            if node.isKindOfClass(cellNode) {
                let cell = node as! cellNode
                if cell.visitable
                {
                    cell.visit()
                    blueDude.position = cell.position
                    setVisitableNodes(cell)
                    
                    if cell.hasHeart && lives < Properties.maxLives
                    {
                        cell.removeHeart()
                        lives++
                    }
                    
                    if cell.hasLight
                    {
                        cell.removeLight()
                        resetNodeFade()
                    }
                    
                    if cell.type == Cell.Goal
                    {
                        print("YOOOUUU WINN! 😇😇😇😇😇")
                        nextLevel()
                    }
                    if cell.type == Cell.Wall
                    {
                        print("OOPS! 😅")
                        cell.hitWall()

                        clearVistedNodes()
                        startNode!.makeVisitable()
                        
                        
                        lives--
                        if lives <= 0
                        {
                            GameState = .Over
                            blueDude.texture = SKTexture(imageNamed: "dead")
                        }
                        else
                        {
                            blueDude.position = startNode!.position
                        }

                        
                        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                    }
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            if GameState == .Playing
            {
                nodeTouched(location)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            if GameState == .Playing
            {
                nodeTouched(location)
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}

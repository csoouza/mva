//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//

import SpriteKit

class DepthFirstSearch
{
    
    var numVisted:Int = 0

    
    func search (n:cellNode) -> Bool
    {

            n.visited = true
            if (n.type == Cell.Goal) {
                numVisted = 0
                return true
            }
            else
            {
                numVisted++
                
                if (n.type != Cell.Start)
                {
                }
                
                let n1 = n.top_node
                let n2 = n.bot_node
                let n3 = n.lef_node
                let n4 = n.rig_node
                
                if n1 != nil && isVisitable(n1!) {
                    return search(n1!)
                }
                if n2 != nil && isVisitable(n2!) {
                    return search(n2!)
                }
                if n3 != nil && isVisitable(n3!) {
                    return search(n3!)
                }
                if n4 != nil && isVisitable(n4!) {
                    return search(n4!)
                }
                
            }
        return false
    }
    
    func isVisitable(n:cellNode) -> Bool
    {
        if n.visited || n.type == Cell.Wall
        {
            return false
        }
        return true
    }
    
    
}
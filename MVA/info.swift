//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//


import UIKit

class info: UIViewController {
    
    @IBOutlet weak var informacao: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        informacao.animationImages = [
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info1.png")!,
            UIImage(named: "info1.png")!,
            UIImage(named: "info1.png")!,
            UIImage(named: "info1.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            UIImage(named: "info2.png")!,
            
         
            
        ]
        
        informacao.startAnimating()
        
        
        
    }
    
    
    
    
}

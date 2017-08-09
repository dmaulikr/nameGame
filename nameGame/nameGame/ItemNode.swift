//
//  ItemNode.swift
//  grandpasworkshop
//
//  Created by jrtb on 9/6/16.
//  Copyright © 2016 fairladymedia. All rights reserved.
//

import Foundation
import SpriteKit

class ItemNode: SKSpriteNode {
    
    var touched = false
    var wiggling = false
    
    var itemType: Int!
    var itemClass: Int!
    var itemVariant: Int!
    var itemSlot: Int!
    var itemJewelClass: Int!
    
    var held = false
    var matched = false
    
    var startingPoint: CGPoint!
    var correctPoint: CGPoint!
    var startingAngle: CGFloat!
    
    var currentState: Int!
    
    var startingZ: Int!
    
    var currentRow: Int!
    var currentColumn: Int!
    
    var tvInteractive = true
    
    var duration: Double!
    
    var column: Int!
    var row: Int!
    
    var canAnimate: Bool = true
    
    var personsName: String = ""
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touch in item")
        
        super.touchesBegan(touches, with: event)
    }
    
}

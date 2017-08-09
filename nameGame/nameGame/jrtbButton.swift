//
//  jrtbButton.swift
//
//  Created by Nguyen Pham on 10/02/2015.
//  Copyright (c) 2015 TonyPham. All rights reserved.
//

import SpriteKit

class jrtbButton: SKSpriteNode {
    
    var enabled: Bool = true
    var sound: String!
    
    var normalImage: SKTexture!
    var pressedImage: SKTexture!
    
    var havePressedImage: Bool = false
    
    //var imageFileName: String?
    
    /*
     * Function to be called after being tapped
     */
    var buttonFunc: ((_ button: jrtbButton) -> Void)?
    
    func buttonPressed() {
        
        SoundEffects.play(name: self.sound)
        
        buttonFunc!(self)
        
    }
    
    /*
     * Init
     */
    init(imageNamed: String, buttonNamed: String, buttonFunc: ((_ button: jrtbButton) -> Void)? = nil, aSound:String?="click2", pressedImageNamed: String?="") {

        self.normalImage = SKTexture(imageNamed: imageNamed)
        
        if pressedImageNamed != "" {
            self.pressedImage = SKTexture(imageNamed: pressedImageNamed!)
            self.havePressedImage = true
        } else {
            self.pressedImage = self.normalImage
        }

        super.init(texture: self.normalImage, color: UIColor.clear, size: self.normalImage.size())
        
        self.name = buttonNamed
        
        self.sound = aSound
        
        //self.imageFileName = imageNamed
        
        self.buttonFunc = buttonFunc
        
        isUserInteractionEnabled = true
        
        //print("created button")
        
    }
    
    /*
     * Needed to stop XCode warnings
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if enabled {
            
            if let touch = touches.first {
                let location = touch.location(in: parent!)
                if self.contains(location) {
                    
                    if self.havePressedImage {
                        self.texture = pressedImage
                    } else {
                        self.colorBlendFactor = 1.0
                        self.color = SKColor.init(colorLiteralRed: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1.0)
                    }
                    
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if enabled {
            
            if buttonFunc != nil {
                if let touch = touches.first {
                    let location = touch.location(in: parent!)
                    if self.contains(location) {
                        
                        buttonPressed()
                        
                    }
                }
            }
        }
        
        if self.havePressedImage {
            self.texture = normalImage
        } else {
            self.colorBlendFactor = 0.0
        }
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        if enabled {
        }
        
        if self.havePressedImage {
            self.texture = normalImage
        } else {
            self.colorBlendFactor = 0.0
        }
        
    }
    
}

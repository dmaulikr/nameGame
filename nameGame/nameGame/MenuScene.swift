//
//  MenuScene.swift
//  grandpasworkshop
//
//  Created by jrtb on 9/1/16.
//  Copyright © 2016 fairladymedia. All rights reserved.
//
// This is the SpriteKit scene for the main menu

import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    weak var viewController: GameViewController!
    
    private var menuA: jrtbButton!
    private var muteOn: jrtbButton!
    private var muteOff: jrtbButton!
    
    private var numPicturesLoaded: Int = 0
    private var maxPictures: Int = 0
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = SKColor.init(colorLiteralRed: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)

        menuA = jrtbButton(imageNamed: "play", buttonNamed: "playTouched", buttonFunc: tappedButton)
        menuA.position = CGPoint(x: viewController.sceneLeft+viewController.sceneWidth*0.5, y: viewController.sceneBottom+viewController.sceneHeight*0.5)
        menuA.zPosition = 10
        menuA.alpha = 0
        menuA.setScale(0.9)
        addChild(menuA)
        
        menuA.run(SKAction.fadeIn(withDuration: 1.0))
        
        muteOn = jrtbButton(imageNamed: "menu_music_on", buttonNamed: "muteOn", buttonFunc: tappedButton)
        muteOn.position = CGPoint(x: viewController.sceneLeft+29*4, y: viewController.sceneBottom+29.0*4)
        muteOn.enabled = false
        muteOn.alpha = 0
        addChild(muteOn)
        
        muteOff = jrtbButton(imageNamed: "menu_music_off", buttonNamed: "muteOff", buttonFunc: tappedButton)
        muteOff.position = CGPoint(x: viewController.sceneLeft+29*4, y: viewController.sceneBottom+29.0*4)
        muteOff.enabled = false
        muteOff.alpha = 0
        addChild(muteOff)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.4),
            SKAction.run(slideInTools)
            ])
        )
        
        isUserInteractionEnabled = true
        
    }
    
    func slideInTools() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate // swift 3
        
        if delegate.muted {
            print("enabling muteOff button\n")
            muteOff.enabled = true
            muteOff.zPosition = 12
            muteOn.zPosition = 1
            muteOff.run(SKAction.fadeAlpha(to: 1.0, duration: 0.4))
        } else {
            print("enabling muteOn button\n")
            muteOn.enabled = true
            muteOn.zPosition = 12
            muteOff.zPosition = 1
            muteOn.run(SKAction.fadeAlpha(to: 1.0, duration: 0.4))
        }
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 2.0),
            SKAction.run() {
                let sUp = SKAction.scale(to: 1.0, duration: 0.4)
                let sBack = SKAction.scale(to: 0.9, duration: 0.4)
                let pause = SKAction.wait(forDuration: 0.4)
                let seq = SKAction.sequence([sUp,sBack,pause,pause])
                self.menuA.run(SKAction.repeatForever(seq),withKey: "pulse")
            }
            ])
        )
        
        if delegate.correctHits > 0 || delegate.incorrectHits > 0 {
            
            let label = SKLabelNode(fontNamed:"Arial")
            label.text = "correct guesses: " + String(delegate.correctHits) + " / " + String(delegate.correctHits + delegate.incorrectHits)
            label.position = CGPoint(x: viewController.sceneWidth*0.5, y: viewController.sceneBottom + 260)
            label.fontSize = 36*2
            label.zPosition = 10
            label.fontColor = SKColor.init(colorLiteralRed: 117.0/255.0, green: 203.0/255.0, blue: 196.0/255.0, alpha: 1.0)
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            addChild(label)

        } else {
            
            let label = SKLabelNode(fontNamed:"Arial")
            label.text = "Pictures loaded: "
            label.position = CGPoint(x: viewController.sceneWidth*0.5, y: viewController.sceneBottom + 260)
            label.fontSize = 36*2
            label.zPosition = 10
            label.fontColor = SKColor.init(colorLiteralRed: 117.0/255.0, green: 203.0/255.0, blue: 196.0/255.0, alpha: 1.0)
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            addChild(label)
            
            run(SKAction.repeatForever(
                SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                SKAction.run() {
                    
                    let totalCount = delegate.firstNames.count
                    
                    self.maxPictures = 0
                    self.numPicturesLoaded = 0
                    
                    for index in 0 ..< totalCount {
                        
                        if delegate.imageURLs[index] != "" {
                            
                            self.maxPictures += 1
                            
                        }
                        
                        if delegate.imagesLoaded[index] {
                            
                            self.numPicturesLoaded += 1
                            
                        }
                    }
                    
                    label.text = "Pictures loaded: " + String(self.numPicturesLoaded) + " / " + String(totalCount)

                    }
                ])
                ), withKey: "loop"
            )

        }
        
    }
    
     #if os(iOS)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        viewController.replaceTheScene(screenToggle: GAME_01)
        
    }
    #endif
    
    func tappedButton(button: jrtbButton) {
        print("tappedButton tappedButton tag=\(String(describing: button.name))")
        
        let delegate = UIApplication.shared.delegate as! AppDelegate // swift 3
        
        let defaults = UserDefaults.standard
        
        if button.name == "muteOff" {
            
            print("muted, so un-muting\n")
            
            defaults.set(false, forKey: "muted")
            defaults.synchronize()
            delegate.muted = false
            
            MusicPlayer.play()
            
            muteOn.alpha = 1.0
            muteOn.enabled = true
            muteOn.zPosition = 12
            muteOff.zPosition = 1
            muteOff.alpha = 0.0
            muteOff.enabled = false
            
        }
        
        if button.name == "muteOn" {
            
            print("not muted, so muting\n")
            
            defaults.set(true, forKey: "muted")
            defaults.synchronize()
            delegate.muted = true
            
            MusicPlayer.pause()
            
            muteOff.alpha = 1.0
            muteOff.enabled = true
            muteOff.zPosition = 12
            muteOn.zPosition = 1
            muteOn.alpha = 0.0
            muteOn.enabled = false
            
        }
        
        if button.name == "playTouched" {
            
            menuA.removeAllActions()
            menuA.setScale(0.9)
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                SKAction.run() {
                    
                    self.viewController.replaceTheScene(screenToggle: GAME_01)
                }
                ])
            )
            
        }
        
    }
    
    override func willMove(from view: SKView) {
        
        print("removing menu from view")
        
        self.removeAction(forKey: "prompt")
        self.removeAction(forKey: "loop")
        
        menuA = nil
        muteOn = nil
        muteOff = nil

        removeAllChildren()
        removeAllActions()
        
    }
    
    deinit {
        // perform the deinitialization
        
        print("running deinit on menuscene")
        
    }
    
}

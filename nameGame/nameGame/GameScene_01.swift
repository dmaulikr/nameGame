//
//  GameScene_01.swift
//  grandpasworkshop
//
//  Created by jrtb on 9/6/16.
//  Copyright © 2016 fairladymedia. All rights reserved.
//
// This is the SpriteKit scene for the actual game. 
// Succesive games re-load this scene (without reloading the data feed - all of that is stored once per session in the App Delegate

import Foundation
import SpriteKit

class GameScene_01: SKScene {
    
    weak var viewController: GameViewController!
    
    private var gridPositions = [CGPoint]()
    private var items = [ItemNode]()

    private var chosenIndexes = [Int]()
    
    private var numTouches = 0
    
    private var touchable = true
    
    private var menuD: jrtbButton!
    
    private var label: SKLabelNode!
    private var label2: SKLabelNode!
    
    private var totalPeoplePerPage: Int = 6
    
    private var targetCorrectPerson: Int = Int(arc4random() % 6)
    
    private var numAttempts = 0
    
    private var updatedPeopleThisTime = false

    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        let delegate = UIApplication.shared.delegate as! AppDelegate // swift 3
        
        backgroundColor = SKColor.init(colorLiteralRed: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)

        if !delegate.musicLoaded {
            delegate.musicLoaded = true
            MusicPlayer.addTrack(fileName: "marbles_menu", type: "m4a")
            MusicPlayer.addTrack(fileName: "marbles_level_01", type: "m4a")
            MusicPlayer.addTrack(fileName: "marbles_level_02", type: "m4a")
            MusicPlayer.addTrack(fileName: "marbles_level_03", type: "m4a")
            MusicPlayer.addTrack(fileName: "marbles_level_04", type: "m4a")
            MusicPlayer.addTrack(fileName: "marbles_level_05", type: "m4a")
            MusicPlayer.addTrack(fileName: "marbles_level_06", type: "m4a")
        }

        switch delegate.musicTrack {
        case 1:
            MusicPlayer.setPrimary(name: "marbles_level_01")
        case 2:
            MusicPlayer.setPrimary(name: "marbles_level_02")
        case 3:
            MusicPlayer.setPrimary(name: "marbles_level_03")
        case 4:
            MusicPlayer.setPrimary(name: "marbles_level_04")
        case 5:
            MusicPlayer.setPrimary(name: "marbles_level_05")
        default:
            MusicPlayer.setPrimary(name: "marbles_level_06")
        }
        
        MusicPlayer.play()
        if delegate.muted {
            MusicPlayer.pause()
        }
        
        initGraphicsSetup()
        
        // create dummy items
        
        for index in 0 ..< totalPeoplePerPage {
            
            let aPerson = ItemNode(color: UIColor.gray, size: CGSize(width: 400.0, height: 400.0))
            aPerson.position = gridPositions[index]
            aPerson.zPosition = 6
            aPerson.itemSlot = index
            self.addChild(aPerson)
            items.append(aPerson)

            let aPersonShadow = SKSpriteNode(color: SKColor.init(colorLiteralRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.37), size: aPerson.size)
            aPersonShadow.zPosition = -1
            aPersonShadow.position = CGPoint(x: +4*2, y: -4*2)
            aPerson.addChild(aPersonShadow)

        }

        
    }
    
    override func update(_ currentTime: TimeInterval) {

        let delegate = UIApplication.shared.delegate as! AppDelegate // swift 3

        if !updatedPeopleThisTime && delegate.dataLoaded {
        
            updatedPeopleThisTime = true
            
            pickCurrentSet()
            
            // update people's names and images
            for index in 0 ..< chosenIndexes.count {
                let aPerson = items[index]
                if delegate.imagesLoaded[chosenIndexes[index]] {
                    aPerson.texture = delegate.images[chosenIndexes[index]].texture
                } else {
                    aPerson.texture = delegate.getImageForURL(aURL: delegate.imageURLs[chosenIndexes[index]]).texture
                }
                aPerson.personsName = delegate.firstNames[chosenIndexes[index]] + " " + delegate.lastNames[chosenIndexes[index]]
                
                // update prompt at the top of the page with the correct person's names
                if index == targetCorrectPerson {
                    label.text = "Who is " + aPerson.personsName + "?"
                    label2.text = label.text
                }
            }
            
        }

    }
    
    func pickCurrentSet() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate // swift 3

        let totalCount = delegate.firstNames.count
        
        for index in 0 ..< totalCount {
            
            // check to make sure an image loaded for this one
            
            if delegate.imageURLs[index] != "" {
            
                chosenIndexes.append(index)
                
            }
        }
        
        chosenIndexes.shuffle()
        
        while chosenIndexes.count > totalPeoplePerPage {
            chosenIndexes.removeLast()
        }
        
        print(chosenIndexes)
        
    }
        
    func initGraphicsSetup() {

        // init grid positions for items/people
        
        gridPositions.append(CGPoint(x: 0.25*viewController.sceneWidth, y: viewController.sceneBottom+viewController.sceneHeight*0.5+250-20))
        gridPositions.append(CGPoint(x: 0.50*viewController.sceneWidth, y: viewController.sceneBottom+viewController.sceneHeight*0.5+250-20))
        gridPositions.append(CGPoint(x: 0.75*viewController.sceneWidth, y: viewController.sceneBottom+viewController.sceneHeight*0.5+250-20))
        gridPositions.append(CGPoint(x: 0.25*viewController.sceneWidth, y: viewController.sceneBottom+viewController.sceneHeight*0.5-250-20))
        gridPositions.append(CGPoint(x: 0.50*viewController.sceneWidth, y: viewController.sceneBottom+viewController.sceneHeight*0.5-250-20))
        gridPositions.append(CGPoint(x: 0.75*viewController.sceneWidth, y: viewController.sceneBottom+viewController.sceneHeight*0.5-250-20))

        label = SKLabelNode(fontNamed:"Arial")
        label.text = ""
        label.position = CGPoint(x: viewController.sceneWidth*0.5, y: viewController.sceneTop-30*2)
        label.fontSize = 36*2
        label.zPosition = 10
        label.fontColor = SKColor.init(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        addChild(label)
        
        label2 = SKLabelNode(fontNamed:"Arial")
        label2.text = label.text
        label2.position = CGPoint(x: label.position.x+4, y: label.position.y-4)
        label2.fontSize = label.fontSize
        label2.zPosition = 9
        label2.fontColor = SKColor.init(colorLiteralRed: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.4)
        label2.verticalAlignmentMode = .center
        label2.horizontalAlignmentMode = .center
        addChild(label2)
        
        menuD = jrtbButton(imageNamed: "home_button", buttonNamed: "closeAction", buttonFunc: tappedButton)
        menuD.zPosition = 20
        menuD.position = CGPoint(x: viewController.sceneRight-44*3, y: viewController.sceneTop-42.0*2.5)
        addChild(menuD)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate // swift 3

        //print("touch in GameScene_01")
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        for index in 0 ..< items.count {
            
            let anItem = items[index]
            
            if touchable && anItem.frame.contains(touchLocation) {
                
                if anItem.itemSlot == targetCorrectPerson {
                    
                    // correct!
                    
                    delegate.correctHits += 1
                    
                    let overlay = SKSpriteNode(color: SKColor.init(colorLiteralRed: 0.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 0.25), size: anItem.size)
                    overlay.zPosition = 1
                    overlay.alpha = 0
                    anItem.addChild(overlay)
                    overlay.run(SKAction.fadeIn(withDuration: 0.4))
                    
                    let aLabel = SKLabelNode(fontNamed:"Arial")
                    aLabel.text = anItem.personsName
                    aLabel.position = CGPoint(x: 0.0, y: -160)
                    aLabel.fontSize = 36
                    aLabel.zPosition = 2
                    aLabel.fontColor = SKColor.init(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    aLabel.verticalAlignmentMode = .center
                    aLabel.horizontalAlignmentMode = .center
                    aLabel.alpha = 0
                    anItem.addChild(aLabel)
                    aLabel.run(SKAction.fadeIn(withDuration: 0.4))
                    
                    touchable = false

                    SoundEffects.play(name: "wind_chime_ding")
                    
                    let aFireworkBoom = SKEmitterNode(fileNamed: "firework.sks")!
                    aFireworkBoom.position = anItem.position
                    switch 1 + arc4random() % 5 {
                    case 1:
                        aFireworkBoom.particleColor = SKColor.init(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    case 2:
                        aFireworkBoom.particleColor = SKColor.init(colorLiteralRed: 0.0/255.0, green: 146.0/255.0, blue: 69.0/255.0, alpha: 1.0)
                    case 3:
                        aFireworkBoom.particleColor = SKColor.init(colorLiteralRed: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    case 4:
                        aFireworkBoom.particleColor = SKColor.init(colorLiteralRed: 102.0/255.0, green: 45.0/255.0, blue: 145.0/255.0, alpha: 1.0)
                    case 5:
                        aFireworkBoom.particleColor = SKColor.init(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.0)
                    default:
                        print("error")
                    }
                    
                    aFireworkBoom.particleColorSequence = nil
                    
                    aFireworkBoom.name = "firework"
                    aFireworkBoom.targetNode = self.scene
                    aFireworkBoom.particleZPosition = 50
                    self.addChild(aFireworkBoom)
                    
                    run(SKAction.sequence([
                        SKAction.wait(forDuration: 0.4),
                        SKAction.run(startClapping)
                        ])
                    )
                    
                } else {
                    
                    // incorrect!
                    
                    delegate.incorrectHits += 1

                    let overlay = SKSpriteNode(color: SKColor.init(colorLiteralRed: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.25), size: anItem.size)
                    overlay.zPosition = 1
                    overlay.alpha = 0
                    anItem.addChild(overlay)
                    overlay.run(SKAction.fadeIn(withDuration: 0.4))
                    
                    let aLabel = SKLabelNode(fontNamed:"Arial")
                    aLabel.text = anItem.personsName
                    aLabel.position = CGPoint(x: 0.0, y: -160)
                    aLabel.fontSize = 36
                    aLabel.zPosition = 2
                    aLabel.fontColor = SKColor.init(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                    aLabel.verticalAlignmentMode = .center
                    aLabel.horizontalAlignmentMode = .center
                    aLabel.alpha = 0
                    anItem.addChild(aLabel)
                    aLabel.run(SKAction.fadeIn(withDuration: 0.4))

                }
                
                numAttempts += 1
                
                if numAttempts >= 6 {
                    
                    touchable = false
                    
                    run(SKAction.sequence([
                        SKAction.wait(forDuration: 0.4),
                        SKAction.run(startClapping)
                        ])
                    )

                    
                }
                
            }
            
        }
        
    }
    
    func startClapping() {
        
        //print("startClapping")
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 0.0),
            SKAction.run(gameOver)
            ])
        )
        
    }
    
    func gameOver() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate // swift 2
        
        delegate.incrementMusicTrack()
        
        viewController.replaceTheScene(screenToggle: GAME_01)
        
    }
    
    func tappedButton(button: jrtbButton) {
        print("tappedButton tappedButton tag=\(String(describing: button.name))")
        
        if button.name == "closeAction" {
            
            print("closeAction")
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: 0.1),
                SKAction.run() {
                    self.viewController.replaceTheScene(screenToggle: MENU)
                }
                ])
            )
            
        }
    }
    
    override func willMove(from view: SKView) {
        
        print("removing game scene 01 from view")
        
        menuD = nil
        
        removeAllChildren()
        removeAllActions()
        
    }
    
    deinit {
        // perform the deinitialization
        
        print("running deinit on game scene 01")
        
    }
    
}

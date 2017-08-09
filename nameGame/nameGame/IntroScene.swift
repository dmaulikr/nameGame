//
//  IntroScene.swift
//  grandpasworkshop
//
//  Created by jrtb on 8/30/16.
//  Copyright © 2016 fairladymedia. All rights reserved.
//
// This is the SpriteKit scene that is loaded once during the app's startup

import SpriteKit

class IntroScene: SKScene {
    
    weak var viewController: GameViewController!
    
    private var touched: Bool = false
    
    private var mainBack: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        backgroundColor = SKColor.init(colorLiteralRed: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0)

        let newBackGround = SKSpriteNode(color: SKColor.init(colorLiteralRed: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0), size: self.size)
        newBackGround.alpha = 0
        newBackGround.position = CGPoint(x: viewController.sceneWidth/2, y: viewController.sceneHeight/2)
        newBackGround.zPosition = 1
        addChild(newBackGround)
        newBackGround.run(SKAction.fadeIn(withDuration: 0.4))
        
        mainBack = SKSpriteNode(imageNamed:"logo")
        mainBack.position = CGPoint(x: viewController.sceneWidth/2, y: viewController.sceneHeight/2)
        mainBack.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        mainBack.zPosition = 2
        addChild(mainBack)

        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run(start)
            ]),withKey:"start"
        )
        
    }
    
    func start() {
        
        touched = true
        
        let delegate = UIApplication.shared.delegate as! AppDelegate // swift 3

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
        MusicPlayer.setPrimary(name: "marbles_menu")
        MusicPlayer.play()
        if delegate.muted {
            MusicPlayer.pause()
        }
        
        mainBack.run(SKAction.fadeOut(withDuration: 1.0))

        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run(start2)
            ]),withKey:"start2"
        )

    }
    
    func start2() {
        
        viewController.replaceTheScene(screenToggle: MENU)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        if !touched {
            
            touched = true
            
            start()
            
        }
        
    }
    
    override func update(_ currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    override func willMove(from view: SKView) {
        
        print("removing intro from view")
        
        removeAllChildren()
        removeAllActions()
        
    }
    
    deinit {
        // perform the deinitialization
        
        print("running deinit on intro scene")
        
    }
    
}

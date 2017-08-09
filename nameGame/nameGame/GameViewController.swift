//
//  GameViewController.swift
//  grandpasworkzone
//
//  Created by jrtb on 1/11/17.
//  Copyright © 2017 fairladymedia. All rights reserved.
//
// This is the SpriteKit Game View Controller - it handles all the logic of switching and initing scenes

import UIKit
import SpriteKit
import AVFoundation

let INTRO = 151
let MENU = 152

let GAME_01 = 154

class GameViewController: UIViewController {
    
    let fixedWidth: CGFloat = 2048.0
    let fixedHeight: CGFloat = 1536.0
    var sceneWidth: CGFloat!
    var sceneHeight: CGFloat!
    var sceneOriginX: CGFloat!
    var sceneOriginY: CGFloat!
    
    var sceneLeft: CGFloat!
    var sceneRight: CGFloat!
    var sceneTop: CGFloat!
    var sceneBottom: CGFloat!
    
    var sceneScale: CGFloat!
    
    func replaceTheScene(screenToggle: Int) {
        
        // this method is called to switch scenes within the game
        
        let newScreenToggle: Int = screenToggle
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
        
        switch newScreenToggle {
        case INTRO:
            let scene = IntroScene(size:CGSize(width: fixedWidth, height: fixedHeight))
            scene.scaleMode = .aspectFill
            scene.viewController = self
            skView.presentScene(scene)
        case MENU:
            let scene = MenuScene(size:CGSize(width: fixedWidth, height: fixedHeight))
            scene.scaleMode = .aspectFill
            scene.viewController = self
            skView.presentScene(scene)
        case GAME_01:
            let scene = GameScene_01(size:CGSize(width: fixedWidth, height: fixedHeight))
            scene.scaleMode = .aspectFill
            scene.viewController = self
            skView.presentScene(scene)
        default:
            print("attempted to load scene that doesn't exist" + String(screenToggle))
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // this is the first method called when this loads the first time, handles first time init
        
        // setup screen dimension helpers
        
        let viewSize: CGRect = UIScreen.main.bounds
        let viewWidth = viewSize.width
        let viewHeight = viewSize.height
        sceneWidth = fixedWidth
        sceneHeight = fixedHeight
        
        print("viewHeight: " + String(describing: viewHeight))
        print("viewWidth: " + String(describing: viewWidth))
        
        let deviceAspectRatio = viewWidth/viewHeight
        let sceneAspectRatio = sceneWidth/sceneHeight
        
        //print("deviceAspectRatio: " + String(deviceAspectRatio))
        //print("sceneAspectRatio: " + String(sceneAspectRatio))
        
        sceneOriginX = 0.0
        sceneOriginY = 0.0
        
        //If the the device's aspect ratio is smaller than the aspect ratio of the preset scene dimensions, then that would mean that the visible width will need to be calculated
        //as the scene's height has been scaled to match the height of the device's screen. To keep the aspect ratio of the scene this will mean that the width of the scene will extend
        //out from what is visible.
        //The opposite will happen in the device's aspect ratio is larger.
        if deviceAspectRatio < sceneAspectRatio {
            let newSceneWidth = (sceneWidth * viewHeight) / sceneHeight
            let sceneWidthDifference = (newSceneWidth - viewWidth)/2
            let diffPercentageWidth = sceneWidthDifference / (newSceneWidth)
            
            sceneScale = 1.0 - diffPercentageWidth
            
            //Increase the x-offset by what isn't visible from the lrft of the scene
            sceneOriginX = round(diffPercentageWidth * sceneWidth)
            //Multipled by 2 because the diffPercentageHeight is only accounts for one side(e.g right or left) not both
            sceneWidth = round(sceneWidth - (diffPercentageWidth * 2 * sceneWidth))
        } else {
            let newSceneHeight = (sceneHeight * viewWidth) / sceneWidth
            let sceneHeightDifference = (newSceneHeight - viewHeight)/2
            let diffPercentageHeight = fabs(sceneHeightDifference / (newSceneHeight))
            
            sceneScale = 1.0 - diffPercentageHeight
            
            //Increase the y-offset by what isn't visible from the bottom of the scene
            sceneOriginY = round(diffPercentageHeight * sceneHeight)
            //Multipled by 2 because the diffPercentageHeight is only accounts for one side(e.g top or bottom) not both
            sceneHeight = round(sceneHeight - (diffPercentageHeight * 2 * sceneHeight))
        }
        
        sceneBottom = round(sceneOriginY)
        sceneTop = round(sceneBottom+sceneHeight)
        sceneLeft = round(sceneOriginX)
        sceneRight = round(sceneLeft+sceneWidth)
        
        replaceTheScene(screenToggle: INTRO)
        
        // for testing
        
        //replaceTheScene(screenToggle: GAME_01)
        
    }
        
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

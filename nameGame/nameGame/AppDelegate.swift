//
//  AppDelegate.swift
//  nameGame
//
//  Created by jrtb on 8/9/17.
//  Copyright © 2017 fairladymedia. All rights reserved.
//

import UIKit
import SpriteKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var muted = false // has the app been muted in the menu?
    
    var musicTrack: Int = 1 + Int(arc4random() % 6) // which music track are we on
    
    var musicLoaded: Bool = false // have the music files been loaded once into the sound library?

    var firstNames = [String]() // first names of People from data feed
    var lastNames = [String]() // last names of People from data feed
    var imageURLs = [String]() // images URLs of People from data feed
    var images = [SKSpriteNode]() // actual images from URLs of People
    var imagesLoaded = [Bool]() // have I loaded this image before?

    var dataLoaded: Bool = false // has the data feed been processed? Doesn't include loading images
    
    var correctHits: Int = 0 // number of taps on the correct person
    var incorrectHits: Int = 0 // number of taps on the incorrect person

    func incrementMusicTrack() {
        
        musicTrack += 1
        if musicTrack > 6 {
            musicTrack = 1
        }
    }
    
    // method used to load the data feed from the public API
    func loadData() {
        
        URLCache.shared = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
        DataManager.getDataWithSuccess { (data) -> Void in
            
            var json: Any!
            do {
                json = try JSONSerialization.jsonObject(with: data)
            } catch {
                print(error)
            }
            
            guard let dictionary = json as? [String: Any] else {
                return()
            }
            
            //print(dictionary)
            
            guard let incomingData = IncomingData(json: dictionary) else {
                print("Error initializing object")
                return()
            }
            
            //print(incomingData)
            
            self.dataLoaded = true
            
            self.parseData(incomingData: incomingData)
            
            //print(incomingData.feed?.entries)
            
        }
        
    }
    
    // method used to load an image via HTTP for a given person once the URL is known
    func getImageForURL(aURL: String) -> SKSpriteNode {
        
        if let url = URL(string: aURL) {
            //let contents = try String(contentsOf: url)
            //print(contents)
            
            do {
                
                let data = try Data(contentsOf: url)
                // do something with data
                
                let theImage = UIImage(data: data)
                let Texture = SKTexture(image: theImage!)
                return SKSpriteNode(texture: Texture)
                
                // if the call fails, the catch block is executed
            } catch {
                print(error.localizedDescription)
                
                // append empty sprite in case URL isn't valid
                return SKSpriteNode(color: UIColor.clear, size: CGSize(width: 100, height: 100))
            }
            
        } else {
            // append empty sprite in case URL isn't valid
            return SKSpriteNode(color: UIColor.clear, size: CGSize(width: 100, height: 100))
            
        }
        
    }

    // parse the data from the data feed from Glass into normal sequences/collections
    func parseData(incomingData: IncomingData) {
        
        for aPerson in incomingData.items! {
            self.firstNames.append(aPerson.firstName)
            self.lastNames.append(aPerson.lastName)
            self.imageURLs.append(aPerson.imageURL!)
            self.images.append(SKSpriteNode(color: UIColor.clear, size: CGSize(width: 400.0, height: 400.0)))
            self.imagesLoaded.append(false)
        }

        dataLoaded = true
        
        // start loading images for people
        
        for index in 0 ..< images.count {
            
            let anImage = images[index]
            
            anImage.texture = getImageForURL(aURL: imageURLs[index]).texture

            imagesLoaded[index] = true

        }
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        loadData()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

// a couple helper methods to handle shuffling sequences/collections

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}

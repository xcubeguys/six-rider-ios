//
//  SplashScreen.swift
//  splashvideo
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import AVFoundation

let PLAYER_VOLUME: Float = 0.0
let BUTTON_PADDING: Float = 20.0
let BUTTON_CORNER_RADIUS: Float = 8.0
let BUTTON_ANIM_DURATION: Float = 3.0
let TITLE_ANIM_DURATION: Float = 5.0
let TITLE_FONT_SIZE: Float = 72.0


class SplashScreen: UIViewController {

    var player: AVPlayer?
    @IBOutlet weak var playerView: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        self.createVideoPlayer()
        // Do any additional setup after loading the view.
    }

    func showNav()
    {
        let value = UserDefaults.standard.object(forKey: "userid")
        if value != nil{
            
            self.appDelegate.leftMenu()
        }
        else{
            self.appDelegate.setRootViewController()
        }
        //performSegue(withIdentifier: "splashScreen", sender: self)
    }
    func createVideoPlayer() {
        
        let filePath: String? = Bundle.main.path(forResource: "welcome_video", ofType: "mp4")
        let videoURL = URL(fileURLWithPath: filePath!)
        player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        perform(#selector(showNav), with: nil, afterDelay: 2.5)
        player?.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func applicationDidBecomeActive(_ notification: Notification) {
        if !(player != nil) {
            return
        }
        
        player?.play()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

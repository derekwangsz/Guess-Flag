//
//  LaunchViewController.swift
//  GuessFlag
//
//  Created by Derek Wang on 2020-12-14.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var flagImage: UIImageView!
    
    let flagsArray = ["france","spain","germany","uk",
                       "us","estonia","nigeria","monaco",
                       "italy","poland","russia","ireland"]
    var index = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.layer.cornerRadius = 20
        playButton.layer.masksToBounds = true
        
        Timer.scheduledTimer(withTimeInterval: 0.75, repeats: true) { (timer) in
            
            self.flagImage.image = UIImage(named: self.flagsArray[self.index])
            if self.index < 11{
                self.index += 1
            }else{
                self.index = 0
            }
        }
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toPlay", sender: self)
    }
    
}

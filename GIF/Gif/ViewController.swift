//
//  ViewController.swift
//  Gif
//
//  Created by Hussain on 12/30/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var gifURLs = [
        "https://gifbin.com/bin/062020/girl-balancing-on-a-ball-puts-sunglasses-on.gif",
        "https://gifbin.com/bin/052019/blond-girl-throws-first-pitch.gif",
        "https://gifbin.com/bin/072013/1373305270_amazing_first_pitch__south_korean_rhythmic_gymnast_shin_sooji.gif",
        "https://gifbin.com/bin/052012/1337623365_japanese_chick_baseball_pitch_fail.gif",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.loadGIF(with: gifURLs, isRepeat: false, completion: {
            self.showAlert(withTitle: "", withMessage: "All GIF played")
        })
    }
}


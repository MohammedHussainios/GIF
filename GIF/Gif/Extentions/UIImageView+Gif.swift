//
//  UIImageView+Gif.swift
//  Gif
//
//  Created by Hussain on 12/31/22.
//

import UIKit

extension UIImageView {
    private struct GIF {
        static var gifURLs: [String] = []
        static var lastIndex: Int = 0
        static var isRepeat: Bool = false
        static var animationFinished: (()->())?

    }
    
    static var animationFinished: (()->())? {
        set(newValue) {
            GIF.animationFinished = newValue
        }
        get {
            return GIF.animationFinished
        }
    }
    private var gifURLs: [String] {
        get {
            return GIF.gifURLs
        }
        set(newValue) {
            GIF.gifURLs = newValue
        }
    }
    
    private var lastIndex: Int {
        get {
            return GIF.lastIndex
        }
        set(newValue) {
            GIF.lastIndex = newValue
        }
    }
    
    public func loadGIF(with URLs: [String], isRepeat: Bool = false, completion: (()->())?) {
        gifURLs = URLs
        GIF.isRepeat = isRepeat
        if let url = gifURLs.first {
            loadGIF(with: url)
        }
        UIImageView.animationFinished = completion
    }
    
    public func loadGIF(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    public func loadGIF(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    private func loadGIF(with URL: String) {
        DispatchQueue.global().async {
            guard let image = UIImage.gif(url: URL) else {
                print("Faile to loadURL")
                self.loadNextGIF()
                return
            }
            self.startGIFAnimation(image)
        }
    }

    fileprivate func startGIFAnimation(_ image: UIImage) {
        DispatchQueue.main.async {
            self.animationImages = image.images
            print("Animation Strated")
            
            var values = [CGImage]()
            for image in image.images! {
                values.append(image.cgImage!)
            }
            
            // Create animation and set SwiftGif values and duration
            let animation = CAKeyframeAnimation(keyPath: "contents")
            animation.calculationMode = CAAnimationCalculationMode.discrete
            animation.duration = image.duration
            animation.values = values
            // Set the repeat count
            animation.repeatCount = 1
            // Other stuff
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            // Set the delegate
            animation.delegate = self
            self.layer.add(animation, forKey: "animation")
            self.animationDuration = 1
            self.animationRepeatCount = 0
        }
    }
    
    /// Load next .gif File
    private func loadNextGIF() {
        lastIndex += 1
        if gifURLs.count > lastIndex {
            loadGIF(with: gifURLs[lastIndex])
        } else if  GIF.isRepeat == true {
            lastIndex = 0
            loadGIF(with: gifURLs[lastIndex])
        } else {
            // Do action if required
            GIF.animationFinished?()
        }
    }
}

extension UIImageView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            print("Animation finished")
            loadNextGIF()
        }
    }
}

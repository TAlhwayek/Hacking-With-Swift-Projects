//
//  ViewController.swift
//  Animation
//
//  Created by Tony Alhwayek on 8/1/23.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Create new image view
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
//        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            // Grow image
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
            // Return default image size
            case 1:
                self.imageView.transform = .identity
            // Move image (to the top-left-ish corner in this situation)
            // Note: X and Y are relative, not absolute
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            // Return image back to default spot
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        }) { finished in
            // Reveal the button
            sender.isHidden = false
        }
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
    
}


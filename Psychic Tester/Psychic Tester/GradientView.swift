//
//  GradientView.swift
//  Psychic Tester
//
//  Created by Tony Alhwayek on 8/24/23.
//

import UIKit

@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = .white
    @IBInspectable var bottomColor: UIColor = .black
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
    
    
    
    
    
}

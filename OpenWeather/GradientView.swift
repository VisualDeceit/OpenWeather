//
//  GradientView.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 12.12.2020.
//

import UIKit

@IBDesignable class GradientView: UIView {

    
    override static var layerClass: AnyClass {
            return CAGradientLayer.self
        }
        
        var gradientLayer: CAGradientLayer {
            return self.layer as! CAGradientLayer
        }
    
    
    @IBInspectable var startColor: UIColor = UIColor(red: 187.0, green: 101.0, blue: 76.0, alpha: 1.0) {
        didSet {
            self.updateColors()
        }
    }
    @IBInspectable var endColor: UIColor = .white {
        didSet {
            self.updateColors()
        }
    }
    @IBInspectable  var startLocation: CGFloat = 0 {
        didSet {
            self.updateLocations()
        }
    }
    @IBInspectable var endLocation: CGFloat = 1 {
        didSet {
            self.updateLocations()
        }
    }
    @IBInspectable var startPoint: CGPoint = .zero {
        didSet {
            self.updateStartPoint()
        }
    }
    @IBInspectable var endPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            self.updateEndPoint()
        }
    }

    func updateLocations() {
        self.gradientLayer.locations = [self.startLocation as NSNumber, self.endLocation as NSNumber]
    }
        
    func updateColors() {
        self.gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
    }

    func updateStartPoint() {
        self.gradientLayer.startPoint = startPoint
    }

    func updateEndPoint() {
        self.gradientLayer.endPoint = endPoint
    }
    
}

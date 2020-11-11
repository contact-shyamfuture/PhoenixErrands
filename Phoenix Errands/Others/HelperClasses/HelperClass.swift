//
//  HelperClass.swift
//  DealerApp
//
//  Created by Shyam Future Tech on 28/01/19.
//  Copyright © 2019 Shyam Future Tech. All rights reserved.
//

import Foundation
import UIKit

class RoundUIView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.5 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    @IBInspectable var shadowColor: UIColor = UIColor.white {
        didSet {
            self.layer.shadowColor = shadowColor.cgColor
            
        }
    }
    //shadowOpacity
    @IBInspectable var shadowOpacity:  CGFloat = 0.5 {
        didSet {
            self.layer.shadowOpacity = Float(shadowOpacity)
            
        }
    }
}

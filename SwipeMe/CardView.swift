//
//  CardView.swift
//  ViewSwiping
//
//  Created by Steven Gibson on 12/19/14.
//  Copyright (c) 2014 OakmontTech. All rights reserved.
//

import UIKit

class CardView: UIView {

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CardView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as UIView
    }
    
    
    
}

    extension UIView {
        class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
            return UINib(
                nibName: nibNamed,
                bundle: bundle
                ).instantiateWithOwner(nil, options: nil)[0] as? UIView
            
        }
    }
   


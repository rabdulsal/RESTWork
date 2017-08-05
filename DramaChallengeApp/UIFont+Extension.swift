//
//  UIFont+Extension.swift
//  DramaChallengeApp
//
//  Created by Rashad Abdul-Salaam on 8/4/17.
//  Copyright © 2017 Rashad, Inc. All rights reserved.
//

import Foundation
import UIKit


extension UIFont {
    
    class func ralewayRegular(_ size: CGFloat) -> Self {
        return self.init(name: "Raleway", size: size)!
    }
    
    class func ralewayThin( _ size: CGFloat) -> Self {
        return self.init(name: "Raleway-Thin", size: size)!
    }
    
    class func ralewayLight( _ size: CGFloat) -> Self {
        return self.init(name: "Raleway-Light", size: size)!
    }
    
    class func ralewayExtraBold( _ size: CGFloat) -> Self {
        return self.init(name: "Raleway-ExtraBold", size: size)!
    }
    
    class func ralewayBold( _ size: CGFloat) -> Self {
        return self.init(name: "Raleway-Bold", size: size)!
    }
    
    class func ralewaySemiBold( _ size: CGFloat) -> Self {
        return self.init(name: "Raleway-SemiBold", size: size)!
    }
    
    class func ralewayHeavy( _ size: CGFloat) -> Self {
        return self.init(name: "Raleway-Heavy", size: size)!
    }
    
    class func ralewayMedium( _ size: CGFloat) -> Self {
        return self.init(name: "Raleway-Medium", size: size)!
    }
    
    class func ralewayExtraLight( _ size: CGFloat) -> Self {
        return self.init(name: "Raleway-ExtraLight", size: size)!
    }
    
}

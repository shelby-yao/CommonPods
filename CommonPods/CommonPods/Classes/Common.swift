//
//  Common.swift
//  CommonPods
//
//  Created by Shelby on 2019/1/16.
//

import Foundation




enum ValidatedType {
    
    case Email
    
    case PhoneNumber
    
}


public class Common: NSObject {
    
    public class func clip9Image(image: UIImage?, insets: UIEdgeInsets, model: UIImage.ResizingMode = .stretch) -> UIImage? {
        return image?.resizableImage(withCapInsets: insets, resizingMode: model)
    }
    
    public class func bundleImage(imageName: String) -> UIImage? {
        let path = Bundle(for: Common.self).resourcePath! + "/TakePhoto.bundle"
        let CABundle = Bundle(path: path)
        return UIImage(named: imageName, in: CABundle, compatibleWith: nil)
    }
}

public extension Float {
    var formatFloat: String {
        if fmodf(self, 1) == 0 { //没小数
            return String(format: "%.0f", self)
        } else if fmodf(self * 10, 1) == 0 { //一位小数
            return String(format: "%.1f", self)
        } else { //一位以上小数
            return String(format: "%.2f", self)
        }
    }
}


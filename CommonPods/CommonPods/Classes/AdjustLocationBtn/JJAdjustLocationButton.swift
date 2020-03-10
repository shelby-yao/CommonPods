//
//  JJAdjustLocationButton.swift
//  InternetHospital
//
//  Created by Jekin on 2019/1/11.
//  Copyright © 2019 ZhuJiangChilink. All rights reserved.
//

import UIKit
import JKUIViewExtension
public enum JJButtonEdgeInsetsStyle {
    case right
    case left
    case top
    case bottom
}

public class JJAdjustLocationButton: UIButton {
 
   public var style: JJButtonEdgeInsetsStyle = .right
    public var space: CGFloat = 0
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        let imageWidth = imageView?.width ?? 0.0
        let imageHeight = imageView?.height ?? 0.0
        let labelWidth = titleLabel?.width ?? 0.0
        let labelHeight = titleLabel?.height ?? 0.0
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        switch self.style {
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+self.space/2.0, bottom: 0, right: -labelWidth-self.space/2.0);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth-self.space/2.0, bottom: 0, right: imageWidth+self.space/2.0);
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space/2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight-space/2.0, right: 0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -self.space/2.0, bottom: 0, right: self.space/2.0);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: self.space/2.0, bottom: 0, right: -self.space/2.0);
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight-self.space/2.0, right: -labelWidth);
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight-self.space/2.0, left: -imageWidth, bottom: 0, right: 0);
 
        }
        
        titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
}

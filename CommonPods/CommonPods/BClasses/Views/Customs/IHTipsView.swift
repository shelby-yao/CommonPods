//
//  IHTipsView.swift
//  BusinessPods
//
//  Created by Shelby on 2019/4/24.
//

import UIKit
import JKUIViewExtension
import YYCategories
public class IHTipsView: UIView {
   public enum tipsType {
        case success
    }
    let tipsLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.init(red: 23/255.0, green: 113/255.0, blue: 251/255.0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    let animation = UIImageView()
    private let whiteBackView = UIView.init(frame: CGRect(x: 0, y: 0, width: 190, height: 150))
    open var canMask: Bool {
        get {
            return self.isUserInteractionEnabled
        }
        set {
            self.isUserInteractionEnabled = newValue
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 4/255.0, green: 14/255.0, blue: 28/255.0, alpha: 0.5)
        whiteBackView.backgroundColor = .white
        whiteBackView.layer.cornerRadius = 10
        whiteBackView.layer.masksToBounds = true
        self.addSubview(whiteBackView)
        let image = Business.bundleImage(imageName: "Mr_icon_complete")
        self.addSubview(animation)
        self.addSubview(tipsLabel)
        animation.image = image
//        animation.sizeToFit()
        whiteBackView.center = self.center
        
        animation.frame = CGRect(x: 0, y: whiteBackView.y + 23, width: 57, height: 71)
        animation.centerX = whiteBackView.centerX
        tipsLabel.frame = CGRect(x: 0, y: animation.maxY + 15, width: 300, height: 17)
    }
    
    public func setupTips(txt: String, type: IHTipsView.tipsType = .success) {
        tipsLabel.text = txt
        tipsLabel.sizeToFit()
        tipsLabel.centerX = animation.centerX
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

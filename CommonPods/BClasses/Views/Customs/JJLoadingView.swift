//
//  IHLoadingView.swift
//  BusinessPods
//
//  Created by Jekin on 2019/2/28.
//


import UIKit

public class JJLoadingView: UIView {
    private let whiteBackView = UIView.init(frame: CGRect(x: 0, y: 0, width: 102, height: 102))
    private let imageView: UIImageView = UIImageView.init(image: Business.bundleImage(imageName: "loading"))
    open var canMask: Bool {
        get {
            return self.isUserInteractionEnabled
        }
        set {
            self.isUserInteractionEnabled = newValue
        }
    }
    deinit {
        imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        whiteBackView.center = self.center
        imageView.size = CGSize(width: 40, height: 40)
        imageView.center = self.center
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        whiteBackView.backgroundColor = .clear
        whiteBackView.layer.cornerRadius = 10
        whiteBackView.layer.masksToBounds = true
        self.addSubview(whiteBackView)
        
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimation() {
        DispatchQueue.main.async {
            self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
            let an = CABasicAnimation.init(keyPath: "transform.rotation.z")
            an.toValue = Double.pi
            an.duration = 0.5
            an.isCumulative = true
            an.repeatCount = Float(INT_MAX)
            an.isRemovedOnCompletion = false
            self.imageView.layer.add(an, forKey: "rotationAnimation")
        }
        
    }
    
    public func endAnimation() {
        DispatchQueue.main.async {
           self.imageView.layer.removeAnimation(forKey: "rotationAnimation")
        }
    }
}


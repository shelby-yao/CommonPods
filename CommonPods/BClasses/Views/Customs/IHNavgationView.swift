//
//  IHNavgationView.swift
//  BusinessPods
//
//  Created by Shelby on 2019/1/23.
//

import UIKit
import SnapKit
open class IHNavigationView: UIView {
    
    private var titleString: String?
    private var topHeight: CGFloat = 0
    private var topInsert: CGFloat = 0
    
    lazy private var ctView: UIView = UIView()
    lazy private var leftOView: UIView = UIView()
    lazy private var leftTView: UIView = UIView()
    lazy private var rightOView: UIView = UIView()
    lazy private var rightTView: UIView = UIView()
    lazy private var titleC: UIColor = UIColor()
    
    
    public lazy var bgView = UIImageView()
    public var leftViewSpace: CGFloat = 0
    public var rightViewSpace: CGFloat = 0

    
    

    /// 自定义导航view初始化方法
    ///
    /// - Parameters:
    ///   - topHeight: 整个view的高 有默认值
    ///   - topInsert: 跟电池栏的偏移默认0
    public init(topHeight: CGFloat, topInsert: CGFloat) {
        self.topHeight = topHeight
        self.topInsert = topInsert
        var height: CGFloat = 0
        let navH = jj_navHeight()
        let gap = jj_insetGap()
        if topHeight > 0 {
            height = navH + gap + (topHeight - 78)
        } else {
            height = navH + gap
        }
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height))
        self.setupUI()
    }
    
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    private func setupUI() {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { (m) in
            m.edges.equalToSuperview()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let centerPoint = CGPoint(x: self.center.x,
                                  y: self.center.y + topGap() / 2)
        ctView.center = centerPoint
        
        ctView.frame = CGRect(x: ctView.frame.origin.x,
                              y: topGap() + topInsert,
                              width: ctView.frame.size.width,
                              height: ctView.frame.size.height)
        
        leftOView.center = ctView.center
        leftTView.center = ctView.center
        rightOView.center = ctView.center
        rightTView.center = ctView.center
        
        leftOneView.frame = CGRect(x: 15,
                                   y: leftOView.frame.origin.y,
                                   width: leftOView.frame.size.width,
                                   height: leftOView.frame.size.height)
        
        leftTView.frame = CGRect(x: leftOView.frame.maxX + leftViewSpace,
                                 y: leftTView.frame.origin.y,
                                 width: leftTView.frame.size.width,
                                 height: leftTView.frame.size.height)
        
        rightOView.frame = CGRect(x: self.frame.size.width - 20 - rightOView.frame.size.width,
                                  y: rightOView.frame.origin.y,
                                  width: rightOView.frame.size.width,
                                  height: rightOView.frame.size.height)
        
        rightTView.frame = CGRect(x: rightOView.frame.minX - rightViewSpace - rightTView.frame.width,
                                  y: rightTView.frame.origin.y,
                                  width: rightTView.frame.size.width,
                                  height: rightTView.frame.size.height)
    }
    
    
    
}

extension IHNavigationView {
    public var leftOneView: UIView {
        set {
            if newValue !== leftOView {
                leftOView.removeFromSuperview()
            }
            leftOView = newValue
            self.addSubview(leftOView)
        }
        get {
            return leftOView
        }
    }
    
    public var leftTwoView: UIView {
        set {
            if newValue !== leftTView {
                leftTView.removeFromSuperview()
            }
            leftTView = newValue
            self.addSubview(leftTView)
        }
        get {
            return leftTView
        }
    }
    
    public var rightOneView: UIView {
        set {
            if newValue !== rightOView {
                rightOView.removeFromSuperview()
            }
            rightOView = newValue
            self.addSubview(rightOView)
        }
        get {
            return rightOView
        }
    }
    public var rightTwoView: UIView {
        set {
            if newValue !== rightTView {
                rightTView.removeFromSuperview()
            }
            rightTView = newValue
            self.addSubview(rightTView)
        }
        get {
            return rightTView
        }
    }
    
    public var centerView: UIView {
        get {
            return ctView
        }
        set {
            if ctView !== newValue {
                ctView.removeFromSuperview()
                ctView = newValue
                self.addSubview(ctView)
            }
        }
    }
    
    public var titleColor: UIColor {
        set {
            titleC = newValue
            if self.ctView.isKind(of: UILabel.self) {
                if let label = self.ctView as? UILabel {
                    label.textColor = titleC
                }
            }
        }
        get {
            return titleC
        }
    }
    
    public var title: String? {
        set {
            titleString = newValue
            var label: UILabel
            if self.ctView.isKind(of: UILabel.self) {
                label = self.ctView as! UILabel
                label.text = newValue
            } else {
                label = UILabel()
                addSubview(label)
                label.text = newValue
                label.font = UIFont.boldSystemFont(ofSize: 18)
                label.textColor = UIColor.white
            }
            self.centerView = label
//            label.bounds = CGRect(x: 0, y: 0, width: 100, height: 18)
            label.sizeToFit()
            self.layoutIfNeeded()
        }
        get {
            return titleString ?? ""
        }
    }
}



private func jj_navHeight() -> CGFloat {
    if #available(iOS 11.0, *) {
        var top: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        top = top > 0 ? top : 20
        return 44 + top
    }
    return 64.0
}
private func jj_insetGap() -> CGFloat {
    if #available(iOS 11.0, *) {
        if jj_iphoneIsSave() {
            return 0
        } else {
            return 14
        }
    } else {
        return 14
    }
}
private func jj_iphoneIsSave() -> Bool {
    if #available(iOS 11.0, *) {
        return (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)! > 0
    } else {
        return false
    }
}

private func topGap() -> CGFloat {
    if #available(iOS 11.0, *) {
        let top: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
        if top > CGFloat(0) {
            return CGFloat(top + 10)
        } else {
            return CGFloat(20 + 10)
        }
    } else {
        return CGFloat(20 + 10)
    }
}

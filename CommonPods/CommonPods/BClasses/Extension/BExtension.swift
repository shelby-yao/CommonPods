//
//  Extension.swift
//  SmartHome
//
//  Created by Jekin on 2018/12/24.
//  Copyright © 2018 liumaoqiang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
var disposeBagKey = 100
var insetsKey = 103
var tipsViewKey = 104


public extension NSObject {
    var disposeBag: DisposeBag {
        set {
            objc_setAssociatedObject(self, &disposeBagKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            if let result = objc_getAssociatedObject(self, &disposeBagKey) as? DisposeBag {
                return result
            }
            let dispose = DisposeBag()
            objc_setAssociatedObject(self, &disposeBagKey, dispose, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return dispose
        }
    }
    
}

public extension UIView {
    var statusViewInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, &insetsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            return objc_getAssociatedObject(self, &insetsKey) as? UIEdgeInsets
        }
    }

    
    var tipsView: IHTipsView {
        set {
            objc_setAssociatedObject(self, &tipsViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            var tipsView: IHTipsView
            if let result = objc_getAssociatedObject(self, &tipsViewKey) as? IHTipsView {
                tipsView = result
            } else {
                tipsView = IHTipsView(frame: self.bounds)
                tipsView.canMask = true
                objc_setAssociatedObject(self, &tipsViewKey, tipsView, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return tipsView
        }
    }
    
    func showTips(txt: String, type: IHTipsView.tipsType = .success) {
        DispatchQueue.main.async {
            self.tipsView.setupTips(txt: txt, type: type)
            self.tipsView.isHidden = false
            self.addSubview(self.tipsView)
            self.bringSubviewToFront(self.tipsView)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            if self.tipsView.isHidden == true {
                return
            }
            self.tipsView.isHidden = true
            self.tipsView.removeFromSuperview()
        }
    }
}

public extension UIView {
    //返回该view所在的父view
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
}


public extension String {
    func stringConvertDate(dateFormat:String="yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = dateFormat
        let date = dateFormatter.date(from: self)
        return date
    }
}

public extension Date {
    
    func dateConvertStringIncludeSpace(dateFormat: String="yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date
    }
    func dateConvertString(dateFormat: String="yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: self)
        return date.components(separatedBy: " ").first!
    }
    
    func getLocalDateFromatFromGreenWich() -> Date? {
        //设置源日期时区
        let sourceTimeZone = NSTimeZone(abbreviation: "UTC")
        //或GMT
        //设置转换后的目标日期时区
        let destinationTimeZone = NSTimeZone.local as NSTimeZone
        //得到源日期与世界标准时间的偏移量
        let sourceGMTOffset = sourceTimeZone?.secondsFromGMT(for: self)
        //目标日期与本地时区的偏移量
        let destinationGMTOffset = destinationTimeZone.secondsFromGMT(for: self)
        //得到时间偏移量的差值
        let interval = TimeInterval((destinationGMTOffset ) - (sourceGMTOffset ?? 0))
        //转为现在时间
        let destinationDateNow = Date(timeInterval: interval, since: self)
        return destinationDateNow
    }
    
    func getGreenWichDateFromatFromLocal() -> Date? {
        let sourceTimeZone = NSTimeZone.local as NSTimeZone
        let destinationTimeZone = NSTimeZone(abbreviation: "UTC")
        //目标日期与本地时区的偏移量
        let sourceGMTOffset = sourceTimeZone.secondsFromGMT(for: self)
        //得到偏格林移量
        let destinationGMTOffset = destinationTimeZone?.secondsFromGMT(for: self)
        //得到时间偏移量的差值
        let interval = TimeInterval((destinationGMTOffset ?? 0) - (sourceGMTOffset ))
        //转为格林威治
        let destinationDateNow = Date(timeInterval: interval, since: self)
        return destinationDateNow
    }
}




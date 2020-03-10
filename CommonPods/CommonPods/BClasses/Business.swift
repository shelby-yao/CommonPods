//
//  Business.swift
//  BusinessPods
//
//  Created by Shelby on 2019/1/16.
//

import UIKit

public extension UIColor {

    //主色
//     class var kMainColor: UIColor {
//         return k1375f2
//     }
//     class var k1375f2: UIColor {
//         return #colorLiteral(red: 0.1662378013, green: 0.4603819251, blue: 0.9486458898, alpha: 1)
//     }
}



public class Business: NSObject {
    //脱敏
    public class func dataMask(txt: String?, defaultShow: String = "无") -> String {
        if let t = txt {
            if t.count == 0 {
                return defaultShow
            }
            if t.count <= 7 {
                return t
            }
            var temp = ""
            for _ in 0 ..< t.count - 3 - 4 {
                temp.append("*")
            }
           let ret = (t as NSString).replacingCharacters(in: NSRange(location: 3, length: t.count - 4 - 3), with: temp)
            return ret
        } else {
            return defaultShow
        }
    }
    
    public class func transToHourMinSec(time: CGFloat) -> String
    {
        let allTime: Int = Int(time)
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        if hoursText == "00" {
            return "\(minutesText):\(secondsText)"
        }
        
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
    

        
    
    public class func emptyStringWu(txt: String?) -> String {
        return self.emptyString(txt: txt, defaultTxt: "无")
    }
    public class func emptyString(txt: String?, defaultTxt: String) -> String {
        if let t = txt {
            if t.isBlank() {
                return defaultTxt
            } else {
                return t
            }
        } else {
            return defaultTxt
        }
    }
    
    public class func defaultNil(txt: String?) -> String? {
        if let t = txt {
            if t.isBlank() {
                return nil
            } else {
                return t
            }
        } else {
            return nil
        }
    }
    
    
    public class func bundleImage(imageName: String) -> UIImage? {
        if let resourcePath = Bundle(for: Business.self).resourcePath {
            let path = resourcePath + "/business.bundle"
            let CABundle = Bundle(path: path)
            return UIImage(named: imageName, in: CABundle, compatibleWith: nil)
        }
        return nil
    }

    
    public class func bundleImageMirror(imageName: String, orientation: UIImage.Orientation ) -> UIImage? {
        if let resourcePath = Bundle(for: Business.self).resourcePath {
            let path = resourcePath + "/business.bundle"
            let CABundle = Bundle(path: path)
            let oriImage = UIImage(named: imageName, in: CABundle, compatibleWith: nil)
            if let cgImage = oriImage?.cgImage {
                return  UIImage(cgImage: cgImage, scale: oriImage?.scale ?? 1, orientation: orientation)
            }
            return nil
        }
        return nil
    }
    

    
    public class func isIncludeNow(date: String?, startTime: String?, endTime: String?, formatter: String = "yyyy-MM-ddHH:mm") -> Bool {
        guard let theDate = date, let theStartTime = startTime, let theEndTime = endTime else {
            return false
        }
        let currentDate = Date()
        if let startDate = (theDate + theStartTime).stringConvertDate(dateFormat: formatter), let endDate = (theDate + theEndTime).stringConvertDate(dateFormat: formatter) {
            let s2c = startDate.compare(currentDate)
            let c2e = currentDate.compare(endDate)
            if s2c != .orderedDescending && c2e != .orderedDescending {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    //根据身份证获取出生日期
        public class func birthdayStrFromIdentityCard(numberStr: String) -> String {
            var year: String = ""
            var month: String
            var day: String
            //截取前14位
    //        let fontNumber = (numberStr as NSString).substringWithRange(NSMakeRange(0, 14))
            //判断是18位身份证还是15位身份证
            if (numberStr as NSString).length == 18 {
                year = (numberStr as NSString).substring(with: NSMakeRange(6, 4))
                month = (numberStr as NSString).substring(with: NSMakeRange(10, 2))
                day = (numberStr as NSString).substring(with: NSMakeRange(12, 2))
                let result = "\(year)-\(month)-\(day)"
                print(result)
                return result
            } else {
                year = (numberStr as NSString).substring(with: NSMakeRange(6, 2))
                month = (numberStr as NSString).substring(with: NSMakeRange(8, 2))
                day = (numberStr as NSString).substring(with: NSMakeRange(10, 2))
                let result = "19\(year)-\(month)-\(day)"
                print(result)
                return result
            }
        }
        //根据出生日期计算年龄的方法
      public class func caculateAge(birthday: String) -> Int{
    //        var resultTag = ""
            //格式化日期
            let d_formatter = DateFormatter()
            d_formatter.dateFormat = "yyyy-MM-dd"
            let birthDay_date = d_formatter.date(from: birthday)
            // 出生日期转换 年月日
            if let tempBirthDay_date = birthDay_date {
                let birthdayDate = NSCalendar.current.dateComponents([.year,.month,.day], from: tempBirthDay_date)
                guard let brithDateYear  = birthdayDate.year else { return 9999 }
                let brithDateDay   = birthdayDate.day
                let brithDateMonth = birthdayDate.month
                // 获取系统当前 年月日
                let currentDate = NSCalendar.current.dateComponents([.year,.month,.day], from: NSDate() as Date)
                guard let currentDateYear  = currentDate.year else { return 9999 }
                let currentDateDay   = currentDate.day
                let currentDateMonth = currentDate.month
                // 计算年龄
                var iAge = currentDateYear - brithDateYear - 1;
                if (((currentDateMonth ?? 1) > (brithDateMonth ?? 1)) || (((currentDateMonth ?? 1) == brithDateMonth) && (((currentDateDay ?? 1) >= brithDateDay ?? 1)))) {
                    iAge += 1
                }
                return iAge
            }
    //计算错误
            return 9999
        }
}

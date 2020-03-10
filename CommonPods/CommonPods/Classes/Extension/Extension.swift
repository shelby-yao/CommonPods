//
//  Extension.swift
//  CommonPods
//
//  Created by Jekin on 2019/3/21.
//

//import Foundation
//
import Toast_Swift
@inline(__always) public func DLog<T>(_ message: T) {
    #if REALSE
    
    #else
    print("DLog ==> \(message)")
    #endif
}

@inline(__always) public func DLogN<T>(_ message: T) {
    #if REALSE
    
    #else
    print(message)
    #endif
}

extension NSObject {
    func description() {
        
    }
}

extension String {
    var unicodeStr:String {
        let tempStr1 = self.replacingOccurrences(of: "\\u", with: "\\U")
        let tempStr2 = tempStr1.replacingOccurrences(of: "\"", with: "\\\"")
        let tempStr3 = "\"".appending(tempStr2).appending("\"")
        let tempData = tempStr3.data(using: String.Encoding.utf8)
        var returnStr:String = ""
        do {
            returnStr = try PropertyListSerialization.propertyList(from: tempData!, options: [.mutableContainers], format: nil) as! String
        } catch {
            print(error)
        }
        return returnStr.replacingOccurrences(of: "\\r\\n", with: "\n")
    }
}
@inline(__always) public func DLogLine<T>(_ message: T, file: String = #file, lineNumber: Int = #line) {
    #if REALSE
    #else
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):line:\(lineNumber)]- \(message)")
    #endif
}


// MARK: 转模型
public struct JJDecoder {
    public static func decode<T>(_ type: T.Type!, _ json: Any!, url: String = "") -> T? where T: Codable {
        if let theJson = json as? T {
            return theJson
        }
        let jsonDecoder = JSONDecoder()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json as Any, options: [.prettyPrinted]) else { return nil }
        var model: T?
        do {
            model = try jsonDecoder.decode(type, from: jsonData)
        } catch let e {
            #if DEBUG
            UIApplication.shared.keyWindow?.makeToast("url = \(url)\n数据格式出错\(e)")
//            assert(false, "数据格式出错\(e)")
            #else
            #endif
            return nil
        }
        
        return model
    }
}


public extension String {
    func stringValueDic() -> [String : Any]? {
        let data = self.data(using: String.Encoding.utf8)
        if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
            return dict
        }
        return nil
    }
}
// MARK: 模型转 字典&字符串
public struct JJEncoder {
    //转字符串
    public static func encoder<T>(toString model: T) -> String? where T: Codable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else {
            return nil
        }
        guard let jsonStr = String(data: data, encoding: .utf8) else {
            return nil
        }
        return jsonStr
    }
    //转字典
    public static func encoder<T>(toDictionary model: T) -> [String: Any]? where T: Codable {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let data = try? encoder.encode(model) else {
            return nil
        }
        guard let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] else {
            return nil
        }
        return dic
    }
    //二进制转字典
    public static func dataToDictionary(data: Data) -> [String: Any]? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let dic = json as? [String: Any] else {
                return nil
            }
            return dic
        } catch _ {
            return nil
        }
    }
}

public extension String {
    
    // base64编码
   public func toBase64() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    // base64解码
   public func fromBase64() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    
    func ranges(of string: String) -> [Range<String.Index>] {
        var rangeArray = [Range<String.Index>]()
        var searchedRange: Range<String.Index>
        guard let sr = self.range(of: self) else {
            return rangeArray
        }
        searchedRange = sr
        
        var resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        while let range = resultRange {
            rangeArray.append(range)
            searchedRange = Range(uncheckedBounds: (range.upperBound, searchedRange.upperBound))
            resultRange = self.range(of: string, options: .regularExpression, range: searchedRange, locale: nil)
        }
        return rangeArray
    }
    func nsrange(fromRange range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    func nsranges(of string: String) -> [NSRange] {
        return ranges(of: string).map { (range) -> NSRange in
            self.nsrange(fromRange: range)
        }
    }
}

public extension String {
    //有效邮箱
    func validateEmail() -> Bool {
        if self.isBlank() {
            return false
        }
        let Regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", Regex)
        return predicate.evaluate(with: self)
    }
    //有效手机号
     func validatePhone() -> Bool {
        if self.count != 11 {
            return false
        }
        if Int(self) != nil {
            return true
        } else {
            return false
        }
    }
    func validatePhone2() -> Bool {
        if self.isBlank() {
            return false
        }
        
        let mobile = "^1([3-9][0-9])\\d{8}$"
        let cm = "^1([3-9][0-9])\\d{8}$"
        let cu = "^1([3-9][0-9])\\d{8}$"
        let ct = "^1([3-9][0-9])\\d{8}$"
        
        let mobileRegex = NSPredicate(format: "SELF MATCHES %@", mobile)
        let cmRegex = NSPredicate(format: "SELF MATCHES %@", cm)
        let cuRegex = NSPredicate(format: "SELF MATCHES %@", cu)
        let ctRegex = NSPredicate(format: "SELF MATCHES %@", ct)
        let result: Bool = mobileRegex.evaluate(with: self)||cmRegex.evaluate(with: self)||cuRegex.evaluate(with: self)||ctRegex.evaluate(with: self)
        return result
    }
    //字符串判空
    func isBlank() -> Bool {
        if self.count == 0 {
            return true
        }
        let set = NSCharacterSet.whitespaces
        let trimmedStr = self.trimmingCharacters(in: set)
        if trimmedStr.count == 0 {
            return true
        }
        return false
    }
    
    //验证身份证号
    func isTrueIDNumber() -> Bool {
        var value = self
        value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var length: Int = 0
        length = value.count
        if length != 15 && length != 18 {
            //不满足15位和18位，即身份证错误
            return false
        }
        // 省份代码
        let areasArray = ["11", "12", "13", "14", "15", "21", "22", "23", "31", "32", "33", "34", "35", "36", "37", "41", "42", "43", "44", "45", "46", "50", "51", "52", "53", "54", "61", "62", "63", "64", "65", "71", "81", "82", "91"]
        // 检测省份身份行政区代码
        let index = value.index(value.startIndex, offsetBy: 2)
        let valueStart2 = value.substring(to: index)
        //标识省份代码是否正确
        var areaFlag = false
        for areaCode in areasArray {
            if areaCode == valueStart2 {
                areaFlag = true
                break
            }
        }
        if !areaFlag {
            return false
        }
        var regularExpression: NSRegularExpression?
        var numberofMatch: Int?
        var year = 0
        switch length {
        case 15:
            //获取年份对应的数字
            let valueNSStr = value as NSString
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 2)) as NSString
            year = yearStr.integerValue + 1900
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            } else {
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            }
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            if numberofMatch! > 0 {
                return true
            } else {
                return false
            }
        case 18:
            let valueNSStr = value as NSString
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 4)) as NSString
            year = yearStr.integerValue
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
                
            } else {
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
                
            }
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            
            if numberofMatch! > 0 {
                let a = getStringByRangeIntValue(Str: valueNSStr, location: 0, length: 1) * 7
                let b = getStringByRangeIntValue(Str: valueNSStr, location: 10, length: 1) * 7
                let c = getStringByRangeIntValue(Str: valueNSStr, location: 1, length: 1) * 9
                let d = getStringByRangeIntValue(Str: valueNSStr, location: 11, length: 1) * 9
                let e = getStringByRangeIntValue(Str: valueNSStr, location: 2, length: 1) * 10
                let f = getStringByRangeIntValue(Str: valueNSStr, location: 12, length: 1) * 10
                let g = getStringByRangeIntValue(Str: valueNSStr, location: 3, length: 1) * 5
                let h = getStringByRangeIntValue(Str: valueNSStr, location: 13, length: 1) * 5
                let i = getStringByRangeIntValue(Str: valueNSStr, location: 4, length: 1) * 8
                let j = getStringByRangeIntValue(Str: valueNSStr, location: 14, length: 1) * 8
                let k = getStringByRangeIntValue(Str: valueNSStr, location: 5, length: 1) * 4
                let l = getStringByRangeIntValue(Str: valueNSStr, location: 15, length: 1) * 4
                let m = getStringByRangeIntValue(Str: valueNSStr, location: 6, length: 1) * 2
                let n = getStringByRangeIntValue(Str: valueNSStr, location: 16, length: 1) * 2
                let o = getStringByRangeIntValue(Str: valueNSStr, location: 7, length: 1) * 1
                let p = getStringByRangeIntValue(Str: valueNSStr, location: 8, length: 1) * 6
                let q = getStringByRangeIntValue(Str: valueNSStr, location: 9, length: 1) * 3
                let S = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q
                
                let Y = S % 11
                
                var M = "F"
                
                let JYM = "10X98765432"
                
                M = (JYM as NSString).substring(with: NSRange.init(location: Y, length: 1))
                
                let lastStr = valueNSStr.substring(with: NSRange.init(location: 17, length: 1))
                
                if lastStr == "x" {
                    if M == "X" {
                        return true
                    } else {
                        return false
                    }
                } else {
                    if M == lastStr {
                        return true
                    } else {
                        return false
                    }
                }
                
            } else {
                return false
            }
        default:
            return false
        }
    }
    func getStringByRangeIntValue(Str: NSString, location: Int, length: Int) -> Int {
        
        let a = Str.substring(with: NSRange(location: location, length: length))
        
        let intValue = (a as NSString).integerValue
        
        return intValue
    }
}


@inline(__always) public func getImage(imageName: String) -> UIImage? {
    return UIImage.init(named: imageName)
}

@inline(__always) public func getKeyWindow() -> UIWindow? {
    return UIApplication.shared.keyWindow
}

@inline(__always) public func tabBarHeight() -> CGFloat {
    if #available(iOS 11.0, *) {
        return CGFloat(49.0 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0))
    }
    return 49.0
    
}

@inline(__always) public func navHeight() -> CGFloat {
    if #available(iOS 11.0, *) {
        var top = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        top = top > 0 ? top : 20
        return 44.0 + CGFloat(top)
    }
    return 64.0
    
}
@inline(__always) public func hasIphoneSafe() -> Bool {
    if #available(iOS 11.0, *) {
        return Int (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) > 0
    }
    return false
}

@inline(__always) public func RGBA(R: Double, G: Double, B: Double, A: Double) -> UIColor {
    return UIColor.init(red: CGFloat(Double((R) / 255.0)), green: CGFloat(Double(G/255.0)), blue: CGFloat(Double(B/255.0)), alpha: CGFloat(Double(A)))
}

@inline(__always) public func RGB(R: Double, G: Double, B: Double) -> UIColor {
    return RGBA(R: R, G: G, B: B, A: 1)
}
@inline(__always) public func COLOR_THEME () -> UIColor {
    return RGB(R: 45, G: 215, B: 135)
}

@inline(__always) public func COLOR_SEPARATOR () -> UIColor {
    return RGB(R: 238, G: 238, B: 238)
}

@inline(__always) public func APPVersion() -> String {
    return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
}

fileprivate var textInsetsKey = 1101
public extension JJMultiTextField {
    var textInsets: UIEdgeInsets? {
        set {
            objc_setAssociatedObject(self, &textInsetsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &textInsetsKey) as? UIEdgeInsets
        }
    }
    
    
//       public  var textInsets: UIEdgeInsets? {
//            set {
//                objc_setAssociatedObject(self, &textInsetsKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
//            }
//            get {
//                    return objc_getAssociatedObject(self, &textInsetsKey) as? UIEdgeInsets
//            }
//        }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if let inserts = self.textInsets {
            return super.textRect(forBounds: CGRect(x: bounds.origin.x + inserts.left, y: bounds.origin.y + inserts.top, width: bounds.width - inserts.left - inserts.right, height: bounds.height - inserts.top - inserts.bottom))
        } else {
           return super.textRect(forBounds: bounds)
        }
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
                if let inserts = self.textInsets {
            return super.placeholderRect(forBounds: CGRect(x: bounds.origin.x + inserts.left, y: bounds.origin.y + inserts.top, width: bounds.width - inserts.left - inserts.right, height: bounds.height - inserts.top - inserts.bottom))
        } else {
           return super.placeholderRect(forBounds: bounds)
        }
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if let inserts = self.textInsets {
            return super.editingRect(forBounds: CGRect(x: bounds.origin.x + inserts.left, y: bounds.origin.y + inserts.top, width: bounds.width - inserts.left - inserts.right, height: bounds.height - inserts.top - inserts.bottom))
        } else {
           return super.editingRect(forBounds: bounds)
        }
    }
}

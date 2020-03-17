//
//  JSONDecoderExtension.swift
//  CommonPods
//
//  Created by Jekin on 3/16/20.
//

import Foundation

//extension JSONDecoder {
//    public static func decode<T>(_ type: T.Type!, _ json: Any!) -> T? where T: Codable {
//          let jsonDecoder = JSONDecoder()
//          guard let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])else {return nil}
//          var model: T?
//          do {
//              model = try jsonDecoder.decode(type, from: jsonData)
//          } catch let e {
//              #if DEBUG
//              UIApplication.shared.keyWindow?.makeToast("数据格式出错\(e)")
//              #else
//              #endif
//              DLog("数据格式出错\(e)")
//              return nil
//          }
//          return model
//      }
//}
//
//extension JSONEncoder {
//    
//    //二进制转字典
//    public static func dataToDictionary(data:Data) ->[String:Any]? {
//        do {
//            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//            guard let dic = json as? [String:Any] else {
//                return nil
//            }
//            return dic
//        } catch _ {
//            return nil
//        }
//    }
//    //转字符串
//    public static func encoder<T>(toString model: T) -> String? where T: Codable {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        guard let data = try? encoder.encode(model) else {
//            return nil
//        }
//        guard let jsonStr = String(data: data, encoding: .utf8) else {
//            return nil
//        }
//        return jsonStr
//    }
//    //转字典
//    public static func encoder<T>(toDictionary model: T) -> [String: Any]? where T: Codable {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        guard let data = try? encoder.encode(model) else {
//            return nil
//        }
//        guard let dic = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] else {
//            return nil
//        }
//        return dic
//    }
//    
//    
//}

extension KeyedDecodingContainer {
    public func decodeIfPresent(_ type: String.Type, forKey key: K) throws -> String? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(Int.self, forKey: key) {
            return String(value)
        }
        if let value = try? decode(Float.self, forKey: key) {
            return String(value)
        }
        return nil
    }
    
    public func decodeIfPresent(_ type: Int.Type, forKey key: K) throws -> Int? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Int(value)
        }
        return nil
    }
    
    public func decodeIfPresent(_ type: Float.Type, forKey key: K) throws -> Float? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Float(value)
        }
        return nil
    }
    
    public func decodeIfPresent(_ type: Bool.Type, forKey key: K) throws -> Bool? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            if let valueInt = Int(value) {
                return Bool(valueInt != 0)
            }
            return nil
        }
        if let value = try? decode(Int.self, forKey: key) {
            return Bool(value != 0)
        }
        return nil
    }
    
    public func decodeIfPresent(_ type: Double.Type, forKey key: K) throws -> Double? {
        if let value = try? decode(type, forKey: key) {
            return value
        }
        if let value = try? decode(String.self, forKey: key) {
            return Double(value)
        }
        return nil
    }
    
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: K) throws -> T? where T : Decodable {
        return try? decode(type, forKey: key)
    }
}

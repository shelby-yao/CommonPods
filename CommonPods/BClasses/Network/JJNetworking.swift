//
//  TMNetworking.swift
//  BusinessPods
//
//  Created by Shelby on 2019/11/27.
//

import JKNetwork
import RxSwift

public enum JJError: Error {
    case tips(String)
    case noMore(String)
}
public enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}


open class TMNetworking: JKNetworkingDataTask {
    public enum TokenType: Int {
        case none = 0
        case token = 1
        case token2 = 2
        case token3 = 3
        case token4 = 4
        case token5 = 5
    }
    open var tokenType: TMNetworking.TokenType = .none
    required public override init() {
        super.init()
        self.sessionManager.responseSerializer = JJJSONResponseSerializer.create()
        self.sessionManager.responseSerializer.acceptableContentTypes = NSSet(array: ["application/json", "text/json", "text/javascript", "text/html", "text/xml", "text/plain"]) as? Set<String>
        self.timeoutInterval = 60.0
        self.sessionManager.requestSerializer.cachePolicy = .reloadIgnoringLocalCacheData
        let uri: Set<String> = ["GET", "HEAD"]; self.sessionManager.requestSerializer.httpMethodsEncodingParametersInURI = uri
        self.sessionManager.requestSerializer.setValue(nil, forHTTPHeaderField: "Authorization")
        self.tokenType = .none
    }
    
    public override init!(method: String!, url: String!, parameters: Any!, completionHandler: JKNetworkCompletionHandler!) {
        super.init(method: method, url: url, parameters: parameters) { (error: Error?, response: Any?) in
            guard let r = response as? Dictionary<String, Any> else {
                completionHandler(error, response)
                return
            }
            guard let code = r["code"] as? Int else {
                completionHandler(error, response)
                return
            }
            completionHandler(error, response)
        }
    }
    class func gap() {
        DLogN("\n")
    }
    
    public class func GET<R>(withUrl: String!, parameters: Any?, completionHandler: @escaping (_ result: Result<R, JJError>) -> Void) -> Self? where R: Codable {
        let network = self.get(withUrl: withUrl, parameters: parameters) { (error: Error?, resoponse: Any?) in
            if error != nil {
                DLog("GET错误 = \(error) \n url = \(withUrl) \n parameters = \(parameters)")
                self.gap()
                if let e = error as NSError? {
                    if let body = e.userInfo["body"] as? String, let code = e.userInfo["statusCode"] as? Int {
                        if code < 300 && code >= 200 {
                            self.gap()
                            guard let result = JJDecoder.decode(R.self, body, url: withUrl) else {
                                completionHandler(.failure(JJError.tips("服务器错误")))
                                return
                            }
                            DLog("GET String返回返回 = \(result)")
                            completionHandler(.success(result))
                        } else {
                            completionHandler(.failure(JJError.tips(body)))
                        }
                    } else {
                        if e.domain.contains("NSURL") {
                            completionHandler(.failure(JJError.tips("网络错误")))
                        } else {
                            completionHandler(.failure(JJError.tips(e.domain)))
                        }
                    }
                } else {
                    completionHandler(.failure(JJError.tips("网络错误")))
                }
            } else if resoponse == nil {
                completionHandler(.failure(JJError.tips("服务器错误")))
            } else {
                DLog("GET返回 = \(resoponse) \n url = \(withUrl) \n parameters = \(parameters)")
                self.gap()
                guard let result = JJDecoder.decode(R.self, resoponse, url: withUrl) else {
                    completionHandler(.failure(JJError.tips("服务器错误")))
                    return
                }
                completionHandler(.success(result))
            }
        }
        return network
    }
    
    public class func POST<R>(withUrl: String!, parameters: Any?, completionHandler: @escaping (_ result: Result<R, JJError>) -> Void) -> Self? where R: Codable {
        let network = self.post(withUrl: withUrl, parameters: parameters) { (error: Error?, resoponse: Any?) in
            if error != nil {
                DLog("POST错误 = \(error) \n url = \(withUrl) \n parameters = \(parameters)")
                self.gap()
                if let e = error as NSError? {
                    if let body = e.userInfo["body"] as? String, let code = e.userInfo["statusCode"] as? Int {
                        if code < 300 && code >= 200 {
                            self.gap()
                            guard let result = JJDecoder.decode(R.self, body, url: withUrl) else {
                                completionHandler(.failure(JJError.tips("服务器错误")))
                                return
                            }
                            DLog("POST String返回 = \(result)")
                            completionHandler(.success(result))
                        } else {
                            completionHandler(.failure(JJError.tips(body)))
                        }
                    } else {
                        if e.domain.contains("NSURL") {
                            completionHandler(.failure(JJError.tips("网络错误")))
                        } else {
                            completionHandler(.failure(JJError.tips(e.domain)))
                        }
                    }
                } else {
                    completionHandler(.failure(JJError.tips("网络错误")))
                }
            } else if resoponse == nil {
                completionHandler(.failure(JJError.tips("服务器错误")))
            } else {
                DLog("POST返回 = \(resoponse) \n url = \(withUrl) \n parameters = \(parameters)")
                self.gap()
                guard let result = JJDecoder.decode(R.self, resoponse, url: withUrl) else {
                    completionHandler(.failure(JJError.tips("服务器错误")))
                    return
                }
                completionHandler(.success(result))
            }
        }
        return network
    }
    
    public class func DELETE<R>(withUrl: String!, parameters: Any?, completionHandler:@escaping (_ result: Result<R, JJError>) -> Void) -> Self? where R: Codable {
        let network = self.delete(withUrl: withUrl, parameters: parameters) { (error: Error?, response: Any?) in
            if error != nil {
                DLog("DELETE错误 = \(error) \n url = \(withUrl) \n parameters = \(parameters)")
                self.gap()
                if let e = error as NSError? {
                    if let body = e.userInfo["body"] as? String, let code = e.userInfo["statusCode"] as? Int {
                        if code < 300 && code >= 200 {
                            self.gap()
                            guard let result = JJDecoder.decode(R.self, body, url: withUrl) else {
                                completionHandler(.failure(JJError.tips("服务器错误")))
                                return
                            }
                            DLog("DELETE String返回返回 = \(result)")
                            completionHandler(.success(result))
                        } else {
                            completionHandler(.failure(JJError.tips(body)))
                        }
                    } else {
                        if e.domain.contains("NSURL") {
                            completionHandler(.failure(JJError.tips("网络错误")))
                        } else {
                            completionHandler(.failure(JJError.tips(e.domain)))
                        }
                    }
                } else {
                    completionHandler(.failure(JJError.tips("网络错误")))
                }
            } else if response == nil {
                completionHandler(.failure(JJError.tips("服务器错误")))
            } else {
                DLog("DELETE返回 = \(response) \n url = \(withUrl) \n parameters = \(parameters)")
                self.gap()
                guard let result = JJDecoder.decode(R.self, response, url: withUrl) else {
                    completionHandler(.failure(JJError.tips("服务器错误")))
                    return
                }
                completionHandler(.success(result))
            }
            
        }
        return network
    }
    
    
    public class func PUT<R>(withUrl: String!, parameters: Any?, completionHandler:@escaping (_ result: Result<R, JJError>) -> Void) -> Self? where R: Codable {
        let network = self.put(withUrl: withUrl, parameters: parameters) { (error: Error?, resoponse: Any?) in
            if error != nil {
                DLog("PUT错误 = \(error) \n url = \(withUrl) \n parameters = \(parameters)")
                self.gap()
                if let e = error as NSError? {
                    if let body = e.userInfo["body"] as? String, let code = e.userInfo["statusCode"] as? Int {
                        if code < 300 && code >= 200 {
                            self.gap()
                            guard let result = JJDecoder.decode(R.self, body, url: withUrl) else {
                                completionHandler(.failure(JJError.tips("服务器错误")))
                                return
                            }
                            DLog("PUT String返回返回 = \(result)")
                            completionHandler(.success(result))
                        } else {
                            completionHandler(.failure(JJError.tips(body)))
                        }
                    } else {
                        if e.domain.contains("NSURL") {
                            completionHandler(.failure(JJError.tips("网络错误")))
                        } else {
                            completionHandler(.failure(JJError.tips(e.domain)))
                        }
                    }
                } else {
                    completionHandler(.failure(JJError.tips("网络错误")))
                }
            } else if resoponse == nil {
                completionHandler(.failure(JJError.tips("服务器错误")))
            } else {
                DLog("PUT返回 = \(resoponse) \n url = \(withUrl) \n parameters = \(parameters)")
                self.gap()
                guard let result = JJDecoder.decode(R.self, resoponse, url: withUrl) else {
                    completionHandler(.failure(JJError.tips("服务器错误")))
                    return
                }
                completionHandler(.success(result))
            }
        }
        return network
    }
    
        public class func UPLOAD<R>(withUrl: String!, extention: String, path: String, fileData: Data, fileName: String, tokenType: TokenType = .none, contentType: String = "multipart/form-data", completionHandler:@escaping (_ result: Result<R, JJError>) -> Void) where R: Codable {
            let networking = self.init()
            //        networking.hasToken = true
            networking.tokenType = tokenType
            let session = TMNetworking.init().sessionManager
            //        session?.requestSerializer.setValue("ios", forHTTPHeaderField: "X-Platform")
            //        "multipart/form-data"
            session?.requestSerializer.setValue(contentType, forHTTPHeaderField: "Content-Type")
            let dic = ["attr": "online_inquery",
                       "file": fileName
            ]
            session?.post(withUrl, parameters: dic, constructingBodyWith: { ( form: AFMultipartFormData? ) in
                let mimeType = "image/\(extention)"
                form?.appendPart(withFileData: fileData, name: "file", fileName: fileName, mimeType: mimeType)
    
            }, success: { (task:URLSessionDataTask?, re: Any?) in
                guard let result = JJDecoder.decode(R.self, re) else {
                    completionHandler(.failure(JJError.tips("服务器错误")))
                    return
                }
                completionHandler(.success(result))
            }, failure: { (_: URLSessionDataTask?, error: Error?) in
                if let e = error as NSError? {
                    completionHandler(.failure(JJError.tips(e.domain)))
                }
            })
        }
        
        public class func UPLOADFILE<R>(withUrl: String!, fileData: Data, fileName: String, tokenType: TokenType = .none, contentType: String = "multipart/form-data", progressHandler: @escaping ((_ progress: Progress) -> Void), completionHandler:@escaping (_ result: Result<R, JJError>) -> Void) where R: Codable {
            let networking = self.init()
            networking.tokenType = tokenType
            let session = TMNetworking.init().sessionManager
            //        session?.requestSerializer.setValue(value, forHTTPHeaderField: "Authorization")
            //        session?.requestSerializer.setValue("ios", forHTTPHeaderField: "X-Platform")
            //        "multipart/form-data"
            session?.requestSerializer.setValue(contentType, forHTTPHeaderField: "Content-Type")
            let dic = [
                "classify": "content",
                "coding": "raw",
                "form_file": fileData
                ] as [String: Any]
    
            let req =  session?.post(withUrl, parameters: dic, constructingBodyWith: { ( form :AFMultipartFormData? ) in
                let mimeType = "file"
                form?.appendPart(withFileData: fileData, name: "form_file", fileName: fileName, mimeType: mimeType)
    
            }, progress: { (progress: Progress) in
                progressHandler(progress)
            }, success: { (task:URLSessionDataTask?, re: Any?) in
                guard let result = JJDecoder.decode(R.self, re) else {
                    completionHandler(.failure(JJError.tips("服务器错误")))
                    return
                }
                completionHandler(.success(result))
            }, failure: { (_: URLSessionDataTask?, error: Error?) in
                if let e = error as NSError? {
                    completionHandler(.failure(JJError.tips(e.domain)))
                }
            })
        }

}



open class TMNetworkingUploadTask: TMNetworking {
        var paramName: String?
    var sessionUploadTask: URLSessionUploadTask?
    var progress: Progress?
    var progressHandler: ((_ progress: Progress) -> Void)?

    
    public class func upload(url: String, filePathUrl: String, paramName: String, parameters: [String: String]?, contentType: String = "image/png", formDic: [String: String]?, progressHandler: @escaping ((_ progress: Progress) -> Void), completionHandler: @escaping JKNetworkCompletionHandler) -> Self {
        let task = self.init()
        var fileData = Data()
        guard let fileURL = URL(string: filePathUrl) else { return task }
        do {
            fileData = try Data(contentsOf: fileURL)
        } catch let e {
            UIApplication.shared.keyWindow?.makeToast("文件路径错误")
            return self.init()
        }
        return self.upload(url: url, fileData: fileData, file_extension: filePathUrl.components(separatedBy: ".").last ?? "", paramName: paramName, parameters: parameters, contentType: contentType, formDic: formDic, progressHandler: progressHandler, completionHandler: completionHandler)
    }
    
    public class func upload(url: String, fileData: Data, file_extension: String, paramName: String, parameters: [String: String]?, contentType: String = "image/png", formDic: [String: String]?, progressHandler: @escaping ((_ progress: Progress) -> Void ), completionHandler: @escaping JKNetworkCompletionHandler) -> Self {
        let task = self.init()
        task.timeoutInterval = 2 * 3600
        task.paramName = paramName
        task.completionHandler = completionHandler
        task.sessionManager.requestSerializer.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        let req = task.sessionManager.requestSerializer.multipartFormRequest(withMethod: "POST", urlString: url, parameters: parameters, constructingBodyWith: { (formData: AFMultipartFormData) in
            let d = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss:SSS"
            formatter.locale = Locale.current
            let string = formatter.string(from: d)
            let name =  string + "." + file_extension
            formData.appendPart(withFileData: fileData, name: "file", fileName: name, mimeType: contentType)
            //            formData.appendPart
            for (key, value) in formDic ?? [:] {
                let data = value.data(using: .utf8) ?? Data()
                formData.appendPart(withForm: data, name: key)
            }
        }, error: nil)
        req.httpMethod = "POST"
        task.setValue(req.copy(), forKey: "request")
        task.progressHandler = progressHandler
        return task
    }
    
    public override func resume() {
        super.resume()
        self.sessionUploadTask = self.sessionManager.uploadTask(withStreamedRequest: self.request, progress: nil, completionHandler: { [weak self](response: URLResponse, responseObject: Any?, error: Error?) in
            if response.isKind(of: HTTPURLResponse.self) {
                self?.setValue(response, forKey: "httpURLResponse")
                self?.completionHandler?(error, responseObject)
            }
        })
        self.sessionManager.setTaskDidSendBodyDataBlock { [weak self] (_: URLSession, _: URLSessionTask, _: Int64, _: Int64, _: Int64) in
            self?.progressHandler?(self!.progress!)
        }
        self.progress = self.sessionManager.uploadProgress(for: self.sessionUploadTask!)
        self.sessionUploadTask?.resume()
    }
    
    public override func cancel() {
        super.cancel()
        self.sessionUploadTask?.cancel()
    }
    
    class func UPLOADFILE<R>(withUrl: String!, filePathUrl: String, paramName: String, tokenType: TokenType, parameters: [String: String]?, formDic: [String: String]?, progressHandler: @escaping ((_ progress: Progress) -> Void), completionHandler:@escaping (_ result: Result<R, JJError>) -> Void) -> Self? where R: Codable {
            let network = self.upload(url: withUrl, filePathUrl: filePathUrl, paramName: paramName, parameters: parameters, formDic: formDic, progressHandler: progressHandler) { (error: Error?, resoponse: Any?) in
                if error != nil {
                    completionHandler(.failure(JJError.tips("网络错误")))
                } else if resoponse == nil {
                    completionHandler(.failure(JJError.tips("服务器错误")))
                } else {
                    guard let result = JJDecoder.decode(R.self, resoponse, url: withUrl) else {
                        completionHandler(.failure(JJError.tips("服务器错误")))
                        return
                    }
                    completionHandler(.success(result))
                }
            }
            network.tokenType = tokenType
            return network
        }
    class func UPLOADFILE<R>(withUrl: String!, fileData: Data, file_extension: String, paramName: String, tokenType: TokenType, parameters: [String: String]?, formDic: [String: String]?, progressHandler: @escaping ((_ progress: Progress) -> Void), completionHandler:@escaping (_ result: Result<R, JJError>) -> Void) -> Self? where R: Codable {
            let network = self.upload(url: withUrl, fileData: fileData, file_extension: file_extension, paramName: paramName, parameters: parameters, formDic: formDic, progressHandler: progressHandler) { (error: Error?, resoponse: Any?) in
                if error != nil {
                    completionHandler(.failure(JJError.tips("网络错误")))
                } else if resoponse == nil {
                    completionHandler(.failure(JJError.tips("服务器错误")))
                } else {
                    guard let result = JJDecoder.decode(R.self, resoponse, url: withUrl) else {
                        completionHandler(.failure(JJError.tips("服务器错误")))
                        return
                    }
                    completionHandler(.success(result))
                }
            }
            network.tokenType = tokenType
            return network
        }
}

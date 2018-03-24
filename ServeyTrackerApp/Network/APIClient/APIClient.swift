//
//  APIClient.swift
//  UCash
//
//  Created by Sagar.Gupta on 05/06/17.
//  Copyright © 2017 Sagar.Gupta. All rights reserved.
//

import UIKit

typealias JSONDictionary = [String: Any]

typealias JSONParams = [String: AnyHashable]

typealias CompletionBlock = (Any?, URLResponse?, Error?) -> Void

fileprivate final class ReachabilityWrapper: NSObject {
    
    /// Shared reachability instance across the app.
    static let sharedReach = Reachability()
    private override init() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

fileprivate enum HttpMethods: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
}



class APIClient: NSObject {
    
    /// Comletion block to execute on completion of api call.
    private var completionHandler: CompletionBlock?
    
    
    /// File upload request
    ///
    /// - Parameters:
    ///   - params: Parameters to send along with the file data.
    ///   - _urlString: URL for service.
    ///   - _filePath: Full path of the file to upload
    ///   - requestCompletion: Code block to execure when request finishes.
    func uploadRequest(with params: JSONParams, url _urlString: String, imageData: NSData?, completion requestCompletion: CompletionBlock?) {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Check your internet connection"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        guard let _url = URL.init(string: _urlString) else {
            return
        }
        
        var bodyData = Data()
        
        var request = URLRequest(url: _url)
        request.httpMethod = HttpMethods.post.rawValue
        
        let boundary = "----WebKitFormBoundary7MA4YWxkTrZu0gW"
        let headerBoundary = "multipart/form-data; boundary=" + boundary
        request.addValue(headerBoundary, forHTTPHeaderField: "Content-Type")
        //request.addValue("authorization", forHTTPHeaderField:"jgzc2miIEwqqAPtqJBCwqYpDD")
        request.setValue("jgzc2miIEwqqAPtqJBCwqYpDD", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        completionHandler = requestCompletion
        
        // Message part
        for (key, value) in params {
            let strValue = String(describing: value)
            let bound = "--\(boundary)\r\n"
            bodyData.append(bound.data(using: String.Encoding.utf8)!)
            
            let fieldName = "Content-Disposition: form-data; name=" + key + "\r\n\r\n"
            bodyData.append(fieldName.data(using: String.Encoding.utf8)!)
            
            bodyData.append(strValue.data(using: String.Encoding.utf8)!)
            bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        
        if let imgData = imageData {
            // media part
            let bounString = "--\(boundary)\r\n"
            bodyData.append("--\r\n".data(using: String.Encoding.utf8)!)
            bodyData.append(bounString.data(using: String.Encoding.utf8)!)
            
            //let ext = _fPath.components(separatedBy: ".").last
            let fileName = UUID.init().uuidString + ".jpg"
            
            bodyData.append("Content-Disposition: form-data; name=profileImage; filename=\(fileName)\r\n".data(using: String.Encoding.utf8)!)
            bodyData.append("Content-Type: image/*\r\n".data(using: String.Encoding.utf8)!)
           bodyData.append("Content-Transfer-Encoding: binary\r\n\r\n".data(using: String.Encoding.utf8)!)
            let newStr = String(data: bodyData, encoding: .utf8)
            print(newStr ?? "nil")
            
            bodyData.append(imgData as Data)
            bodyData.append("\r\n".data(using: String.Encoding.utf8)!)
            bodyData.append(bounString.data(using: String.Encoding.utf8)!)
        }
        
        let randomFilePath = UUID.init().uuidString
        let profileDataPath = filePathInDocDirectory(fileName: randomFilePath)
        let profileDataURL = URL.init(fileURLWithPath: profileDataPath)
        try? bodyData.write(to: profileDataURL)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let uploadTask = session.uploadTask(with: request, fromFile: profileDataURL, completionHandler: { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            try? FileManager.default.removeItem(atPath: profileDataPath)
            
            if let completion = self.completionHandler, let d = responseData {
                
                do {
                    
                    let newStr = String(data: d, encoding: .utf8)
                    print(newStr ?? "nil")
                    let jsonObj = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    OperationQueue.main.addOperation {
                        print(jsonObj)
                        completion(jsonObj, responseObj, error)
                    }
                } catch {
                    OperationQueue.main.addOperation {
                        completion(["status": false, "message": error.localizedDescription], responseObj, error)
                    }
                }
            }
        })
        uploadTask.resume()
    }
    
    
    /// POST request
    ///
    /// - Parameters:
    ///   - postParams: parameters to send
    ///   - urlString: Full URL of the service
    ///   - requestCompletion: Code block to execure when request finishes
    func postRequest(withParams postParams: JSONDictionary, url urlString: String, completion requestCompletion: CompletionBlock?) {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Check your internet connection"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        let url = URL(string: urlString)!
        let config = URLSessionConfiguration.default
        completionHandler = requestCompletion
        
        let session = URLSession(configuration: config)
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.post.rawValue
        
        request.addValue("authorization", forHTTPHeaderField:"jgzc2miIEwqqAPtqJBCwqYpDD")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postParams)
            let str = String.init(data: jsonData, encoding: String.Encoding.utf8)
            
            debugPrint(url)
            
            debugPrint(str ?? "")
            request.httpBody = jsonData
            let uploadTask = session.uploadTask(with: request, from: jsonData) { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
                if let completion = self.completionHandler {
                    if let d = responseData {
                        
                        do {
                            let jsonObj = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            OperationQueue.main.addOperation {
                                print(jsonObj)
                                completion(jsonObj, responseObj, error)
                            }
                        } catch {
                            OperationQueue.main.addOperation {
                                completion(nil, nil, error)
                            }
                        }
                    } else {
                        OperationQueue.main.addOperation {
                            let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                            if let completion = requestCompletion {
                                print(errorObj)
                                completion(errorObj, responseObj, error)
                            }
                        }
                    }
                }
            }
            uploadTask.resume()
        } catch {
            fatalError("Request could not be serialized")
        }
    }
    
    /// PUT request
    ///
    /// - Parameters:
    ///   - putParams: parameters to send
    ///   - urlString: Full URL of the service
    ///   - requestCompletion: Code block to execure when request finishes
    func putRequest(withParams postParams: JSONDictionary, url urlString: String, completion requestCompletion: CompletionBlock?) {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Check your internet connection"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = URL(string: urlString)!
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        completionHandler = requestCompletion
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.put.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: postParams)
            
            let str = String.init(data: jsonData, encoding: String.Encoding.utf8)
            
            debugPrint(str ?? "")
            
            let uploadTask = session.uploadTask(with: request, from: jsonData) { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                if let completion = self.completionHandler {
                    if let d = responseData {
                        
                        do {
                            let jsonObj = try JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments)
                            
                            OperationQueue.main.addOperation {
                                print(jsonObj)
                                completion(jsonObj, responseObj, error)
                            }
                        } catch {
                            OperationQueue.main.addOperation {
                                completion(nil, nil, error)
                            }
                        }
                    } else {
                        OperationQueue.main.addOperation {
                            let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                            if let completion = requestCompletion {
                                completion(errorObj, responseObj, error)
                            }
                        }
                    }
                }
            }
            uploadTask.resume()
        } catch {
            fatalError("Request could not be serialized")
        }
    }
    
    /// Delete request
    ///
    /// - Parameters:
    ///   - deleteParams: parameters to send
    ///   - urlString: Full URL of the service
    ///   - requestCompletion: Code block to execure when request finishes
    func deleteRequest(withURL urlString: String, completion requestCompletion: CompletionBlock?) {
        guard let percentEnoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        guard let url = URL.init(string: percentEnoded) else { return }
        
        debugPrint(url)
        
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Check your internet connection"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        completionHandler = requestCompletion
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.delete.rawValue
        
        let downloadTask = session.dataTask(with: request) { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let completion = self.completionHandler {
                if let d = responseData {
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) {
                        OperationQueue.main.addOperation {
                            print(jsonObj)
                            completion(jsonObj, responseObj, error)
                        }
                    } else {
                        OperationQueue.main.addOperation {
                            let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                            if let completion = requestCompletion {
                                completion(errorObj, responseObj, error)
                            }
                        }
                    }
                } else {
                    OperationQueue.main.addOperation {
                        let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                        if let completion = requestCompletion {
                            completion(errorObj, responseObj, error)
                        }
                    }
                }
            }
        }
        downloadTask.resume()
    }
    
    /// GET request
    ///
    /// - Parameters:
    ///   - urlString: Full URL of the service
    ///   - requestCompletion: Code block to execure when request finishes
    func getRequest(withURL urlString: String, completion requestCompletion: CompletionBlock?) {
        guard let percentEnoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else { return }
        guard let url = URL.init(string: percentEnoded) else { return }
        
        debugPrint(url)
        
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Check your internet connection"]
            if let completion = requestCompletion {
                completion(errorObj, nil, nil)
                return
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        completionHandler = requestCompletion
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethods.get.rawValue
        
        let downloadTask = session.dataTask(with: request) { (responseData: Data?, responseObj: URLResponse?, error: Error?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let completion = self.completionHandler {
                if let d = responseData {
                    
                    if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments) {
                        OperationQueue.main.addOperation {
                            print(jsonObj)
                            completion(jsonObj, responseObj, error)
                        }
                    } else {
                        OperationQueue.main.addOperation {
                            let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                            if let completion = requestCompletion {
                                completion(errorObj, responseObj, error)
                            }
                        }
                    }
                } else {
                    OperationQueue.main.addOperation {
                        let errorObj: JSONDictionary = ["status": false, "message": error?.localizedDescription ?? "Something went worong, please try later"]
                        if let completion = requestCompletion {
                            completion(errorObj, responseObj, error)
                        }
                    }
                }
            }
        }
        downloadTask.resume()
    }
    
}


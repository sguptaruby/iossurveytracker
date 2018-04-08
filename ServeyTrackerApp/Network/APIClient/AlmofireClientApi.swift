//
//  AlmofireClientApi.swift
//  ServeyTrackerApp
//
//  Created by Apple on 28/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire


typealias SuccessBlock = (Any?,Error?) -> Void
typealias ErrorBlock = (Error?) -> Void

fileprivate final class ReachabilityWrapper: NSObject {
    
    /// Shared reachability instance across the app.
    static let sharedReach = Reachability()
    private override init() {}
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class AlmofireClientApi: NSObject {
    
    private var completionHandler: CompletionBlock?
    
    
    func multipleImageUploading(imagesData:[Data],imagesName:[String],url _urlString: String, completion requestCompletion: SuccessBlock?) {
        let reachabilityStatus = ReachabilityWrapper.sharedReach!.currentReachabilityStatus
        if reachabilityStatus == Reachability.NetworkStatus.notReachable {
            let errorObj: JSONDictionary = ["status": false, "message": "Check your internet connection"]
            if let completion = requestCompletion {
                completion(errorObj, nil)
                return
            }
        }
        
        guard let _url = URL.init(string: _urlString) else {
            return
        }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            var i = 0
            
            while(i < imagesName.count) {
                multipartFormData.append(imagesData[i], withName: "image[]", fileName: "\(imagesName[i])", mimeType: "image/jpg")
                i = i + 1
            }
//            for imageData in imagesData  {
//                multipartFormData.append(imageData, withName: "image[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
//            }
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
        }, to: _url,
           
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    requestCompletion!(response,nil)
                }
            case .failure(let error):
                print(error)
                requestCompletion!(nil,error)
            }
            
        })
    }

}

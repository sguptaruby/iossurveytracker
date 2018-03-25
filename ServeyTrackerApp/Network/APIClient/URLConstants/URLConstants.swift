//
//  URLConstants.swift
//  app
//
//  UCash
//
//  Created by Sagar.Gupta on 05/06/17.
//  Copyright © 2017 Sagar.Gupta. All rights reserved.
//

import UIKit

internal final class URLConstants: NSObject {
    // Do not allow instantiation of the class
    private override init() {}
    
    /// Base URL
    private class var baseURL: String {
        
        return "http://surveywebapi.tobaccounmasked.com/api"
    }
    
    /// User login
    class var login: String {
        return baseURL + "/user/login"
    }
    
    /// User signup
    class var signup: String {
        return baseURL + "/user/signup"
    }
    
    /// User SendVerificationCode
    class var sendVerificationCode: String {
        return baseURL + "/user/SendVerificationCode"
    }
    
    /// User GetMpTags
    class var getMpTags: String {
        return baseURL + "/activities/GetMpTags"
    }

}

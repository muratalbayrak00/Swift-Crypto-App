//
//  Router.swift
//
//
//  Created by murat albayrak on 9.05.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    case listCoins
    
    var method: HTTPMethod {
        switch self {
        case .listCoins:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .listCoins:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var url: URL {
        
//        switch self {
//        case .listCoins:
            let url = URL(string: "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins")
            return url!
//        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return try encoding.encode(urlRequest, with: parameters)
    }
    
}

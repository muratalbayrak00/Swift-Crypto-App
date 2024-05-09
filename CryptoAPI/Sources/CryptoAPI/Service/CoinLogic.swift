//
//  CoinLogic.swift
//
//
//  Created by murat albayrak on 9.05.2024.
//

import Foundation
import Alamofire

public class CoinLogic: CoinLogicProtocol {
    
    public static let shared: CoinLogic = {
        let instance = CoinLogic()
        return instance
    }()
    
    public func getCoins(completionHandler: @escaping (Result<Welcome, Error>) -> Void) {
        let url = "https://psp-merchantpanel-service-sandbox.ozanodeme.com.tr/api/v1/dummy/coins"
        CoinService.shared.fetchCoins(urlString: url, decodeToType: Welcome.self, completionHandler: completionHandler)
    }
    

    
}

protocol CoinLogicProtocol {
    
    func getCoins(completionHandler: @escaping (Result<Welcome, Error>) -> Void)
}

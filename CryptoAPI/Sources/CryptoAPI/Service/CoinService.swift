//
//  CoinService.swift
//
//
//  Created by murat albayrak on 8.05.2024.
//

import Foundation
import Alamofire

public class CoinService {
    
    public static let shared: CoinService = {
        let instance = CoinService()
        return instance
    }()
    
    func fetchCoins<T: Decodable>(urlString: String, decodeToType type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) {
            
        AF.request(urlString).responseData { [weak self] response in
            guard self != nil else { return }
               
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(decodedData))
                } catch {
                    print("Json decode error")
                   
                }
            case .failure(let error):
                completionHandler(.failure(error.localizedDescription as! Error))
            }
        }
    }
    
    
}

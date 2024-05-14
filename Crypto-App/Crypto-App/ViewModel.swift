//
//  ViewModel.swift
//  Crypto-App
//
//  Created by murat albayrak on 14.05.2024.
//

import Foundation
import CryptoAPI

// ViewModel da UIKit olmaz :)

extension ViewModel {
    
}

protocol ViewModelProtocol {
    var delegate: ViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    func load()
    func coin(index: Int) -> Coin?
    func formatCoinsPrice()
    func formatCoinsChange()
    func reloadPickerData()
    func formatChange(_ changeString: String) -> String?
    func date(from unixTimestamp: Double) -> Date
    func formatPrice(_ priceString: String) -> String?

}

protocol ViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
}

final class ViewModel {
    var allCoins = [Coin]()
    
    weak var delegate: ViewModelDelegate?
    var selectedFilterIndex = 0
    
    fileprivate func fetchCoins() {
        self.delegate?.showLoadingView()
        CoinLogic.shared.getCoins { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let welcome):
                self.delegate?.hideLoadingView()
                self.allCoins = welcome.data.coins
                formatCoinsPrice()
                formatCoinsChange()
                selectedFilterIndex = 0
                reloadPickerData()
                self.delegate?.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension ViewModel: ViewModelProtocol {

    
    var numberOfItems: Int {
        allCoins.count
    }
    
    func load() {
        fetchCoins()
    }
    
    func coin(index: Int) -> CryptoAPI.Coin? {
        allCoins[index]
    }
    
    func formatCoinsPrice() {
        for index in 0..<self.allCoins.count {
            let coin = self.allCoins[index]
            if let formattedPrice = formatPrice(coin.price) {
                self.allCoins[index].price = formattedPrice
            }
        }
    }
    
    func formatCoinsChange() {
        for index in 0..<self.allCoins.count {
            let coin = self.allCoins[index]
            self.allCoins[index].change = formatChange(coin.change) ?? ""
        }
    }
    

    
    func date(from unixTimestamp: Double) -> Date {
        return Date(timeIntervalSince1970: unixTimestamp)
    }
    
    func formatChange(_ changeString: String) -> String? {
        
        var formattedChange = changeString
        
        if !changeString.hasPrefix("-") {
            formattedChange = "+" + formattedChange
        }
        
        formattedChange += "%"
        
        return formattedChange
        
    }
    
    func formatPrice(_ priceString: String) -> String? {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        if let price = Double(priceString) {
            return formatter.string(from: NSNumber(value: price))
        } else {
            return nil
        }
        
    }
    
    func reloadPickerData() {
        switch selectedFilterIndex {
            
        case 0: // Price filtering
            self.allCoins.sort { coin1, coin2 in
                let price1String = coin1.price.dropFirst().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
                let price2String = coin2.price.dropFirst().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
                
                if let price1 = Int(price1String), let price2 = Int(price2String) {
                    return price1 > price2
                } else {
                    print("Error price filter")
                    return false
                }
            }
            
        case 1: // Market Cap
            allCoins.sort { coin1, coin2 in
                return Int(coin1.marketCap) ?? 0 > Int(coin2.marketCap) ?? 0
            }
        case 2: // 24h Volume]
            self.allCoins.sort { coin1, coin2 in
                return Int(coin1.the24HVolume) ?? 0 > Int(coin2.the24HVolume) ?? 0
            }
            
            self.delegate?.reloadData()
        case 3: // Change
            allCoins.sort { coin1, coin2 in
                let change1 = coin1.change.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "%", with: "")
                let change2 = coin2.change.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "%", with: "")
                
                if let changeValue1 = Double(change1), let changeValue2 = Double(change2) {
                    return changeValue1 > changeValue2
                } else {
                    return false
                }
            }
        case 4: // Listed At
            allCoins.sort { coin1, coin2 in
                let date1 = date(from: Double(coin1.listedAt))
                let date2 = date(from: Double(coin2.listedAt))
                return date2 > date1
            }
            
        default:
            break
        }
        
        DispatchQueue.main.async {
            self.delegate?.reloadData()
        }
    }
    
}

//
//  DetailsViewModel.swift
//  Crypto-App
//
//  Created by murat albayrak on 14.05.2024.
//

import Foundation
import CryptoAPI


extension DetailsViewModel {
    fileprivate enum Constants {
        static let tableViewHeight: Int = 75
    }
}

protocol DetailsViewModelProtocol {
    var delegate: DetailsViewModelDelegate? { get set }
    func formatLargeNumber(_ numberString: String) -> String
    func formatNumbers(_ priceString: String) -> String?
    func convertUnixTimestampToDate(unixTime: Int) -> String 
    func getSelectedCoin() -> Coin?
    func setSelectedCoin(_ coin: Coin?)
    func getFavoriteCoins() -> [Coin]
    func fetchCoinDetails()
    func setFavoriteCoins(_ coins: [CryptoAPI.Coin])
    func coin() -> CryptoAPI.Coin.Type

}

protocol DetailsViewModelDelegate: AnyObject {
    
}

final class DetailsViewModel {

    var selectedCoin: Coin?
    var favoriteCoins : [Coin] = []
    
    weak var delegate: DetailsViewModelDelegate?
    


}

extension DetailsViewModel: DetailsViewModelProtocol {

    
    func fetchCoinDetails() {
        if let data = UserDefaults.standard.data(forKey: "favoriteCoins"),
           let decodedGames = try? JSONDecoder().decode([Coin].self, from: data) {
            favoriteCoins = decodedGames
        }
    }
    
    func formatLargeNumber(_ numberString: String) -> String {
        guard let number = Double(numberString) else { return "" }
        let absNumber = abs(number)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        switch absNumber {
            
        case 1_000_000...999_999_999:
            let formattedNumber = absNumber / 1_000_000
            return formatter.string(from: NSNumber(value: formattedNumber))! + "M"
        case 1_000_000_000...999_999_999_999:
            let formattedNumber = absNumber / 1_000_000_000
            return formatter.string(from: NSNumber(value: formattedNumber))! + "Bn"
        case 1_000_000_000_000...999_999_999_999_999:
            let formattedNumber = absNumber / 1_000_000_000_000
            return formatter.string(from: NSNumber(value: formattedNumber))! + "Tn"
        default:
            return formatter.string(from: NSNumber(value: absNumber))!
        }
    }
    
    func formatNumbers(_ priceString: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        if priceString.starts(with: "0"){
            formatter.maximumFractionDigits = 6
        }
        formatter.currencySymbol = "$"
        
        if let price = Double(priceString) {
            return formatter.string(from: NSNumber(value: price))
        } else {
            return nil
        }
    }
    
    func convertUnixTimestampToDate(unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    

    
    func coin() -> CryptoAPI.Coin.Type {
        Coin.self
    }
    

    
    func getSelectedCoin() -> CryptoAPI.Coin? {
        self.selectedCoin
    }
    
    func getFavoriteCoins() -> [CryptoAPI.Coin] {
        favoriteCoins
    }
    
    func setFavoriteCoins(_ coins: [CryptoAPI.Coin]) {
        self.favoriteCoins = coins
    }
    
//    func setFavoriteCoins(_ coins: [CryptoAPI.Coin]) {
//        self.favoriteCoins = coin
//    }
    
    func setSelectedCoin(_ coin: CryptoAPI.Coin?) {
        self.selectedCoin = coin
    }
    

    
}



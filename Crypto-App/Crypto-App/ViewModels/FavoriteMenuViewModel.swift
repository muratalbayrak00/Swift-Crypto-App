//
//  FavoriteMenuViewModel.swift
//  Crypto-App
//
//  Created by murat albayrak on 14.05.2024.
//

import Foundation
import CryptoAPI


// ViewModel da UIKit olmaz :)

extension FavoriteMenuViewModel {
    fileprivate enum Constants {
        static let tableViewHeight: Int = 75
    }
}

protocol FavoriteMenuViewModelProtocol {
    var delegate: FavoriteMenuViewModelDelegate? { get set }
    var numberOfItems: Int { get }
    var tableViewHeight: Int { get }
    func load()
    func coin(index: Int) -> Coin?
    func getFavoriteCoins() -> [Coin]
    func setFavoriteCoins(_ coins: [Coin])
  //  func setSelectedCoin(_ coin: Coin?)
    func coinModel() -> [Coin].Type

}

protocol FavoriteMenuViewModelDelegate: AnyObject {
    func showLoadingView()
    func hideLoadingView()
    func reloadData()
}

final class FavoriteMenuViewModel {

    var favoriteCoins: [Coin] = []
    weak var delegate: FavoriteMenuViewModelDelegate?
    
    fileprivate func fetchFavoriteCoins() {
        self.delegate?.showLoadingView()
        if let favoriteCoinData = UserDefaults.standard.data(forKey: "favoriteCoins"),
           let decodedFavoriteCoins = try? JSONDecoder().decode([Coin].self, from: favoriteCoinData) {
            
            self.favoriteCoins = decodedFavoriteCoins
            self.delegate?.hideLoadingView()
            self.delegate?.reloadData()
            

        }
    }

}

extension FavoriteMenuViewModel: FavoriteMenuViewModelProtocol {
    

    
    var numberOfItems: Int {
        favoriteCoins.count
    }
    
    func load() {
        fetchFavoriteCoins()
    }
    
    func coin(index: Int) -> CryptoAPI.Coin? {
        favoriteCoins[index]
    }
    
    func getFavoriteCoins() -> [Coin] {
        favoriteCoins
    }
    
    func setFavoriteCoins(_ coin: [Coin]) {
        self.favoriteCoins = coin
    }
    
    
    func coinModel() -> [Coin].Type {
        return [Coin].self
    }
    
    var tableViewHeight: Int {
        Constants.tableViewHeight
    }
    
 
    
}


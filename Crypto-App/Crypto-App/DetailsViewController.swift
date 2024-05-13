//
//  DetailsViewController.swift
//  Crypto-App
//
//  Created by murat albayrak on 13.05.2024.
//

import UIKit
import CryptoAPI

class DetailsViewController: UIViewController {

    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var currentPriceChange: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var high24Value: UILabel!
    @IBOutlet weak var low24Value: UILabel!
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var detailCoinName: UILabel!
    @IBOutlet weak var detailCoinImage: UIImageView!
    
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var webSiteLabel: UILabel!
    
    var selectedCoin: Coin?
    var favoriteCoins : [Coin] = []
    var isStarFilled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
      
        guard let selectedCoin = selectedCoin else {
            print("selectedCoin is empty")
            return
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        webSiteLabel.isUserInteractionEnabled = true
        webSiteLabel.addGestureRecognizer(tapGesture)
        webSiteLabel.textColor = .blue
        configure(selectedCoin)
        
        
        let tapGestureFavorite = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        favoriteIcon.isUserInteractionEnabled = true
        favoriteIcon.addGestureRecognizer(tapGestureFavorite)
        
        if let data = UserDefaults.standard.data(forKey: "favoriteCoins"),
           let decodedGames = try? JSONDecoder().decode([Coin].self, from: data) {
            favoriteCoins = decodedGames
        }
        
        if favoriteCoins.contains(where: { $0.symbol == selectedCoin.symbol }) {
            favoriteIcon.image = UIImage(systemName: "heart.fill")
            isStarFilled = true
        } else {
            favoriteIcon.image = UIImage(systemName: "heart")
            isStarFilled = false
        }
        
    }
    
    @objc func imageTap() {
        
        if isStarFilled {
            favoriteIcon.image = UIImage(systemName: "heart")
            isStarFilled = false
            if let index = favoriteCoins.firstIndex(where: { $0.symbol == selectedCoin?.symbol}) {
                favoriteCoins.remove(at: index)
            }
            
        } else {
            favoriteIcon.image = UIImage(systemName: "heart.fill")
            isStarFilled = true
            if let selectedCoin = selectedCoin {
                favoriteCoins.append(selectedCoin)
            }
        }
        
        if let encodedData = try? JSONEncoder().encode(favoriteCoins) {
            UserDefaults.standard.set(encodedData, forKey: "favoriteCoins")
        }
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: selectedCoin?.coinrankingURL ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func configure(_ selectedCoin: Coin) {
        
        navigationItem.title = selectedCoin.symbol
        
        if let url = URL(string: selectedCoin.iconURL.replacingSVGWithPNG()) {
            detailCoinImage.sd_setImage(with: url)
        }
        
        detailCoinName.text = selectedCoin.name
        currentPrice.text = selectedCoin.price
        currentPriceChange.text = selectedCoin.change
        marketCap.text = selectedCoin.marketCap
        rank.text = "\(selectedCoin.rank)"
        volume.text = selectedCoin.the24HVolume
        high24Value.text = "$55,232,11"
        low24Value.text = "$51,122,23"
        low24Value.textColor = .red
        high24Value.textColor = .green
        
        if let changeText = currentPriceChange.text {
            if changeText.starts(with: "+") {
                currentPriceChange.text = "\u{25B2} \(changeText)"
                currentPriceChange.textColor = .green
            } else {
                currentPriceChange.text = "\u{25BC} \(changeText)"
                currentPriceChange.textColor = .red
            }
        }
    }


}

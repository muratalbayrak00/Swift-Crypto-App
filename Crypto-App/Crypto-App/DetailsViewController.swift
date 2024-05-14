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
    @IBOutlet weak var listedAt: UILabel!
    @IBOutlet weak var btcPriceValue: UILabel!
    @IBOutlet weak var btcPriceTitle: UILabel!
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
            showNotification()
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
    
    func showNotification() {
        
        let message = "Coin added to favorites"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func configure(_ selectedCoin: Coin) {
        
        navigationItem.title = selectedCoin.symbol
        
        detailCoinName.text = selectedCoin.name
        currentPrice.text = selectedCoin.price
        currentPriceChange.text = selectedCoin.change
        marketCap.text = formatLargeNumber(selectedCoin.marketCap)
        rank.text = "\(selectedCoin.rank)"
        volume.text = formatLargeNumber(selectedCoin.the24HVolume)
        btcPriceTitle.text = "\(selectedCoin.symbol)/BTC"
        btcPriceValue.text = formatNumbers(selectedCoin.btcPrice)
        listedAt.text = convertUnixTimestampToDate(unixTime: selectedCoin.listedAt)
        
        if let url = URL(string: selectedCoin.iconURL.replacingSVGWithPNG()) {
            detailCoinImage.sd_setImage(with: url)
        }
        
        if let sparklineMax = selectedCoin.sparkline.max() {
            high24Value.text = formatNumbers(sparklineMax)
            high24Value.textColor = .green
        }
        
        if let sparklineMin = selectedCoin.sparkline.min() {
            low24Value.text = formatNumbers(sparklineMin)
            low24Value.textColor = .red
        }
       
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
    
    func convertUnixTimestampToDate(unixTime: Int) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        return dateFormatter.string(from: date)
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
    

}

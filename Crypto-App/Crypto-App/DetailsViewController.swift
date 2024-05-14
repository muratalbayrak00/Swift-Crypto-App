//
//  DetailsViewController.swift
//  Crypto-App
//
//  Created by murat albayrak on 13.05.2024.
//

import UIKit

class DetailsViewController: UIViewController, DetailsViewModelDelegate {

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
    
    
    var isStarFilled = false
    
    var detailsViewModel: DetailsViewModelProtocol! {
        didSet {
            detailsViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        webSiteLabel.isUserInteractionEnabled = true
        webSiteLabel.addGestureRecognizer(tapGesture)
        webSiteLabel.textColor = .blue
        configure()
        
        let tapGestureFavorite = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        favoriteIcon.isUserInteractionEnabled = true
        favoriteIcon.addGestureRecognizer(tapGestureFavorite)
        

        
        detailsViewModel.fetchCoinDetails()
        
        if detailsViewModel.getFavoriteCoins().contains(where: { $0.symbol == detailsViewModel.getSelectedCoin()?.symbol }) {
            
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
            

            if let selectedCoin = detailsViewModel.getSelectedCoin(),
               let index = detailsViewModel.getFavoriteCoins().firstIndex(where: { $0.symbol == selectedCoin.symbol }) {
                var favoriteCoins = detailsViewModel.getFavoriteCoins()
                favoriteCoins.remove(at: index)
                detailsViewModel.setFavoriteCoins(favoriteCoins)
            }

        } else {
         
            favoriteIcon.image = UIImage(systemName: "heart.fill")
            isStarFilled = true
            

            if let selectedCoin = detailsViewModel.getSelectedCoin() {
                var favoriteCoins = detailsViewModel.getFavoriteCoins()
                favoriteCoins.append(selectedCoin)
                detailsViewModel.setFavoriteCoins(favoriteCoins)
            }
            showNotification()
        }
        
        if let encodedData = try? JSONEncoder().encode(detailsViewModel.getFavoriteCoins()) {
            UserDefaults.standard.set(encodedData, forKey: "favoriteCoins")
        }
    }
    
     @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: detailsViewModel.getSelectedCoin()?.coinrankingURL ?? "") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func showNotification() {
        
        let message = "Coin added to favorites"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    
    private func configure() {
        
        guard let selectedCoin = detailsViewModel.getSelectedCoin() else { return }
        
        navigationItem.title = selectedCoin.symbol
        
        detailCoinName.text = selectedCoin.name
        currentPrice.text = selectedCoin.price
        currentPriceChange.text = selectedCoin.change
        marketCap.text = detailsViewModel.formatLargeNumber(selectedCoin.marketCap)
        rank.text = "\(selectedCoin.rank)"
        volume.text = detailsViewModel.formatLargeNumber(selectedCoin.the24HVolume)
        btcPriceTitle.text = "\(selectedCoin.symbol)/BTC"
        btcPriceValue.text = detailsViewModel.formatNumbers(selectedCoin.btcPrice)
        listedAt.text = detailsViewModel.convertUnixTimestampToDate(unixTime: selectedCoin.listedAt)
        
        if let url = URL(string: selectedCoin.iconURL.replacingSVGWithPNG()) {
            detailCoinImage.sd_setImage(with: url)
        }
        
        if let sparklineMax = selectedCoin.sparkline.max() {
            high24Value.text = detailsViewModel.formatNumbers(sparklineMax)
            high24Value.textColor = .green
        }
        
        if let sparklineMin = selectedCoin.sparkline.min() {
            low24Value.text = detailsViewModel.formatNumbers(sparklineMin)
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

}

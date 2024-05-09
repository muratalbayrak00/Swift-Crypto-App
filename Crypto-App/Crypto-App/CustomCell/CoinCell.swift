//
//  CoinCell.swift
//  Crypto-App
//
//  Created by murat albayrak on 10.05.2024.
//

import UIKit
import SDWebImage
import CryptoAPI

class CoinCell: UITableViewCell {

    
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var coinSymbol: UILabel!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    @IBOutlet weak var coinChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureModel(_ model: Coin) {
        
        if let url = URL(string: model.iconURL.replacingSVGWithPNG()){
            coinImage.sd_setImage(with: url)
        }
        coinSymbol.text = model.symbol
        coinName.text = model.name
        coinPrice.text = model.price
        coinChange.text = model.change
    }
    
}

extension String {
    func replacingSVGWithPNG() -> String {
        return self.replacingOccurrences(of: ".svg", with: ".png")
    }
}

//
//  DetailsViewController.swift
//  Crypto-App
//
//  Created by murat albayrak on 13.05.2024.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var currentPrice: UILabel!
    @IBOutlet weak var currentPriceChange: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var high24Value: UILabel!
    @IBOutlet weak var low24Value: UILabel!
    
    @IBOutlet weak var rank: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.title = "BTC"
        configure()
        
    }
    

    func configure() {
        
        currentPrice.text = "$54,567.23"
        currentPriceChange.text = "-14,43%"
        marketCap.text = "$530,342.49"
        rank.text = "2"
        volume.text = "$244,590,440,31"
        high24Value.text = "$55,232,11"
        low24Value.text = "$51,122,23"
        low24Value.textColor = .red
        high24Value.textColor = .green
        if ((currentPriceChange.text?.starts(with: "+")) != nil) {
            currentPriceChange.textColor = .green
        } else {
            currentPriceChange.textColor = .red

        }
    }


}

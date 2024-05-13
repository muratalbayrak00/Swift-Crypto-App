//
//  CoinListController.swift
//  Crypto-App
//
//  Created by murat albayrak on 9.05.2024.
//

import Foundation
import CryptoAPI
import UIKit

class CoinListController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    
    var allCoins = [Coin]()
    
    let filterOptions = ["Price", "Market Cap", "24h Volume", "Change", "Listed At"]
    var selectedFilterIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Crypto-App"
        
        
        tableView.register(UINib(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoinLogic.shared.getCoins { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let welcome):
                self.allCoins = welcome.data.coins
                //deneme()
                formatCoinsPrice()
                formatCoinsChange()
                reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
        reloadData()
        
        
        
    }
    
    func deneme() {
        print("hello")
        for index in 0..<self.allCoins.count {
            print("\(self.allCoins[index].symbol):  \(self.allCoins[index].marketCap)")
        }
    }
    
    @objc func filterButtonTapped() {
        showPicker()
    }
    
    func formatCoinsPrice() {
        for index in 0..<self.allCoins.count {
            let coin = self.allCoins[index]
            if let formattedPrice = formatPrice(coin.price) {
                self.allCoins[index].price = formattedPrice
            }
        }
        
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
    
    func formatCoinsChange() {
        for index in 0..<self.allCoins.count {
            let coin = self.allCoins[index]
            self.allCoins[index].change = formatChange(coin.change) ?? ""
        }
    }
    
    func formatChange(_ changeString: String) -> String? {
        var formattedChange = changeString
        
        if !changeString.hasPrefix("-") {
            formattedChange = "+" + formattedChange
        }
        
        formattedChange += "%"
        
        return formattedChange
    }
    func showPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alertController.view.addSubview(pickerView)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension CoinListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! CoinCell
        
        cell.configureModel(allCoins[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension CoinListController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filterOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFilterIndex = row
        reloadPickerData()
    }
}

extension CoinListController {
    func date(from unixTimestamp: Double) -> Date {
        return Date(timeIntervalSince1970: unixTimestamp)
    }
    
    func reloadPickerData() {
        switch selectedFilterIndex {
            
        case 0: // Price
            self.allCoins.sort { coin1, coin2 in
                let price1String = coin1.price.dropFirst().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
                let price2String = coin2.price.dropFirst().replacingOccurrences(of: ",", with: "").replacingOccurrences(of: ".", with: "")
                
                if let price1 = Int(price1String), let price2 = Int(price2String) {
                    print(price1)
                    print(price2)
                    return price1 > price2
                } else {
                    print("Fiyat dönüşümünde hata oluştu")
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
            
            reloadData()
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
            self.tableView.reloadData()
        }
    }
}


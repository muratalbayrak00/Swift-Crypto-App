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
    
    var allCoins = [Coin]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        tableView.register(UINib(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CoinLogic.shared.getCoins { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let welcome):
                self.allCoins = welcome.data.coins
                reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        // Her bir satırın yüksekliğini belirleyin
        return 100 // Örnek olarak 100 piksel yükseklik
    }
    
}

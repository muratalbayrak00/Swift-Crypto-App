//
//  FavoriteMenuController.swift
//  Crypto-App
//
//  Created by murat albayrak on 13.05.2024.
//

import UIKit
import CryptoAPI

class FavoriteMenuController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var favoriteCoins: [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        navigationItem.title = "Favorite Coins"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let favoriteCoinData = UserDefaults.standard.data(forKey: "favoriteCoins"),
           let decodedFavoriteGames = try? JSONDecoder().decode([Coin].self, from: favoriteCoinData) {
            self.favoriteCoins = decodedFavoriteGames
            tableView.reloadData()
            
            if favoriteCoins.isEmpty && view.viewWithTag(999) == nil {
                let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                emptyLabel.text = "Oops! You haven't\nadded any games\nto your favorites yet."
                emptyLabel.textAlignment = .center
                emptyLabel.numberOfLines = 0
                emptyLabel.tag = 999
                tableView.backgroundView = emptyLabel
            } else {
                
                tableView.backgroundView = nil
            }
        }
    }
    

}

extension FavoriteMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell", for: indexPath) as! CoinCell
        
        cell.configureModel(favoriteCoins[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCoin = favoriteCoins[indexPath.row]
        if let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPageViewController") as? DetailsViewController {
            detailsVC.selectedCoin = selectedCoin
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

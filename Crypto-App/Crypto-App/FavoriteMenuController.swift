//
//  FavoriteMenuController.swift
//  Crypto-App
//
//  Created by murat albayrak on 13.05.2024.
//

import UIKit


class FavoriteMenuController: UIViewController, LoadingShowable {
    
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteMenuViewModel: FavoriteMenuViewModelProtocol! {
        didSet {
            favoriteMenuViewModel.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellType: CoinCell.self)
        navigationItem.title = "Favorite Coins"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        favoriteMenuViewModel.load()
        showEmptyView()
    }
    
    private func showEmptyView() {
        if favoriteMenuViewModel.getFavoriteCoins().isEmpty && view.viewWithTag(999) == nil {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            emptyLabel.text = "Oops! You haven't added any \ncoins to your favorites yet."
            emptyLabel.textAlignment = .center
            emptyLabel.numberOfLines = 0
            emptyLabel.tag = 999
            tableView.backgroundView = emptyLabel
            
        } else {
            tableView.backgroundView = nil
        }
    }
    
}

extension FavoriteMenuController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteMenuViewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(cellType: CoinCell.self, indexPath: indexPath)

        if let coin = favoriteMenuViewModel.coin(index: indexPath.row) {
            cell.configureModel(coin)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(favoriteMenuViewModel.tableViewHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedCoin = favoriteMenuViewModel.coin(index: indexPath.row) else {
            return
        }
        
        guard let detailsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsPageViewController") as? DetailsViewController else {
            fatalError("Unable to instantiate DetailsViewController")
        }
        
        let detailsViewModel = DetailsViewModel()
        
        detailsViewModel.selectedCoin = selectedCoin
        
        detailsVC.detailsViewModel = detailsViewModel
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension FavoriteMenuController: FavoriteMenuViewModelDelegate {
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
}

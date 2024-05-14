//
//  CoinListController.swift
//  Crypto-App
//
//  Created by murat albayrak on 9.05.2024.
//


import UIKit

class CoinListController: UIViewController , LoadingShowable{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterButton: UIButton!
    
    var viewModel: ViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    let filterOptions = ["Price", "Market Cap", "24h Volume", "Change", "Listed At"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Crypto-App"
       
        tableView.register(cellType: CoinCell.self)
        filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.load()
        tableView.backgroundColor = .gray
        reloadData()
    }
    
    @objc func filterButtonTapped() {
        showPicker()
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
}

extension CoinListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeCell(cellType: CoinCell.self, indexPath: indexPath)
        if let coin = viewModel.coin(index: indexPath.row) {
            cell.configureModel(coin)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let selectedCoin = viewModel.coin(index: indexPath.row) else {
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

        viewModel.selectedFilterIndex = row
        viewModel.reloadPickerData()
    }
    
}

extension CoinListController: ViewModelDelegate {
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



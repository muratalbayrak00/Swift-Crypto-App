//
//  FavoriteMenuControllerTest.swift
//  Crypto-AppTests
//
//  Created by murat albayrak on 14.05.2024.
//

import XCTest
@testable import Crypto_App

class FavoriteMenuControllerTests: XCTestCase {
    
    var favoriteMenuController: FavoriteMenuController!
    
    override func setUp() {
        
        super.setUp()
        favoriteMenuController = FavoriteMenuController()
    }
    
    override func tearDown() {
        
        favoriteMenuController = nil
        super.tearDown()
    }
    
    func testShowEmptyView() {
        
        favoriteMenuController.viewWillAppear(false)
        XCTAssertNotNil(favoriteMenuController.tableView.backgroundView, "Empty view should be shown when there are no favorite coins")
    }
    
    func testTableViewDataSource() {
        
        let numberOfItems = favoriteMenuController.tableView(favoriteMenuController.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfItems, 0, "Number of rows in  table view should be 0 when there are no favorites coins")
    }
    
    func testTableViewDelegate() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        favoriteMenuController.tableView(favoriteMenuController.tableView, didSelectRowAt: indexPath)
    }
    
    func testReloadData() {
        
        favoriteMenuController.reloadData()
    }
}


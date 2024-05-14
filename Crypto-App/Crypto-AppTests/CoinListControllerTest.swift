//
//  CoinListControllerTest.swift
//  Crypto-AppTests
//
//  Created by murat albayrak on 14.05.2024.
//

import XCTest
@testable import Crypto_App

class CoinListControllerTests: XCTestCase {
    
    var coinListController: CoinListController!
    
    override func setUp() {
        
        super.setUp()
        coinListController = CoinListController()
    }
    
    override func tearDown() {
        
        coinListController = nil
        super.tearDown()
    }
    
    func testFilterButtonTapped() {
        
        let filterButton = UIButton()
        coinListController.filterButton = filterButton
        
        coinListController.filterButtonTapped()
        
    }
    
    func testShowPicker() {
        
        coinListController.showPicker()
        
    }


    func testNumberOfComponentsInPickerView() {
        
        let pickerView = UIPickerView()
        let numberOfComponents = coinListController.numberOfComponents(in: pickerView)
        XCTAssertEqual(numberOfComponents, 1, "Number of components in picker view should be 1")
    }

    func testNumberOfRowsInPickerViewComponent() {
        let pickerView = UIPickerView()
        
        let numberOfRows = coinListController.pickerView(pickerView, numberOfRowsInComponent: 0)
    }


    
}


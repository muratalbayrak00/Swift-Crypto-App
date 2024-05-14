//
//  DetailsViewControllerTests.swift
//  Crypto-AppTests
//
//  Created by murat albayrak on 14.05.2024.
//

import XCTest
@testable import Crypto_App

class DetailsViewControllerTests: XCTestCase {
    
    var detailsViewController: DetailsViewController!
    
    override func setUp() {
        
        super.setUp()
        detailsViewController = DetailsViewController()
        
    }
    
    override func tearDown() {
        
        detailsViewController = nil
        super.tearDown()
        
    }
    
    func testConfigure() {
        
        detailsViewController.viewDidLoad()
        
    }

    func testImageTap() {
        
        detailsViewController.isStarFilled = true
        detailsViewController.imageTap()
        
    }

    func testLabelTapped() {
        
        let tapGesture = UITapGestureRecognizer()
        detailsViewController.labelTapped(tapGesture)
        
    }

    func testShowNotification() {
        
        detailsViewController.showNotification()
        
    }

}


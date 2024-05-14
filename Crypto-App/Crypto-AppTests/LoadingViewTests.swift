//
//  LoadingViewTests.swift
//  Crypto-AppTests
//
//  Created by murat albayrak on 14.05.2024.
//

import XCTest
@testable import Crypto_App

class LoadingViewTests: XCTestCase {
    
    var loadingView: LoadingView!
    
    override func setUp() {
        
        super.setUp()
        loadingView = LoadingView.shared
    }
    
    override func tearDown() {
        
        loadingView = nil
        super.tearDown()
    }
    
    func testStartLoading() {
        
        XCTAssertNil(loadingView.blurView.superview, "Blur view could not be added")
        XCTAssertFalse(loadingView.activityIndicator.isAnimating, "Activity indicator could not be initializatin")
        
        loadingView.startLoading()
        
        XCTAssertNotNil(loadingView.blurView.superview, "Blur view should be added to superview after startLoading()")
        XCTAssertTrue(loadingView.activityIndicator.isAnimating, "Activity indicator should be animating after startLoading()")
    }
    
    func testHideLoading() {
        
        loadingView.startLoading()
        
        XCTAssertNotNil(loadingView.blurView.superview, "Blur view should be added to superview before hideLoading()")
        XCTAssertTrue(loadingView.activityIndicator.isAnimating, "Activity indicator should be animating before hideLoading()")
        
        loadingView.hideLoading()
        
        XCTAssertNil(loadingView.blurView.superview, "Blur view should be removed from superview after hideLoading()")
        XCTAssertFalse(loadingView.activityIndicator.isAnimating, "Activity indicator should stop animating after hideLoading()")
    }
    
}


//
//  Crypto_AppTests.swift
//  Crypto-AppTests
//
//  Created by murat albayrak on 8.05.2024.
//

import XCTest
@testable import Crypto_App
@testable import CryptoAPI

final class Crypto_AppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
 

    
    func testCoinCellConfigureModel() {
        let coinCell = CoinCell()
        let coin = Coin(uuid: "testuuid", symbol: "BTC", name: "Bitcoin", color: "blue", iconURL: "https://example.com/bitcoin.png",
                        marketCap: "1000000000", price: "50000", listedAt: 1620975539, tier: 1, change: "+5%", rank: 1, sparkline: ["50.000", "60.000", "70.000", "80.000"],
                        lowVolume: true, coinrankingURL: "https://coinranking.com/coin/bitcoin", the24HVolume: "2432432342", btcPrice: "1")
                                                                                                                                 
        
        coinCell.configureModel(coin)
        
        XCTAssertEqual(coinCell.coinSymbol.text, "BTC")
        XCTAssertEqual(coinCell.coinName.text, "Bitcoin")
        XCTAssertEqual(coinCell.coinPrice.text, "50000")
        XCTAssertEqual(coinCell.coinChange.text, "+5%")
        XCTAssertEqual(coinCell.coinChange.textColor, .blue)

    }


}

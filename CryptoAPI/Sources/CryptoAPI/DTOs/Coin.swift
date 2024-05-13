//
//  Coin.swift
//
//
//  Created by murat albayrak on 8.05.2024.
//


import Foundation

public struct Welcome: Decodable {
    public let status: String
    public let data: DataClass
    

}

public struct DataClass: Decodable {
    public let stats: Stats
    public let coins: [Coin]
    

}

public struct Coin: Decodable, Encodable {
    public let uuid, symbol, name: String
    public let color: String?
    public let iconURL: String
    public var marketCap, price: String
    public let listedAt, tier: Int
    public var change: String
    public let rank: Int
    public let sparkline: [String]
    public let lowVolume: Bool
    public let coinrankingURL: String
    public let the24HVolume, btcPrice: String

    enum CodingKeys: String, CodingKey {
        case uuid, symbol, name, color
        case iconURL = "iconUrl"
        case marketCap, price, listedAt, tier, change, rank, sparkline, lowVolume
        case coinrankingURL = "coinrankingUrl"
        case the24HVolume = "24hVolume"
        case btcPrice
    }
}

public struct Stats: Decodable {
    public let total, totalCoins, totalMarkets, totalExchanges: Int
    public let totalMarketCap, total24HVolume: String

    enum CodingKeys: String, CodingKey {
        case total, totalCoins, totalMarkets, totalExchanges, totalMarketCap
        case total24HVolume = "total24hVolume"
    }
}

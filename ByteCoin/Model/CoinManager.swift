//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(rate:String,currency:String)
    func didFailWithError(error:Error)
}
struct CoinManager{
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "4CB2E1A7-219F-4C1E-B91C-33E2ABE78CC7"
    var delegate:CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency : String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data,response,error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let bitCoinPrice = parseJson(safeData) {
                        let priceString = String(format: "%.2f", bitCoinPrice)
                        delegate?.didUpdatePrice(rate:priceString,currency:currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ safeData:Data) -> Double?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: safeData)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            return nil
        }
        
    }
}

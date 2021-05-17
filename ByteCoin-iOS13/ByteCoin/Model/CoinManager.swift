//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


// defines a delgate which take two functions
protocol CoinManagerDelegate {
    func didUpdaterice(price: String, currency: String)
    func didFailWithError(error:Error)
}


struct CoinManager {
    
    var delegate: CoinManagerDelegate?// bring the coinmanager delegate pattern in coinmanager
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "FC70F992-1122-4677-B32E-5B6AB48B379C"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    func getCoinPrice(for currency:String){
        //use string concatenation to add the selected currenct at the end of the baseURL along with the API key.
        let urlstring = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        // use optional binding to unwrap the url that's created fron the URLstring
        if let url = URL(string: urlstring){
            //create a new urlsession object with default configuration
            
            //A default session behaves much like the shared session, but lets you configure it.
            //You can also assign a delegate to the default session to obtain data incrementally.
            let session = URLSession(configuration: .default)
            
            //CREATE  A new data task for the URL session
            let task = session.dataTask(with: url){(data,response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safedata = data{
                    if let bitCoinPrice = self.parseJson(safedata){
                        let priceString = String(format: "%.2f",bitCoinPrice )
                        self.delegate?.didUpdaterice(price: priceString, currency: currency)
                        
                    }
                }
            }
            // start the task to fetch data from the bitcoin average's servers
            task.resume()
            
        }
    }
    
    
    func parseJson(_ data:Data) -> Double?{
        let decoder=JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: data)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
        }catch{
            delegate?.didFailWithError(error: error )
            return nil
        }
    }
    
}

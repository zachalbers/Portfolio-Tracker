//
//  StockDataManager.swift
//  Portfolio Tracker
//
//  Created by Zach Albers on 2017-11-06.
//  Copyright © 2017 Zach Albers. All rights reserved.
//

import Foundation
let kNotificationStocksUpdated = "stocksUpdated"


class StockDataManager {
    
    
    
    class var sharedInstance : StockDataManager {
        struct Static {
            static let instance : StockDataManager = StockDataManager()
        }
        return Static.instance
    }
    
    /*!
     * @discussion Function that given an array of symbols, get their stock prizes from yahoo and send them inside a NSNotification UserInfo
     * @param stocks An Array of tuples with the symbols in position 0 of each tuple
     */
//    func updateListOfSymbols(stocks:Array<(String,Double)>) ->() {
        
        
//         let urlString:String =  ("https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=MSFT&outputsize=full&apikey=demo")
//        let url : URL = URL(string: urlString)!
//        let request: URLRequest = URLRequest(url:url)
//        let config = URLSessionConfiguration.default
//        let session = URLSession(configuration: config)
//
//        //3: Completion block/Clousure for the NSURLSessionDataTask
//        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
//
//            if((error) != nil) {
//                print(error?.localizedDescription ?? 0)
//            }
//            else {
//                let _: NSError?
//                //4: JSON process
//                do {
//                let jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//
//                    //5: Extract the Quotes and Values and send them inside a NSNotification
//                    let quotes: NSArray = ((jsonDict.object(forKey: "query") as! NSDictionary).object(forKey: "results") as! NSDictionary).object(forKey: "quote") as! NSArray
//
//                    print(quotes)
//
//                    DispatchQueue.main.async {
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationStocksUpdated), object: nil, userInfo: [kNotificationStocksUpdated:quotes])
////                    }
//                } catch _ {
//                    print("JSON Error ")
//                }
//
//
//                }
//
//        })
//
//        //6: DONT FORGET to LAUNCH the NSURLSessionDataTask!!!!!!
//        task.resume()
//    }
        
        
    func updateStock(stock: String, index: Int) {
    
        
        let urlString:String =  ("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=" + stock + "&interval=1min&outputsize=compact&apikey=K6ILWNFMTPAQOSM2")
        let url : URL = URL(string: urlString)!
        let request: URLRequest = URLRequest(url:url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        
        //3: Completion block/Clousure for the NSURLSessionDataTask
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            if((error) != nil) {
                print(error?.localizedDescription ?? 0)
            }
            else {
                let _: NSError?
                //4: JSON process
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data!, options: [])
                    

                    var timeSeries = [String: NSDictionary]()
                    if let dictionary = jsonDict as? [String: NSDictionary] {
                        timeSeries = dictionary["Time Series (1min)"] as! [String : NSDictionary]

                        
                        let price = (stockPrice: self.getCurrentStockPrice(stockDict: timeSeries), index: index)
                        print(price.stockPrice)
                        
DispatchQueue.main.async {
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationStocksUpdated), object: price)
                        }
                    }
                        

                } catch _ {
                    print("JSON Error")
                }
                
                
            }
            
        })
        
        //6: DONT FORGET to LAUNCH the NSURLSessionDataTask!!!!!!
        task.resume()
    }
    
    
    func getCurrentStockPrice(stockDict: [String : NSDictionary]) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:00"
        formatter.timeZone = TimeZone(abbreviation: "EST")! as TimeZone
        var date_key = formatter.string(from: date)
        var lastPrice = stockDict[date_key]
        
        if lastPrice == nil {
            formatter.dateFormat = "yyyy-MM-dd 16:00:00"
            date_key = formatter.string(from: date)
            lastPrice = stockDict[date_key]
            var daysBack: Int = 0
            
            while lastPrice == nil {
                daysBack -= 1
                let yesterday = Calendar.current.date(byAdding: .day, value: daysBack, to: date)
                date_key = formatter.string(from: yesterday!)
                lastPrice = stockDict[date_key]
            }
        }

        return lastPrice!["1. open"]! as! String
    }
}







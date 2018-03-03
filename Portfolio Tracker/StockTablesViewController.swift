//
//  ViewController.swift
//  Portfolio Tracker
//
//  Created by Zach Albers on 2017-11-06.
//  Copyright © 2017 Zach Albers. All rights reserved.
//

import UIKit
import Foundation



class StocksTablesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private var stocksList: [(String,Double)] = [("AAPL",0),("FB",0),("GOOG",0), ("MSFT", 0), ("ADBE", 0), ("AAL", 0), ("BIDU", 0), ("CSCO", 0) ]
    @IBOutlet weak var tableView: UITableView!
    
    
    let updates = StockDataManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stocksUpdated), name: NSNotification.Name(rawValue: "stocksUpdated"), object: nil)
        for i in 0..<(stocksList.count) {
            updates.updateStock(stock: stocksList[i].0, index: i)
        }
        print("ready to reload")
        //tableView.reloadData()
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func updateStocks() {
        
        tableView.reloadData()
        
    }
    
    @objc func stocksUpdated(notification: Notification) {
        let stock = notification.object as! (stockPrice: String, index: Int)
        
        stocksList[stock.index].1 = Double(stock.stockPrice)!
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cellId")
        cell.textLabel?.text = stocksList[indexPath.row].0
        cell.detailTextLabel?.text = "\(stocksList[indexPath.row].1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("cell clicked")
    }



}


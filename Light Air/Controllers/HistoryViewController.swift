//
//  FactsViewController.swift
//  Light Air
//
//  Created by Mihai on 05/02/2020.
//  Copyright © 2020 Mihai Dorhan. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private var historyVM = HistoryItemsViewModel()
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearHistoryButton: UIBarButtonItem!
    @IBOutlet weak var defaultMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeManager.addHeaderImageToNavigationController(sender: self, width: 30, height: 30)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getRecords()
    }
    
    @IBAction func deleteRecords() {
        historyVM.deleteAllHistoryData()
        getRecords()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        clearHistoryButton.tintColor = (historyVM.historyItems.count > 0) ? UIColor.white : PollutionIndex.brandGreen
        defaultMessageLabel.isHidden = (historyVM.historyItems.count > 0) ? true : false
        tableView.isHidden = (historyVM.historyItems.count > 0) ? false : true
        return historyVM.historyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCellId", for: indexPath) as? HistoryRecordTableCell else {
            return UITableViewCell()
        }
        
        let historyItem = historyVM.historyItems[indexPath.row]
        
        guard let country = historyItem.country,
              let city = historyItem.name,
              let airQuality = historyItem.airQuality,
              let airQualityBg = historyItem.airQualityBgColor,
              let airQualityFontColor = historyItem.airQualityFontColor
        else {
              return UITableViewCell()
        }
    
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.airQualityDetails.text = "\(historyItem.timestamp) - \(city), \(country)"
        cell.airQualityValue.backgroundColor = airQualityBg
        cell.airQualityValue.text = airQuality
        cell.airQualityValue.textColor = airQualityFontColor
        
        return cell
        
    }
    
    func getRecords() {
        historyVM.fetchAllHistoryData()
        clearHistoryButton.tintColor = PollutionIndex.brandGreen
        tableView.reloadData()
    }
    
}

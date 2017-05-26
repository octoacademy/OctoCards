//
//  MyOctoTableViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/23/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class MyOctoTableViewController: UITableViewController {

    /*** Sample Data ***/
    var items: [OctoCard]
    
    required init?(coder aDecoder: NSCoder) {
        items = [OctoCard]()
        let row0item = OctoCard()
        let row1item = OctoCard()
    
        row0item.pingYin = "Chī xiāngjiāo"
        row0item.phrase = "Eat a banana"
        items.append(row0item)
        
        row1item.pingYin = "Fàngxià nǐ"
        row1item.phrase = "Lay you down"
        items.append(row1item)

        super.init(coder: aDecoder)
    }*/
    /************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        items = CategoryManager.sharedInstance.myOctoList
        self.tableView.reloadData()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    /****** Using Custom TableViewCell using viewWithTag
    func configureText(for cell: UITableViewCell, with item: MyOctoItem) {
        let labelPY = cell.viewWithTag(1000) as! UILabel
        let labelPhrase = cell.viewWithTag(2000) as! UILabel
        
        labelPY.text = item.PingYing
        labelPhrase.text = item.Phrase
    }
    *************/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
   /*********** Using Custom TableViewCell and Configure Text method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyOctoItem", for: indexPath)
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
    }
    *****************/

    /************* Using Subtitle TableViewCell style **********/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOctoItem", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.pingYin
        cell.detailTextLabel?.text = item.phrase
        cell.imageView?.image = UIImage(named: "first")
        
        return cell
    }
}

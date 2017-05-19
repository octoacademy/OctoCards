//
//  MyOctoViewController.swift
//  Octo Cards
//
//  Created by Linda Ho on 5/19/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class MyOctoViewController: UITableViewController {
   /*** Sample Data ***/
    var items: [MyOctoItem]
    
    required init?(coder aDecoder: NSCoder) {
        items = [MyOctoItem]()
        
        let row0item = MyOctoItem()
        row0item.PingYing = "Chī xiāngjiāo"
        row0item.Phrase = "Eat a banana"
        items.append(row0item)
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureText(for cell: UITableViewCell, with item: MyOctoItem) {
        let labelPY = cell.viewWithTag(1000) as! UILabel
        let labelPhrase = cell.viewWithTag(2000) as! UILabel
        
        labelPY.text = item.PingYing
        labelPhrase.text = item.Phrase
    }
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
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
    
}

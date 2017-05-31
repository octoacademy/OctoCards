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
    var items: [Card] = [Card]()
    
    /*required init?(coder aDecoder: NSCoder) {
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
        
        items = myOctoList()
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
        
        cell.textLabel?.text = item.item.phrase_py
        cell.detailTextLabel?.text = "\(item.item.phrase!) \(item.subCategoryName)"
        cell.imageView?.image = UIImage(named: "first")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infantCardStoryboard: UIStoryboard = UIStoryboard(name: "InfantCard", bundle: nil)
        
        let vc = infantCardStoryboard.instantiateViewController(withIdentifier: "infantcontainer") as! InfantContainerViewController
        
        vc.subCategory = items[indexPath.row].subCategoryName
        vc.categoryKey = items[indexPath.row].categoryKey
        vc.subCategoryKey = items[indexPath.row].subCategoryKey
        vc.items = [items[indexPath.row].item]
        vc.singleCard = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let nav = appDelegate.window!.rootViewController?.childViewControllers[0] as? UINavigationController
        {
            nav.pushViewController(vc, animated: true)
        }

    }
    
    func myOctoList() -> [Card]
    {
        var items = [Card]()
        for string in CategoryManager.sharedInstance.myOctoStrings
        {
            let stringArray = string.components(separatedBy: "||")
            
            if stringArray.count == 3
            {
                if let card = CategoryManager.sharedInstance.categoryDictionary[string]
                {
                    
                    items.append(card)
                }
            }
        }

        let sorted = items.sorted(by: {
            
            if $0.subCategoryName != $1.subCategoryName {
                return $0.subCategoryName < $1.subCategoryName
            }
             else {
                return $0.item.phrase_py! < $1.item.phrase_py!
            }
        })
        return sorted
    }

}

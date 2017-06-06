//
//  GotItTableViewController.swift
//  Octo Cards
//
//  Created by Linda Ho on 5/24/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class GotItTableViewController: UITableViewController {
    
    var catLabels = ["At Home", "Out and About", "On the Go"]
    var cards: [Category]?
    
    var catCards: [Card]?
    
    var AtHomeCards: [OctoCard]?
    var OntheGoCards: [OctoCard]?
    var OutandAboutCards: [OctoCard]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        cards = gotItCards()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cards = gotItCards()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return catLabels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatLabel", for: indexPath)
        let itemName = catLabels[indexPath.row]
        var itemCount = 0
        
        cell.textLabel?.text = itemName
        cell.imageView?.image = UIImage(named: "first")
        
        if (indexPath.row < (cards?.count)!) {
            if let subCatCards = cards?[indexPath.row].subCategories {
                for subCategory in subCatCards {
                    itemCount+=(subCategory.items?.count)!
                }
            }
        }
        cell.detailTextLabel?.text = "(\(itemCount))"

        return cell
    }
    
    
    // MARK: - Navigation

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var catString = ""
        
        if let catVC = segue.destination as? GotItCategoryTableViewController {
            if let catCell = sender as? UITableViewCell {
    
                if catCell.textLabel?.text == "At Home" {
                    catString = "AtHome"
                }
                else if catCell.textLabel?.text == "On the Go" {
                    catString = "OnTheGo"
                }
                else if catCell.textLabel?.text == "Out and About" {
                    catString = "OutAndAbout"
                }
            
            catCards = GotItList(category: catString)
            catVC.GotItCards = catCards
            }
         }
    }
    
    func gotItCards() -> [Category]
    {
        var categoryDic = [String : Category]()
        
        for string in CategoryManager.sharedInstance.gotItStrings
        {
            let stringArray = string.components(separatedBy: "||")
            
            if stringArray.count == 3
            {
                let category = stringArray[0]
                let subCategory = stringArray[1]
                
                if let card = CategoryManager.sharedInstance.categoryDictionary[string]
                {
                    let item = card.item
                    let categoryName = card.categoryName
                    let subCategoryName = card.subCategoryName
                    
                    print ("CategoryName = \(categoryName) SubCategoryName = \(subCategoryName)")
                    
                    if let cat = categoryDic[category]
                    {
                        if let subCat = cat.subCategories
                        {
                            let filteredSubCategory = subCat.filter { $0.key == subCategory }
                            
                            if filteredSubCategory.count > 0
                            {
                                let filterFirst = filteredSubCategory.first!
                                if filterFirst.items == nil
                                {
                                    filterFirst.items = [item]
                                }
                                else
                                {
                                    filterFirst.items?.append(item)
                                }
                            }
                            else
                            {
                                let tempSubCategory = SubCategory()
                                tempSubCategory.items = [item]
                                tempSubCategory.key = subCategory
                                tempSubCategory.title = subCategoryName
                                categoryDic[category]?.subCategories?.append(tempSubCategory)
                            }
                        }
                        else
                        {
                            let tempSubCategory = SubCategory()
                            tempSubCategory.items = [item]
                            tempSubCategory.key = subCategory
                            tempSubCategory.title = subCategoryName
                            categoryDic[category]?.subCategories = [tempSubCategory]
                        }
                    }
                    else
                    {
                        let tempCategory = Category()
                        tempCategory.key = category
                        tempCategory.title = categoryName
                        
                        let tempSubCategory = SubCategory()
                        tempSubCategory.items = [item]
                        tempSubCategory.key = subCategory
                        tempSubCategory.title = subCategoryName
                        tempCategory.subCategories = [tempSubCategory]
                        
                        categoryDic[category] = tempCategory
                    }
                    
                }
                
            }
        }
        
        return Array(categoryDic.values)
    }
    
    func GotItList(category: String) -> [Card]
    {
        var items = [Card]()
        for string in CategoryManager.sharedInstance.gotItStrings
        {
            let stringArray = string.components(separatedBy: "||")
            print("stringArray: \(stringArray)")
            if stringArray.count == 3
            {
                print("string array: \(stringArray[0])")
                if (stringArray[0] == category) {
                    if let card = CategoryManager.sharedInstance.categoryDictionary[string]
                    {
                        items.append(card)
                    }
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

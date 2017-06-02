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
    
   /*
    required init?(coder aDecoder: NSCoder) {
        
         AtHomeCards = [OctoCard]()
        let row0itemA = OctoCard()
        let row1itemA = OctoCard()
        let row2itemA = OctoCard()
        
        row0itemA.pingYin = "Xǐshǒu"
        row0itemA.phrase = "Washing hands"
        AtHomeCards?.append(row0itemA)
        
        row1itemA.pingYin = "Shǒuzhǐ"
        row1itemA.phrase = "Fingers"
        AtHomeCards?.append(row1itemA)
        
        row2itemA.pingYin = "PY3"
        row2itemA.phrase = "Phrase 3"
        AtHomeCards?.append(row2itemA)
        
        OntheGoCards = [OctoCard]()
        let row0itemB = OctoCard()
        let row1itemB = OctoCard()
        
        row0itemB.pingYin = "On the Go PY1"
        row0itemB.phrase = "On the Go Phrase1"
        OntheGoCards?.append(row0itemB)
        
        row1itemB.pingYin = "On the Go PY2"
        row1itemB.phrase = "On the Go Phrase2"
        OntheGoCards?.append(row1itemB)

        OutandAboutCards = [OctoCard]()
        let row0itemC = OctoCard()
        
        row0itemC.pingYin = "Out and About PY1"
        row0itemC.phrase = "Out and About Phrase1"
        OutandAboutCards?.append(row0itemC)
        
        super.init(coder: aDecoder)
    }
*/
    
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        var catString = ""
        
        /******* setting up Back button*******/
       // let GotItStoryboard: UIStoryboard = UIStoryboard(name: "GotIt", bundle: nil)
        
       // let vc = GotItStoryboard.instantiateViewController(withIdentifier: "GotIt") as! GotItTableViewController
        /***************************************/
        
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
        /******* putting Back button in **********
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let nav = appDelegate.window!.rootViewController?.childViewControllers[0] as? UINavigationController
        {
            nav.pushViewController(catVC, animated: true)
        }
    }
        ***************************************/
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

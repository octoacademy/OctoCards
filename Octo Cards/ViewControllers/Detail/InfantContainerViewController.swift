//
//  InfantContainerViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/25/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class InfantContainerViewController: UIViewController {

    var subCategory: String = ""
    var categoryKey: String = ""
    var subCategoryKey: String = ""
    var singleCard = false
    
    @IBOutlet weak var container: UIView!
    var items : [Item] = [Item]()
    
    func getCards() -> [Item]
    {
        let filtered = CategoryManager.sharedInstance.categoryDictionary.filter({ print ($0.key)
           return $0.key.hasPrefix(self.categoryKey + "||" + self.subCategoryKey)
        })
        
       /* let filtered = CategoryManager.sharedInstance.cardArray.filter{$0.subCategoryKey == self.subCategoryKey}*/
        
        var newData = [String:Item]()
        
        for result in filtered {
            newData[result.0] = result.1.item
        }
        
         var myOctoCards = [Item]()
         var gotItCards = [Item]()
         var finalCards = [Item]()
        
        // remove myOcto cards
        for myOctoKey in CategoryManager.sharedInstance.myOctoStrings
        {
            if let value = newData[myOctoKey]
            {
                myOctoCards.append(value)
                newData.removeValue(forKey: myOctoKey)
            }
        }
        
        for gotItKey in CategoryManager.sharedInstance.gotItStrings
        {
            if let value = newData[gotItKey]
            {
                gotItCards.append(value)
                newData.removeValue(forKey: gotItKey)
            }
        }
        
        
        // final iteration to find the unshared cards
        /*finalCards.append(contentsOf: newData.values.shuffled())
        finalCards.append(contentsOf: myOctoCards.shuffled())
        finalCards.append(contentsOf: gotItCards.shuffled())
       */
        
        //final iterination if cards are UNSHUFFLED
        let sortedNewData = newData.values.sorted{$0.0.position < $0.1.position}
       
        //finalCards.append(contentsOf: newData.values)
        finalCards.append(contentsOf: sortedNewData)
        finalCards.append(contentsOf: myOctoCards)
        finalCards.append(contentsOf: gotItCards)
        
        return finalCards
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        self.navigationItem.title = subCategory
        
        //if let catItems = CategoryManager.sharedInstance.getItems(forCategory: categoryKey, forSubCategory: subCategoryKey)
     
        let pageViewController = childViewControllers[0] as! InfantCardCollectionViewController
        
        pageViewController.subCategory = subCategory
        pageViewController.categoryKey = categoryKey
        pageViewController.subCategoryKey = subCategoryKey
        pageViewController.items = singleCard ? self.items : self.getCards()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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

    @IBOutlet weak var container: UIView!
    var items : [Item] = [Item]()
    
    func getCards() -> [Item]
    {
        let filtered = CategoryManager.sharedInstance.categoryDictionary.filter({ print ($0.key)
            return $0.key.hasPrefix(self.categoryKey + "||" + self.subCategoryKey)
        })
        
        var newData = [String:Item]()
        for result in filtered {
            newData[result.0] = result.1
        }
        
         var myOctoCards = [Item]()
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
        
        // final iteration to find the unshared cards
        finalCards.append(contentsOf: newData.values)
        finalCards.append(contentsOf: myOctoCards)

        
        
        return finalCards
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
        self.navigationItem.title = subCategory
        
         
        //if let catItems = CategoryManager.sharedInstance.getItems(forCategory: categoryKey, forSubCategory: subCategoryKey)
     
        let pageViewController = childViewControllers[0] as! InfantCardsPageViewController
        pageViewController.items = self.getCards()
        pageViewController.subCategory = subCategory
        pageViewController.categoryKey = categoryKey
        pageViewController.subCategoryKey = subCategoryKey
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

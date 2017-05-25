//
//  OctoDetailViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/19/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class InfantCardsViewController: UIViewController {

    var category: String = ""
    var subCategory: String = ""
    
    @IBOutlet weak var subCategoryImage: UIImageView!
    @IBOutlet weak var scenarioText: UILabel!
    
    @IBOutlet weak var chineseTranslation: UILabel!
    @IBOutlet weak var englishPhrase: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let items = CategoryManager.sharedInstance.getItems(forCategory: category, forSubCategory: subCategory)
        // Do any additional setup after loading the view.
   
        print ("Category = \(category)  SubCategory = \(subCategory) Item count = \(String(describing: items?.count)))")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addToMyOcto(_ sender: UIButton) {
    }

    
    @IBAction func addToGotIt(_ sender: UIButton) {
    }
    
    @IBAction func next(_ sender: UIButton) {
    }
    
    @IBAction func flip(_ sender: UIButton) {
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

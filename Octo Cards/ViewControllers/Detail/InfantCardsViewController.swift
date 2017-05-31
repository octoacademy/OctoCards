//
//  OctoDetailViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/19/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class InfantCardsViewController: UIViewController {

    var item : Item!
    var categoryKey = ""
    var subCategoryKey = ""
    var index = 0
    var totalCount = 0
    
    @IBOutlet weak var backCardArea: UIView!
    @IBOutlet weak var cardArea: UIView!
    @IBOutlet weak var subCategoryImage: UIImageView!
    @IBOutlet weak var scenarioText: UILabel!
    
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
     @IBOutlet weak var chineseTranslation: UILabel!
    @IBOutlet weak var englishPhrase: UILabel!
    
    @IBOutlet weak var directTranslation: UILabel!
    @IBOutlet weak var tips: UILabel!
    @IBOutlet weak var chineseText: UILabel!
    @IBOutlet weak var myOctoButton: UIButton!
    @IBOutlet weak var gotItButton: UIButton!
    
    
    weak var delegate : InfantCardsPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cardArea.layer.cornerRadius = 10
        self.cardArea.clipsToBounds = true
        
        self.backCardArea.layer.cornerRadius = 10
        self.backCardArea.clipsToBounds = true
        
        setupPreviousNextScreen()
        
        scenarioText.adjustsFontSizeToFitWidth = true
        scenarioText.numberOfLines  = 0
         // Do any additional setup after loading the view.
        scenarioText.text = item.scenario
        chineseTranslation.text = item.phrase_py
        englishPhrase.text = item.phrase
        
        chineseText.text = item.phrase_trans
        
        directTranslation.adjustsFontSizeToFitWidth = true
        directTranslation.numberOfLines  = 0
        directTranslation.text = "Direct Translation : \(item.phrase ?? "")"
        
        tips.text = item.tip
        
        myOctoButton.isSelected = false
        gotItButton.isSelected = false
        
        let key = categoryKey + "||" + subCategoryKey + "||" + item.itemName!
        if let _ =  CategoryManager.sharedInstance.myOctoStrings.index(of: key)
        {
            myOctoButton.isSelected = true
        }
        
        if let _ =  CategoryManager.sharedInstance.gotItStrings.index(of: key)
        {
            gotItButton.isSelected = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPreviousNextScreen()
    {
        let img = rightButton.currentBackgroundImage!.withRenderingMode(.alwaysTemplate)
        rightButton.setBackgroundImage(img, for: UIControlState())
        rightButton.tintColor = UIColor(red: 195.0/255, green: 195.0/255, blue: 195.0/255, alpha: 1.0)
        
        let img2 = leftButton.currentBackgroundImage!.withRenderingMode(.alwaysTemplate)
        leftButton.setBackgroundImage(img2, for: UIControlState())
        leftButton.tintColor = UIColor(red: 195.0/255, green: 195.0/255, blue: 195.0/255, alpha: 1.0)
        rightButton.isHidden = index == totalCount - 1 ? true : false
        leftButton.isHidden =  index == 0 ? true : false
    }

    
    
    @IBAction func addToMyOcto(_ sender: UIButton) {
       
        
        
        if myOctoButton.isSelected
        {
            myOctoButton.isSelected = false
            CategoryManager.sharedInstance.removeItem(category: categoryKey,
                                                        subCategory: subCategoryKey,
                                                        item: self.item.itemName!, type: .myOcto)
        }
        else
        {
            gotItButton.isSelected = false
            myOctoButton.isSelected = true
            
            CategoryManager.sharedInstance.removeItem(category: categoryKey,
                                                      subCategory: subCategoryKey,
                                                      item: self.item.itemName!, type: .gotIt)

            CategoryManager.sharedInstance.addItem(category: categoryKey,
                                                     subCategory: subCategoryKey,
                                                     item: self.item.itemName!, type: .myOcto)
        }

    }

    
    @IBAction func addToGotIt(_ sender: UIButton) {
        
        if gotItButton.isSelected
        {
            gotItButton.isSelected = false
            CategoryManager.sharedInstance.removeItem(category: categoryKey,
                                                        subCategory: subCategoryKey,
                                                        item: self.item.itemName!, type: .gotIt)
        }
        else
        {
            gotItButton.isSelected = true
            myOctoButton.isSelected = false
            
            CategoryManager.sharedInstance.removeItem(category: categoryKey,
                                                      subCategory: subCategoryKey,
                                                      item: self.item.itemName!, type: .myOcto)

            CategoryManager.sharedInstance.addItem(category: categoryKey,
                                                     subCategory: subCategoryKey,
                                                     item: self.item.itemName!, type: .gotIt)
        }

    }
    
    @IBAction func goScreen(_ sender: UIButton) {
        if sender.tag == 1 //right
        {
            self.delegate.moveNextPage(index)
        }
        else
        {
            self.delegate.movePreviousPage(index)
        }
    }
    
    @IBAction func flip(_ sender: UIButton) {
        
        
        if !cardArea.isHidden
        {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]

            UIView.transition(with: cardArea, duration: 1.0, options: transitionOptions, animations: {
                self.cardArea.isHidden = true
            })
            UIView.transition(with: backCardArea, duration: 1.0, options: transitionOptions, animations: {
                self.backCardArea.isHidden = false
            })
        }
        else
        {
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]

            UIView.transition(with: backCardArea, duration: 1.0, options: transitionOptions, animations: {
                self.backCardArea.isHidden = true
            })
            UIView.transition(with: cardArea, duration: 1.0, options: transitionOptions, animations: {
                self.cardArea.isHidden = false
            })

        }

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

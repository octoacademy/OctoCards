//
//  InfantCardCollectionViewCell.swift
//  Octo Cards
//
//  Created by Macbook on 6/15/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class InfantCardCollectionViewCell: UICollectionViewCell {
    
    var item : Item!
    var categoryKey = ""
    var subCategoryKey = ""
    var index = 0
    var totalCount = 0
    
    @IBOutlet weak var backCardArea: UIView!
    @IBOutlet weak var cardArea: UIView!
    @IBOutlet weak var subCategoryImage: UIImageView!
    @IBOutlet weak var scenarioText: UILabel!
    
    
    @IBOutlet weak var chineseTranslation: UILabel!
    @IBOutlet weak var englishPhrase: UILabel!
    
    @IBOutlet weak var phraseImage: UIImageView!
    @IBOutlet weak var directTranslation: UILabel!
    @IBOutlet weak var tips: UILabel!
    @IBOutlet weak var chineseText: UILabel!
    @IBOutlet weak var myOctoButton: UIButton!
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var refNum: UILabel!
    
    
    override func awakeFromNib() {
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        
    }
    
    func setupCell()
    {
        
        setupRoundedCorner()
        
        subCategoryImage.image = UIImage(named: subCategoryKey)
        scenarioText.adjustsFontSizeToFitWidth = true
        scenarioText.numberOfLines  = 0
        // Do any additional setup after loading the view.
        scenarioText.text = item.scenario
        chineseTranslation.text = item.phrase_py
        englishPhrase.text = item.phrase
        
        phraseImage.image = UIImage(named: "\(item.itemName!).jpeg")
        
        chineseText.text = item.phrase_trans
        
        directTranslation.adjustsFontSizeToFitWidth = true
        directTranslation.numberOfLines  = 0
        refNum.text = "\(item.position)"
        
      /*  let translationLabel = "Direct Translation:\n"
        var translationText = "\(item.phrase ?? "")"
        
        var attr = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15)]
        var boldLabel = NSMutableAttributedString(string: translationLabel, attributes:attr)
        
        var attributedString = NSMutableAttributedString(string:translationLabel)
        attributedString.append(translationText)*/
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
    
    func setupRoundedCorner()
    {
        self.cardArea.layer.cornerRadius = 10
        self.cardArea.clipsToBounds = true
        
        self.backCardArea.layer.cornerRadius = 10
        self.backCardArea.clipsToBounds = true
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
    
}

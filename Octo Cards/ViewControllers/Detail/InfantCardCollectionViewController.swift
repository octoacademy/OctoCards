//
//  InfantCardCollectionViewController.swift
//  Octo Cards
//
//  Created by Macbook on 6/15/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class InfantCardCollectionViewController: UICollectionViewController {

    var subCategory: String = ""
    var categoryKey: String = ""
    var subCategoryKey: String = ""
    
    var items : [Item] = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCellSize()
        
        (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset  = UIEdgeInsets.zero
        
        var insets = self.collectionView!.contentInset
        
        let value = self.collectionView!.bounds.size.width / 2 - (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width / 2
        insets.left = value
        insets.right = value
        insets.top = -70
        self.collectionView!.contentInset = insets
        self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! InfantCardCollectionViewCell
    
        cell.item = items[indexPath.row]
        cell.subCategoryKey = subCategoryKey
        cell.categoryKey = categoryKey

        cell.setupCell()
        
        return cell
    }
    
     func setCellSize()
     {
        let layout = (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout)
        
        let widthPercentage : CGFloat = items.count == 1 ? 0.8 : 0.73
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            let cellSize = CGSize(width: UIScreen.main.bounds.width * widthPercentage , height: UIScreen.main.bounds.height * 0.7)
            layout.itemSize = cellSize
        }
        else
        {
            let cellSize = CGSize(width: UIScreen.main.bounds.width * widthPercentage , height: UIScreen.main.bounds.height * 0.8)
            layout.itemSize = cellSize
        }

        
    }
}

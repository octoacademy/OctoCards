//
//  PickOneCollectionViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/16/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class PickOneCollectionViewController: UICollectionViewController {

    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.navigationController?.navigationBar.topItem?.title = "Title here"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async { () -> Void in
            
            self.categories = CategoryManager.sharedInstance.categoryList
            DispatchQueue.main.async {() -> Void in
                self.collectionView?.reloadData()
            }
 
        }
       }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
     // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
       return CGSize( width: self.view.frame.size.width, height: 40)
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return categories.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if let sub = categories[section].subCategories
            {
                return sub.count
            }
        
        // #warning Incomplete implementation, return the number of items
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView,                                viewForSupplementaryElementOfKind kind: String,                                                                   at indexPath: IndexPath) -> UICollectionReusableView {
        
        var header: PickOneCollectionReusableView?
        
        if kind == UICollectionElementKindSectionHeader {
            header =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                withReuseIdentifier: "PickOneHeader", for: indexPath)
                as? PickOneCollectionReusableView
            
            header?.HeaderLabel.text = self.categories[indexPath.section].title
            
        }
        return header!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PickOneCollectionViewCell
    
        // Configure the cell
    
        cell.label.text = categories[indexPath.section].subCategories?[indexPath.row].title
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

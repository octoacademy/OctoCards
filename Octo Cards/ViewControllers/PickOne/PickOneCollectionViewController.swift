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

    let sectionInsets = UIEdgeInsets(top: 18.0, left: 18.0, bottom: 18.0, right: 18.0)
    let maxItem: CGFloat  = 3.0
    var spacing: CGFloat = 0.0
    
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "octodetail" {
            let indexPath = collectionView?.indexPathsForSelectedItems?.first
        }
    }*/
 
    
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return CGSize(width: 120, height:120)
        }
        else
        {
            let width = (collectionView.frame.width - sectionInsets.left - sectionInsets.right - (spacing * maxItem)) / maxItem
            return CGSize(width: width - 10.0, height:width + 30.0)
        }
    }
    
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       
        let infantCardStoryboard: UIStoryboard = UIStoryboard(name: "InfantCard", bundle: nil)
         
        let vc = infantCardStoryboard.instantiateViewController(withIdentifier: "infantcontainer") as! InfantContainerViewController
        
        vc.subCategory = categories[indexPath.section].subCategories![indexPath.row].title
        vc.categoryKey = categories[indexPath.section].key
        vc.subCategoryKey = categories[indexPath.section].subCategories![indexPath.row].key
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let nav = appDelegate.window!.rootViewController?.childViewControllers[0] as? UINavigationController
        {
            nav.pushViewController(vc, animated: true)
        }

    }
}

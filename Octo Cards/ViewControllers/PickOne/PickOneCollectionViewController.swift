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

   // let sectionInsets = UIEdgeInsets(top: 0.0 /*18.0*/, left: (collectionView.frame.width * 0.15) /*18.0*/, bottom: 18.0 /*18.0*/, right: (collectionView.frame.width * 0.15) /*18.0*/)
    let maxItem: CGFloat  = 2.0
    var spacing: CGFloat = 12.0 /*0.0*/
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // For Notifications
       
        if UIDevice.current.model == "iPad" {
            print("******** USING IPAD *********")
            
        }

        print(Array(UserDefaults.standard.dictionaryRepresentation()))
        
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
    
        let pageHeight = self.view.frame.size.height
        let cellHeight = collectionView.frame.width * 0.34 + 15 /* label font */
        let headerHeight = (pageHeight - (cellHeight * 3 /* num rows*/ + 50 /* header height */))/2
    
        if (section == 0) {
            return CGSize (width: self.view.frame.size.width, height: headerHeight);
        }
        else {
            return CGSize( width: self.view.frame.size.width, height: headerHeight+15)
        }
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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.label.adjustsFontSizeToFitWidth = true
        }
        
        /**** Specify image by expanding on below code ******/
        cell.image.image = UIImage(named: (categories[indexPath.section].subCategories?[indexPath.row].key)!)
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            //return CGSize(width: 120, height:120)
            let width = UIScreen.main.bounds.width/3.5
            
            return CGSize(width: width, height: width)

        }
        else
        {
            //let width = (collectionView.frame.width - sectionInsets.left - sectionInsets.right - (spacing * maxItem)) / maxItem
            
            /* this one works
            let width = (collectionView.frame.width * 0.33)*/
            
            let width = UIScreen.main.bounds.width/3

            return CGSize(width: width, height: width)//+ 30.0)
        }
    }
    
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
       
        /* Trying to vertically align all sections */
        let sectionInsetBottom = (collectionView.frame.height/15)
        let sectionInsetTop = sectionInsetBottom - 20
        var sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
    
      /*** original
        let sectionInsets = UIEdgeInsets(top: sectionInsetTop, left: (collectionView.frame.width * 0.16), bottom: sectionInsetBottom, right: (collectionView.frame.width * 0.16))
        **********/
        if UIDevice.current.userInterfaceIdiom == .pad {
            sectionInsets = UIEdgeInsets(top: collectionView.frame.height * 0.04, left: collectionView.frame.width * 0.12, bottom: collectionView.frame.height * 0.05, right: collectionView.frame.width * 0.12)
        }
        else {
        print("frame height: \(collectionView.frame.height)")
        print("sectioninsetBottom: \(sectionInsetBottom)")
        print("sectionInsetTop: \(sectionInsetTop)")
        sectionInsets = UIEdgeInsets(top: 5.0, left: (collectionView.frame.width * 0.12), bottom: 15, right: (collectionView.frame.width * 0.12))
        }
        
        return sectionInsets
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
       
        let infantCardStoryboard: UIStoryboard = UIStoryboard(name: "InfantCard", bundle: nil)
         
        let vc = infantCardStoryboard.instantiateViewController(withIdentifier: "infantcontainer") as! InfantContainerViewController
        
        vc.subCategory = categories[indexPath.section].subCategories![indexPath.row].title
        vc.categoryKey = categories[indexPath.section].key
        vc.subCategoryKey = categories[indexPath.section].subCategories![indexPath.row].key
    
        self.navigationController?.pushViewController(vc, animated: true)


    }
    
}

//
//  InfantCardCollectionViewController.swift
//  Octo Cards
//
//  Created by Macbook on 6/15/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

private let reuseIdentifier = "Cell"

class InfantCardCollectionViewController: UICollectionViewController {

    var subCategory: String = ""
    var categoryKey: String = ""
    var subCategoryKey: String = ""
    var audioPlayer : AVAudioPlayer = AVAudioPlayer()
    
    var items : [Item] = [Item]()
    {
        didSet
        {
           /***** no calling our own cell size func to test out copied code *****/
            setCellSize()
            
            if items.count > 0
            {
                (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset  = UIEdgeInsets.zero
                
                var insets = self.collectionView!.contentInset
                
                let value = UIScreen.main.bounds.width / 2 - (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width / 2
                insets.left = value
                insets.right = value
                insets.top = -70
                self.collectionView!.contentInset = insets
                self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
            }
        }
    }
    
    @IBAction func playSoundButton(_ sender: Any) {
        if !self.collectionView!.visibleCells.isEmpty {
            playSound()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.collectionView!.visibleCells.isEmpty {
            playSound()
        }
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /********* only for sample code *********
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    fileprivate var currentPage: Int = 0*/
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playSound()
        
        /**** trying out sample copied code for card scrolling ******
        let layout = self.collectionView?.collectionViewLayout as! UPCarouselFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)*/
    }
    /*************/

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
        let layout = (self.collectionView!.collectionViewLayout as! /*UPCarouselFlowLayout*/UICollectionViewFlowLayout)
        
        let widthPercentage : CGFloat = items.count == 1 ? 0.8 : 0.73
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            let cellSize = CGSize(width: UIScreen.main.bounds.width * widthPercentage , height: UIScreen.main.bounds.height * 0.7)
            layout.itemSize = cellSize
        }
        else
        {
            let cellSize = CGSize(width: UIScreen.main.bounds.width * widthPercentage , height: UIScreen.main.bounds.height * 0.65)
            layout.itemSize = cellSize
        }
        
    }
    
    func playSound()
    {
        let layout = (self.collectionView!.collectionViewLayout as! UICollectionViewFlowLayout)
        let index = round(abs(self.collectionView!.contentOffset.x / (layout.itemSize.width + layout.minimumInteritemSpacing)))
        
        print ("index \(index)")
        
        self.playSound(index: Int(index))
    }
    
    func playSound(index: Int)
    {
        var audioName = ""
        do {
            audioName = "\(items[index].itemName ?? "")"
            print("audioName: \(audioName)")
            guard let audioPath = Bundle.main.path(forResource: "\(audioName)", ofType: "mp3") else {
                print("audio path is not found")
                return
            }
            
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: (audioPath)) as URL)
        }
        catch {
        }
        audioPlayer.play()
    }
}

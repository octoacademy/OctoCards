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
    
    fileprivate var currentPage: Int = 0
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView!.collectionViewLayout as! UPCarouselFlowLayout
        var pageSize = layout.itemSize
        pageSize.width += layout.minimumLineSpacing
        return pageSize
    }
    
    var subCategory: String = ""
    var categoryKey: String = ""
    var subCategoryKey: String = ""
    var audioPlayer : AVAudioPlayer = AVAudioPlayer()
    
    var items : [Item] = [Item]()
    {
        didSet
        {            
            setCellSize()
            
            if items.count > 0
            {
                //(self.collectionView!.collectionViewLayout as! UPCarouselFlowLayout/*UICollectionViewFlowLayout*/).sectionInset  = UIEdgeInsets.zero
                
                //var insets = self.collectionView!.contentInset
                
                //let value = UIScreen.main.bounds.width / 2 - (self.collectionView!.collectionViewLayout as! UPCarouselFlowLayout/*UICollectionViewFlowLayout*/).itemSize.width / 2
                //insets.left = value
                //insets.right = value
                //insets.top = -70
                //self.collectionView!.contentInset = insets
                //self.collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
                
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
        
        //self.setupLayout()

        /*** contents from addCollectionView ****
        print("***************** 1 *****************")
        let pointEstimator = RelativeLayoutUtilityClass(referenceFrameSize: self.view.frame.size)
        let layout = UPCarouselFlowLayout()
        print("***************** 2 *****************")
        layout.itemSize = CGSize(width: pointEstimator.relativeWidth(multiplier: 0.73333), height: 400)
        *******************************************/
        
        
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
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playSound()
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
        //self.setupLayout()
        
        return cell
    }
    
    func setupLayout(){
        // This is just an utility custom class to calculate screen points
        // to the screen based in a reference view. You can ignore this and write the points manually where is required.
        let pointEstimator = RelativeLayoutUtilityClass(referenceFrameSize: self.view.frame.size)
        
        self.collectionView?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.collectionView?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: pointEstimator.relativeHeight(multiplier: 0.1754)).isActive = true
        self.collectionView?.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.collectionView?.heightAnchor.constraint(equalToConstant: pointEstimator.relativeHeight(multiplier: 0.6887)).isActive = true
        
        self.currentPage = 0
    }
    
    func setCellSize()
    {
        let layout = (self.collectionView!.collectionViewLayout as! UPCarouselFlowLayout)
        
        let widthPercentage : CGFloat = items.count == 1 ? 0.8 : 0.73
        
        //let widthPercentage : CGFloat = 0.8
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            let cellSize = CGSize(width: UIScreen.main.bounds.width * widthPercentage , height: UIScreen.main.bounds.height * 0.7)
            layout.itemSize = cellSize
        }
        else
        {
            let cellSize = CGSize(width: UIScreen.main.bounds.width * widthPercentage , height: UIScreen.main.bounds.height * 0.75)
            layout.itemSize = cellSize
        }
        
        layout.scrollDirection = .horizontal
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 20)
        
        if ((subCategory == "Shopping") || (subCategory == "Outdoors")) {
            self.collectionView?.backgroundColor = UIColor.init(red: 255.0/255.0, green: 195.0/255.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    func playSound()
    {
        let layout = (self.collectionView!.collectionViewLayout as! UPCarouselFlowLayout/*UICollectionViewFlowLayout*/)
        //let index = round(abs(self.collectionView!.contentOffset.x / (layout.itemSize.width + layout.minimumInteritemSpacing)))
        let index = round(abs(self.collectionView!.contentOffset.x / (layout.itemSize.width - 10.0)))
        
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

    class RelativeLayoutUtilityClass {
        
        var heightFrame: CGFloat?
        var widthFrame: CGFloat?
        
        init(referenceFrameSize: CGSize){
            heightFrame = referenceFrameSize.height
            widthFrame = referenceFrameSize.width
        }
        
        func relativeHeight(multiplier: CGFloat) -> CGFloat{
            
            return multiplier * self.heightFrame!
        }
        
        func relativeWidth(multiplier: CGFloat) -> CGFloat{
            return multiplier * self.widthFrame!
            
        }
    }


/*private let reuseIdentifier = "Cell"

class InfantCardCollectionViewController: UICollectionViewController {

    var subCategory: String = ""
    var categoryKey: String = ""
    var subCategoryKey: String = ""
    var audioPlayer : AVAudioPlayer = AVAudioPlayer()
    
    var items : [Item] = [Item]()
    {
        didSet
        {
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

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playSound()
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
}*/

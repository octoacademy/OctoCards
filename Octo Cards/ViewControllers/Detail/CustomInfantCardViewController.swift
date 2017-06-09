//
//  CustomCardViewController.swift
//  Layout
//
//  Created by Macbook on 6/7/17.
//  Copyright © 2017 Ghoststream. All rights reserved.
//

import UIKit

class CustomInfantCardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    var subCategory: String = ""
    var categoryKey: String = ""
    var subCategoryKey: String = ""
    
    var items : [Item] = [Item]()
    {
        didSet
        {
            var i = 0
            
            for (index, item) in items.enumerated()
            {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "infantcard") as! InfantCardsViewController
                
                vc.item = item
                vc.subCategoryKey = subCategoryKey
                vc.categoryKey = categoryKey
                vc.index = index
                vc.totalCount = items.count
                
                // Do any additional setup after loading the view.
                let cardView = vc.view!
                cardView.tag = index + 1
                cardView.layer.cornerRadius = 8;
                cardView.clipsToBounds = true
                addChildViewController(vc)
                cardView.layer.borderColor = UIColor.lightGray.cgColor
                cardView.layer.borderWidth = 1
                
                self.view.addSubview(cardView)
                
                i = i + 1
                
                cardView.translatesAutoresizingMaskIntoConstraints   = false
                print (cardView.frame)
                
                vc.didMove(toParentViewController: self)
                
                if items.count > 1
                {
                    let gesture = UIPanGestureRecognizer(target: self, action: #selector(CustomInfantCardViewController.userDragged(_:)))
                    cardView.addGestureRecognizer(gesture)
                }
                
                if UIDevice.current.userInterfaceIdiom == .pad
                {
                    view.addConstraint(NSLayoutConstraint(item: cardView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .top, multiplier: 1, constant: 30))
                    view.addConstraint(NSLayoutConstraint(item: cardView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.bottom, multiplier: 1, constant: -200))
                    
                    view.addConstraint(NSLayoutConstraint(item: cardView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 100))
                    view.addConstraint(NSLayoutConstraint(item: cardView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -100))
                }
                else
                {
                    view.addConstraint(NSLayoutConstraint(item: cardView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .top, multiplier: 1, constant: 10))
                    view.addConstraint(NSLayoutConstraint(item: cardView, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute:.bottom, multiplier: 1, constant: -150))
                    
                    view.addConstraint(NSLayoutConstraint(item: cardView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 30))
                    view.addConstraint(NSLayoutConstraint(item: cardView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -30))
                }
                
            }

        }
    }
    
    var initialPoint = CGPoint()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(CustomInfantCardViewController.pan(_:)))
        view.addGestureRecognizer(gesture)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        for v in self.view.subviews
        {
            if v.tag > 0
            {
                initialPoint = v.frame.origin
                break
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    var selectedCardViewCenter = CGPoint.zero
    var lastCard = [Int]()
    
    func userDragged(_ gesture: UIPanGestureRecognizer){
        
        if gesture.state == .began {
            selectedCardViewCenter = gesture.view!.center
        }
        else if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled
        {
            let velocity : CGPoint = gesture.velocity(in: gesture.view)
            
            
            if  velocity.y > 100 {
                print("down")
                print ("velocity : \(velocity.x) \(velocity.y)  ")
                UIView.animate(withDuration: 0.5, animations: {
                    gesture.view!.frame.origin = CGPoint(x: velocity.x, y: UIScreen.main.bounds.height)
                    self.lastCard.insert(gesture.view!.tag, at: 0)
                    gesture.view!.alpha = 0
                    
                } , completion: nil)
                
            } else {
                
                
                print("up")
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0.0, options: [], animations: {
                    gesture.view!.center = self.selectedCardViewCenter
                    gesture.view!.layer.borderColor = UIColor.lightGray.cgColor
                    gesture.view!.layer.borderWidth = 1
                }, completion: nil)
            }
            
            
        }
        else
        {
            let translation = gesture.translation(in: self.view)
            if let view = gesture.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                                      y:view.center.y + translation.y)
            }
            gesture.setTranslation(CGPoint.zero, in: self.view)
            
            gesture.view!.layer.borderColor = UIColor.darkGray.cgColor
            gesture.view!.layer.borderWidth = 2
        }
        
        
    }
    
    
    func pan(_ gesture: UIPanGestureRecognizer){
        if gesture.state == .ended
        {
            let velocity : CGPoint = gesture.velocity(in: gesture.view)
            
            
            if velocity.y < 0
            {
                if self.lastCard.count > 0
                {
                    UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                        let v = self.view.subviews.filter({ $0.tag == self.lastCard.first }).first
                        self.lastCard.removeFirst()
                        v?.frame.origin = self.initialPoint
                        v?.layer.borderColor = UIColor.lightGray.cgColor
                        v?.layer.borderWidth = 1
                        v?.alpha = 1
                        
                    }, completion: nil)
                }
            }
        }
        
    }
}

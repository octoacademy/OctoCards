//
//  InfantCardsPageViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/25/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class InfantCardsPageViewController: UIPageViewController {

    var subCategory: String = ""
    var categoryKey: String = ""
    var subCategoryKey: String = ""

    var items : [Item] = [Item]()
    var myOcto: [MyOctoItem] = [MyOctoItem]()
    var looping = false
    
   var controllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        
        myOcto = CategoryManager.sharedInstance.myOctoList
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        controllers = [UIViewController]()
        loadControllers()
        
        if let firstViewController = controllers.first
        {
            setViewControllers([firstViewController],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        }
    }
    
    func loadControllers()
    {
        for (index, item) in items.enumerated()
        {
            let storyboard = UIStoryboard(name: "InfantCard", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "infantcard") as! InfantCardsViewController
            vc.item = item
            vc.subCategoryKey = subCategoryKey
            vc.categoryKey = categoryKey
            vc.delegate = self
            vc.index = index
            vc.totalCount = items.count

            controllers.append(vc)
        }
        
    }
    
    func moveNextPage(_ index: Int)
    {
        print ("index = \(index)")
        
        if !looping && (index + 1) >= items.count
        {
            return
        }
        
        let nextPage = (index + 1) >= items.count ? 0 : index + 1
        
        setViewControllers([controllers[nextPage]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
        
    }
    
    func movePreviousPage(_ index: Int)
    {
        print ("index = \(index)")
        
        if !looping && (index - 1) < 0
        {
            return
        }
        
        let previousPage = (index - 1) < 0 ? items.count - 1 : index - 1
        
        setViewControllers([controllers[previousPage]],
                           direction: .forward,
                           animated: false,
                           completion: nil)
        
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

extension InfantCardsPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = controllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        if !looping && previousIndex < 0
        {
            return nil
        }
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return controllers.last
        }
        
        guard controllers.count > previousIndex else {
            return nil
        }
        
        return controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = controllers.index(of: viewController) else {
            return nil
        }
        
        //let vc = viewController as! WordViewController
        //vc.stopSayingWord()
        
        let nextIndex = viewControllerIndex + 1
        let controllersCount = controllers.count
        
        
        if !looping && nextIndex >= controllersCount
        {
            return nil
        }
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard controllersCount != nextIndex else {
            return controllers.first
        }
        
        guard controllersCount > nextIndex else {
            return nil
        }
        
        return controllers[nextIndex]
    }
}

//
//  RootViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/20/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class RootViewController: SlideMenuController {
    
    override func awakeFromNib() {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let leftNavStoryboard: UIStoryboard = UIStoryboard(name: "LeftNavigation", bundle: nil)

       self.mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "Main")
        
        self.leftViewController = leftNavStoryboard.instantiateViewController(withIdentifier: "Left")
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        if let nav = appDelegate.window!.rootViewController?.childViewControllers[0] as? UINavigationController
        {
            /******* This sets Title to Octo text - replacing with image *********
            nav.navigationBar.topItem?.title = "Octo"
             **********************/
            
            let title = UIImage(named: "OctoTitleLogo.png")
            let imageView = UIImageView(image: title)

            imageView.frame.size.height = imageView.frame.size.height * 0.60;

            imageView.contentMode = .scaleAspectFit
            nav.navigationBar.topItem?.titleView = imageView
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

}

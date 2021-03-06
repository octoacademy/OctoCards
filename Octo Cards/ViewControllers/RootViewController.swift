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
            var height = nav.navigationBar.frame.height * 0.5;
            
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                height = nav.navigationBar.frame.height * 0.75;
            }
            
            print("PHONE MODEL is a \(UIDevice.accessibilityContainerType().rawValue)")
            print ("SCREEN SIZE IS: \(UIScreen.main.nativeBounds.height)")
            if (UIDevice.current.userInterfaceIdiom == .phone) && (UIScreen.main.nativeBounds.height <= 568.0) {
                print("********** IPHONE 5 OR BELOW!!!!")
                print("phone is a \(UIDevice.current.model)")
            }
            //imageView.frame.size.height = nav.navigationBar.frame.height * 0.5;
            
            
            let heightConstraint = imageView.heightAnchor.constraint(equalToConstant: height)
            
            heightConstraint.isActive = true            
            
            print("title height is: \(imageView.frame.size.height)")
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

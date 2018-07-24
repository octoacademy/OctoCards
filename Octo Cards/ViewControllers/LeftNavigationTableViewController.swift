//
//  LeftNavigationTableViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/20/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class LeftNavigationTableViewController: UITableViewController {

    @IBAction func Terms(_ sender: Any) {
        let url = URL(string: "http://www.google.com") //update with website url to Terms
        UIApplication.shared.open(url!)
    }
    
    @IBAction func Privacy(_ sender: Any) {
        let url = URL(string: "http://www.google.com") //update with website url to Privacy
        UIApplication.shared.open(url!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
          }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        slideMenuController()?.closeLeft()
    }
    

}

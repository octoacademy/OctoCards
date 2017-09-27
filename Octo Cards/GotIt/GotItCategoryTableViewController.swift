//
//  GotItCategoryTableViewController.swift
//  Octo Cards
//
//  Created by Linda Ho on 5/24/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class GotItCategoryTableViewController: UITableViewController {

    var GotItCards: [Card]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return GotItCards!.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GotItItem", for: indexPath)
       
        let item = GotItCards?[indexPath.row]
        
        cell.textLabel?.text = item?.item.phrase_py
        cell.detailTextLabel?.text = item?.item.phrase
        //cell.imageView?.image = UIImage(named: "first")
        //cell.imageView?.frame.size.height = 1
    
    return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infantCardStoryboard: UIStoryboard = UIStoryboard(name: "InfantCard", bundle: nil)
        
        let vc = infantCardStoryboard.instantiateViewController(withIdentifier: "infantcontainer") as! InfantContainerViewController
        
        vc.subCategory = (GotItCards?[indexPath.row].subCategoryName)!
        vc.categoryKey = (GotItCards?[indexPath.row].categoryKey)!
        vc.subCategoryKey = (GotItCards?[indexPath.row].subCategoryKey)!
        vc.items = [(GotItCards?[indexPath.row].item)!]
        vc.singleCard = true
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let nav = appDelegate.window!.rootViewController?.childViewControllers[0] as? UINavigationController
        {
            nav.pushViewController(vc, animated: true)
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  MyOctoTableViewController.swift
//  Octo Cards
//
//  Created by Macbook on 5/23/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import UIKit

class MyOctoTableViewController: UITableViewController {

    @IBOutlet var NoItemsView: UIView!
    /*** Sample Data ***/
    var items: [Card] = [Card]()
    
    /*required init?(coder aDecoder: NSCoder) {
        items = [OctoCard]()
        let row0item = OctoCard()
        let row1item = OctoCard()
    
        row0item.pingYin = "Chī xiāngjiāo"
        row0item.phrase = "Eat a banana"
        items.append(row0item)
        
        row1item.pingYin = "Fàngxià nǐ"
        row1item.phrase = "Lay you down"
        items.append(row1item)

        super.init(coder: aDecoder)
    }*/
    /************************************/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.backgroundView = NoItemsView
    
        /**** Updates title to the text My Octo - but keeps it throughout app
        self.navigationController?.navigationBar.topItem?.titleView = nil
        self.navigationController?.navigationBar.topItem?.title = "My Octo"
        *****/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        items = myOctoList()
        self.tableView.reloadData()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  /*  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Octo"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {        
        let header = view as? UITableViewHeaderFooterView
        //header?.textLabel?.font = UIFont(name: "Marker Felt", size: 15)
        header?.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        header?.textLabel?.textColor = UIColor(red: 0.09, green: 0.04, blue: 0.91, alpha: 1.0)
        header?.textLabel?.text = header?.textLabel?.text?.capitalized ?? ""
        
        if items.count == 0 {
            header?.textLabel?.text = nil
        }
    }*/
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOctoItem", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.item.phrase_py
        cell.detailTextLabel?.text = item.item.phrase
        cell.imageView?.image = UIImage(named: "\(item.item.itemName!).jpeg")
        
        //modify image size (copied from sample code)
        let rowheight = cell.frame.height
        let itemSize = CGSize(width:rowheight-5, height:rowheight-5)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
        let imageRect = CGRect(x:0.0, y:0.0, width:itemSize.width, height:itemSize.height)
        cell.imageView?.image?.draw(in:imageRect)
        cell.imageView?.image? = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infantCardStoryboard: UIStoryboard = UIStoryboard(name: "InfantCard", bundle: nil)
        
        let vc = infantCardStoryboard.instantiateViewController(withIdentifier: "infantcontainer") as! InfantContainerViewController
        
        vc.subCategory = items[indexPath.row].subCategoryName
        vc.categoryKey = items[indexPath.row].categoryKey
        vc.subCategoryKey = items[indexPath.row].subCategoryKey
        vc.items = [items[indexPath.row].item]
        vc.singleCard = true
        
       self.navigationController?.pushViewController(vc, animated: true)

    }
    
    func myOctoList() -> [Card]
    {
        var items = [Card]()
        for string in CategoryManager.sharedInstance.myOctoStrings
        {
            let stringArray = string.components(separatedBy: "||")
            
            if stringArray.count == 3
            {
                if let card = CategoryManager.sharedInstance.categoryDictionary[string]
                {
                    
                    items.append(card)
                }
            }
        }

        let sorted = items.sorted(by: {
            
            if $0.subCategoryName != $1.subCategoryName {
                return $0.subCategoryName < $1.subCategoryName
            }
             else {
                return $0.item.phrase_py! < $1.item.phrase_py!
            }
        })
        return sorted
    }

}

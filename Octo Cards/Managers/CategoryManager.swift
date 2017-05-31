//
//  CategoryManager.swift
//  Octo Cards
//
//  Created by Macbook on 5/16/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import Foundation

enum OctoType
{
    case myOcto
    case gotIt
}

class CategoryManager
{
    static let sharedInstance: CategoryManager = CategoryManager()
    static let MyOctoFileName = "MyOcto"
    static let GotItFileName = "GotIt"
    fileprivate var categories = [Category]()
    fileprivate var categoryInternalDictionary = [String:Card]()
    fileprivate var myOctoItems = [String]()
    fileprivate var gotItItems = [String]()
    
    var categoryList: [Category]
    {
        return categories
    }
    
    var categoryDictionary : [String: Card]
    {
        return categoryInternalDictionary
    }
    
    var myOctoStrings : [String]
    {
            return myOctoItems
    }
    
    var gotItStrings : [String]
    {
        return gotItItems 
    }
    
    fileprivate init()
    {
        loadCategoryContent()
        myOctoItems = loadFile(file: CategoryManager.MyOctoFileName)
        gotItItems = loadFile(file: CategoryManager.GotItFileName)
    }
    
    fileprivate func loadCategoryContent()
    {
        if let filepath = Bundle.main.path(forResource: "Category", ofType: "json"),
            let data = Foundation.FileManager.default.contents(atPath: filepath)
        {
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                let jsonArray = jsonResult.value(forKey: "categories") as! NSArray
                
                print ("Total Category: \(jsonArray.count)")
                
                
                for json  in jsonArray as! [[String:Any]] {
                    
                    let category = Category()
                    
                    
                    category.key = json["key"] as! String
                    category.title = json["title"] as! String
                    
                    let subCategoriesJSONArray = json["subcategories"]
                    var subCategories = [SubCategory]()
                    
                    for subCatJson in subCategoriesJSONArray as! [[String:Any]] {
                        
                        let subCategory = SubCategory()
                        subCategory.key = subCatJson["key"] as! String
                        subCategory.title = subCatJson["title"] as! String
              
                        let itemsJSONArray = subCatJson["items"]
                        var items = [Item]()
                        
                        for itemJson in itemsJSONArray as! [[String:Any]] {
                            
                            let item = Item()
                            item.itemName = itemJson["itemName"] as? String
                            item.phrase = itemJson["phrase"] as? String
                            item.phrase_trans = itemJson["phrase_trans"] as? String
                            item.phrase_py = itemJson["phrase_py"] as? String
                            item.scenario = itemJson["scenario"] as? String
                            item.tip = itemJson["tip"] as? String
                            items.append(item)
                            
                            let card = Card()
                            card.item = item
                            card.categoryName = category.title
                            card.categoryKey = category.key
                            card.subCategoryName = subCategory.title
                            card.subCategoryKey = subCategory.key
                            
                            print (category.key + "||" + subCategory.key + "||"  + item.itemName!)
                            categoryInternalDictionary[category.key + "||" + subCategory.key + "||"  + item.itemName!] = card
                        }
                        
                        subCategory.items = items
                        
                        subCategories.append(subCategory)
                     }
                    
                    category.subCategories = subCategories
                    
                    categories.append(category)

                }
            }
            catch let error as NSError
            {
                fatalError("error upload sightwords content \(error.localizedDescription)")
            }

        }
    }
    
    func getItems(forCategory category: String, forSubCategory subCategory: String) -> [Item]?
    {
        let filteredCategories = categories.filter { $0.key.localizedCaseInsensitiveContains(category) }
        
        guard filteredCategories.count == 1, filteredCategories.first!.subCategories != nil, filteredCategories.first!.subCategories!.count >= 1  else { return nil }
        
        let filteredSubCategories =  filteredCategories.first!.subCategories!.filter { $0.key.localizedCaseInsensitiveContains(subCategory) }
        
        guard filteredSubCategories.count == 1 else { return nil }

        return filteredSubCategories.first!.items
    }
    
    private func loadFile(file : String) -> [String]
    {
        var items = [String]()
        let path = FileManager.documentsPathForFileName(file)
        
        print(path)
        
        let fileMgr = Foundation.FileManager.default
        
        if fileMgr.fileExists(atPath: path)
        {
            
            guard let array = NSArray(contentsOfFile: path) as? [String] else { return items}
            
            for  string in array
            {
                items.append(string)
            }
        }
        
        return items
     }
    
    func removeItem(category: String, subCategory: String,  item: String, type: OctoType)
    {
        let key = category + "||" + subCategory + "||" + item
        
        switch type {
            case .myOcto:
                if let index = myOctoItems.index(of: key)
                {
                    print ("Remove myOcto at \(index)")
                    myOctoItems.remove(at: index)
                 }
            case .gotIt :
                if let index = gotItItems.index(of: key)
                {
                    print ("Remove gotIt at \(index)")
                    gotItItems.remove(at: index)
            }
        }
        
        saveItem(type: type)
    }
    
    func addItem (category: String, subCategory: String,  item: String, type: OctoType)
    {
        let key = category + "||" + subCategory + "||" + item
        
        switch type {
            case .myOcto:
                let index = myOctoItems.index(of: key)
                
                if index == nil
                {
                    print ("Add to myOcto - \(item)")
                    
                    myOctoItems.append(key)
                }
            case .gotIt :
                let index = gotItItems.index(of: key)
                
                if index == nil
                {
                    print ("Add to GotIt - \(item)")
                    
                    gotItItems.append(key)
            }
        }

        saveItem(type: type)
     }
    
    private func saveItem(type: OctoType)
    {
        
        let success = NSArray(array: type == .myOcto ? myOctoItems : gotItItems).write(toFile: FileManager.documentsPathForFileName(type == .myOcto ? CategoryManager.MyOctoFileName : CategoryManager.GotItFileName), atomically: true)
        
        print ("Writing to \(type) = \(success)")
        
    }
    
    private func getGotIt()
    {
        
    }
}


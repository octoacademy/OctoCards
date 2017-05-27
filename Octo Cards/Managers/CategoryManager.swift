//
//  CategoryManager.swift
//  Octo Cards
//
//  Created by Macbook on 5/16/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//

import Foundation

class CategoryManager
{
    static let sharedInstance: CategoryManager = CategoryManager()
    fileprivate var categories = [Category]()
    fileprivate var categoryInternalDictionary = [String:Item]()
    fileprivate var myOctoItems = [String]()
    
    var categoryList: [Category]
    {
        return categories
    }
    
    var categoryDictionary : [String: Item]
    {
        return categoryInternalDictionary
    }
    
    var myOctoStrings : [String]
    {
            return myOctoItems
    }
    
    var myOctoList: [OctoCard]
    {
        var items = [OctoCard]()
        for string in myOctoItems
        {
            let stringArray = string.components(separatedBy: "||")
            
            if stringArray.count == 3
            {
                let category = stringArray[0]
                let subCategory = stringArray[1]
                let itemName = stringArray[2]
                
                if let item = categoryInternalDictionary[string]
                {
                    let myOctoItem = OctoCard()
                    myOctoItem.imageName = subCategory
                    myOctoItem.phrase = item.phrase!
                    myOctoItem.pingYin = item.phrase_py!
                    items.append(myOctoItem)
                }
                
            }
        }
        return items
    }
    
     fileprivate init()
    {
        loadCategoryContent()
        loadMyOcto()
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
                            
                            print (category.key + "||" + subCategory.key + "||"  + item.itemName!)
                            categoryInternalDictionary[category.key + "||" + subCategory.key + "||"  + item.itemName!] = item
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
    
    private func loadMyOcto()
    {
        let myOctoPath = FileManager.documentsPathForFileName("MyOcto")
        
        print(myOctoPath)
        
        let fileMgr = Foundation.FileManager.default
        
        if fileMgr.fileExists(atPath: myOctoPath)
        {
            
            guard let array = NSArray(contentsOfFile: myOctoPath) as? [String] else { return }
            
            for  string in array
            {
                myOctoItems.append(string)
            }
        }
     }
    
    func removeMyOcto(category: String, subCategory: String,  item: String)
    {
        let key = category + "||" + subCategory + "||" + item
        if let index = myOctoItems.index(of: key)
        {
            print ("Remove myOcto at \(index)")
            myOctoItems.remove(at: index)
            saveMyOcto()
        }
    }
    
    func addMyOcto (category: String, subCategory: String,  item: String)
    {
        let key = category + "||" + subCategory + "||" + item
        let index = myOctoItems.index(of: key)
        
        if index == nil
        {
            print ("Add to myOcto - \(item)")
         
            myOctoItems.append(key)
            saveMyOcto()
        }
    }
    
    private func saveMyOcto()
    {
        
        let success = NSArray(array: myOctoItems).write(toFile: FileManager.documentsPathForFileName("MyOcto"), atomically: true)
        
        print ("Writing to MyOcto = \(success)")
        
    }
    
    private func getGotIt()
    {
        
    }
}


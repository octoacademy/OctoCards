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
    
    var categoryList: [Category]
    {
        return categories
    }
    
    
     fileprivate init()
    {
        loadCategoryContent()
    }
    
    fileprivate func loadCategoryContent()
    {
        if let filepath = Bundle.main.path(forResource: "Category", ofType: "json"),
            let data = FileManager.default.contents(atPath: filepath)
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
                            items.append(item)
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
    
}


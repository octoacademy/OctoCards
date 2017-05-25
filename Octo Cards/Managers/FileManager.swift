//
//  FileManager.swift
//  Octo Cards
//
//  Created by Macbook on 5/24/17.
//  Copyright © 2017 OctoAcademy. All rights reserved.
//
import Foundation

class FileManager
{
    static let sharedInstance : FileManager = FileManager()
    
    
    fileprivate init()
    {
        
    }
    
    static func documentsPathForFileName(_ name: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let path = paths[0] as String;
        let fullPath = URL(string: path)?.appendingPathComponent(name)
        return (fullPath?.absoluteString)!
    }
}


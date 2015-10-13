//
//  JsonParser.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/13/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class JsonParser {
    static func parseArrayFromString(jsonString: String) -> NSArray? {
        do {
            if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
                if let array = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray {
                    return array
                }
            }
        } catch {}
        return nil
    }
}
//
//  TopChartsModel.swift
//  Embr
//
//  Created by Alex Ronquillo on 11/16/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

class TopChartsModel {
    
    static func getTopCharts(completionHandler: (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void) {
        EmbrConnection.get("/cgi-bin/GetTopCharts.py", params: ["session": SessionModel.getSession()], completionHandler: completionHandler)
    }
    
}
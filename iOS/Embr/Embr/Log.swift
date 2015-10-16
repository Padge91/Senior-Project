//
//  Log.swift
//  Embr
//
//  Created by Alex Ronquillo on 10/16/15.
//  Copyright © 2015 SeniorProject. All rights reserved.
//

import Foundation

enum EmbrLogType {
    case Error
    case Info
    case Debug
}

func log(logType type: EmbrLogType, message msg: String?) {
    switch (type) {
    case .Error:
        print("Error: \n\(msg)")
    case .Info:
        print("Info: \n\(msg)")
    case .Debug:
        print("Debugging: \n\(msg)")
    }
}
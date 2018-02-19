//
//  Timing.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

enum Timing {
    case immediate
    case dueDate(Date)
    case unspecified
    
    static let count = 3
}

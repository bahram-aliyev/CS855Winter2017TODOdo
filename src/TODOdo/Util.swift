//
//  Util.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-25.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class Util {
    
    private static var dateFormatter: DateFormatter!
    
    static func formatDate(_ date: Date) -> String {
        if self.dateFormatter == nil {
            let dueDateFormatter = DateFormatter()
            dueDateFormatter.dateStyle = .medium
            dueDateFormatter.timeStyle = .none
            self.dateFormatter = dueDateFormatter
        }
        
        return self.dateFormatter.string(from: date)
    }
}

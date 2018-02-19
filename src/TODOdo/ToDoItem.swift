//
//  ToDoItem.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

public class ToDoItem {
    
    private(set) var id: String
    var title: String
    var notes: String?
    var imageThumbnail: Data?
    var entryDate: Date
    var timing: Timing
    var priority: Priority
    var completedDate: Date?
    
    init(id: String, title: String, notes: String?, imageThumbnail: Data?,
         entryDate: Date, timing: Timing, priority: Priority, completedDate: Date?) {
        self.id = id
        self.title = title
        self.notes = notes
        self.imageThumbnail = imageThumbnail
        self.entryDate = entryDate
        self.timing = timing
        self.priority = priority
        self.completedDate = completedDate
    }
    
    convenience init(_ title: String, timing: Timing, priority: Priority) {
        self.init(id: UUID().uuidString, title: title, notes: nil, imageThumbnail: nil,
                  entryDate: Date(), timing: timing, priority: priority, completedDate: nil)
    }
    
    var status: ItemStatus {
        get {
            
            if(self.completedDate != nil) { return .done }
            
            if(self.dueDate == nil) { return .active }
            
            return
                Calendar.current.compare(Date(), to: self.dueDate!, toGranularity: .day) == .orderedDescending
                    ? .expired
                    : .active
            
        }
    }
    
    var dueDate: Date? {
        switch self.timing {
            case .unspecified:
                return nil
            case .dueDate(let dt):
                return dt
            default:
                return entryDate
        }
    }
}

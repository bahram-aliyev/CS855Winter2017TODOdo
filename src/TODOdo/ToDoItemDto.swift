//
//  ToDoDTO.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-26.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

class ToDoItemDto : NSObject, NSCoding {
    
    var id: String!
    var title: String!
    var notes: String?
    var imageThumbnail: Data?
    var entryDate: Date!
    var timing: Timing!
    var priority: Priority!
    var completedDate: Date?
    
//    private var dueDate: Date? {
//        get {
//            if case let tmng = self.timing!,
//                case let Timing.dueDate(ddt) = tmng {
//                return ddt
//            }
//            
//            return nil
//        }
//    }
    
    convenience init(_ toDo: ToDoItem) {
        self.init()
        
        self.id = toDo.id
        self.title = toDo.title
        self.notes = toDo.notes
        self.imageThumbnail = toDo.imageThumbnail
        self.entryDate = toDo.entryDate
        self.timing = toDo.timing
        self.priority = toDo.priority
        self.completedDate = toDo.completedDate
    }
    
    // MARK: NSCoding
    required convenience init?(coder dec: NSCoder) {
        self.init()
        
        self.id = dec.decodeObject(forKey: Descriptor.id) as? String
        self.title = dec.decodeObject(forKey: Descriptor.title) as? String
        self.notes  = dec.decodeObject(forKey: Descriptor.notes) as? String
        self.imageThumbnail = dec.decodeObject(forKey: Descriptor.imageThumbnail) as? Data
        self.entryDate = dec.decodeObject(forKey: Descriptor.entryDate) as? Date
        self.timing = self.decodeTiming(dec)
        self.priority = Priority(rawValue: Int(dec.decodeInt32(forKey: Descriptor.priority)))
        self.completedDate = dec.decodeObject(forKey: Descriptor.completedDate) as? Date
    }
    
    func encode(with enc: NSCoder) {
        enc.encode(self.id, forKey: Descriptor.id)
        enc.encode(self.title, forKey: Descriptor.title)
        enc.encode(self.notes, forKey: Descriptor.notes)
        enc.encode(self.imageThumbnail, forKey: Descriptor.imageThumbnail)
        enc.encode(self.entryDate, forKey: Descriptor.entryDate)
        enc.encode(self.priority.rawValue, forKey: Descriptor.priority)
        self.ecodeTiming(enc)
        enc.encode(self.completedDate, forKey: Descriptor.completedDate)
    }
    
    func toToDoItem() -> ToDoItem {
        return
            ToDoItem(
                id: self.id,
                title: self.title,
                notes: self.notes,
                imageThumbnail: self.imageThumbnail,
                entryDate: self.entryDate,
                timing: self.timing,
                priority: self.priority,
                completedDate: self.completedDate)
    }
    
    private func decodeTiming(_ dec: NSCoder) -> Timing! {
        let rawTiming = dec.decodeObject(forKey: Descriptor.timing) as? String
        switch rawTiming! {
            case Descriptor.timingImmediate:
                return Timing.immediate
            case Descriptor.timingUnspecified:
                return Timing.unspecified
            case Descriptor.timingDueDate:
                return Timing.dueDate(dec.decodeObject(forKey: Descriptor.dueDate) as! Date)
            default:
                return nil
        }
    }
    
    private func ecodeTiming(_ enc: NSCoder) {
        var timingDescr: String!
        var dueDate:Date! = nil
        
        switch self.timing! {
            case .immediate:
                timingDescr = Descriptor.timingImmediate
            case .unspecified:
                timingDescr = Descriptor.timingUnspecified
            case .dueDate(let ddt):
                timingDescr = Descriptor.timingDueDate
                dueDate = ddt
        }
        
        enc.encode(timingDescr, forKey: Descriptor.timing)
        enc.encode(dueDate, forKey: Descriptor.dueDate)
    }
    
    private class Descriptor {
        static let id = "id"
        static let title = "title"
        static let notes = "notes"
        static let entryDate = "entryDate"
        static let imageThumbnail = "imageThumbnail"
        static let timing = "timing"
        static let dueDate = "dueDate"
        static let priority = "priority"
        static let completedDate = "completedDate"
        
        static let timingImmediate = "immediate"
        static let timingUnspecified = "unspecified"
        static let timingDueDate = "dueDate"
    }
    
}

//
//  TimingDescriptor.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-20.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import Foundation

final class GroupingDescriptor {
    static let Immediate = "Immediate"
    static let DueDate = "Due Date"
    static let Unspecified = "Unspecified"
    static let Completed = "Completed"
    
    static let ArrangedGroups = [
        GroupingDescriptor.Immediate,
        GroupingDescriptor.DueDate,
        GroupingDescriptor.Unspecified,
        GroupingDescriptor.Completed
    ]
}

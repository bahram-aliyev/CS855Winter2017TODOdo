//
//  ToDoItemViewController.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-23.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class ToDoItemViewController: UITableViewCell {
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var timing: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var priorityIndicator: UIView!
    
    func configureToDoView(_ toDo: ToDoItem) {
        self.caption.attributedText = toDoToCaptionTextView(toDo)
        self.priorityIndicator.backgroundColor = self.toDoPriorityToColor(toDo)
        self.timing.text = self.toDoTimingToText(toDo)
        
        if let imageThumbnail = toDo.imageThumbnail {
            self.thumbnail.image = UIImage(data: imageThumbnail)
        }
        else {
            self.thumbnail.image = UIImage(named: "ToDoPlaceholder")
        }
    }
    
    private func toDoToCaptionTextView(_ toDo: ToDoItem) -> NSAttributedString {
        
        let captionText = NSMutableAttributedString(string: toDo.title)
        
        switch toDo.status {
        case .active:
            captionText.addAttribute(NSFontAttributeName,
                                        value: UIFont.init(name: "HelveticaNeue-Medium", size: 17)!,
                                            range: NSMakeRange(0, captionText.length))
        case .done:
            captionText.addAttribute(NSFontAttributeName,
                                        value: UIFont.init(name: "HelveticaNeue", size: 17)!,
                                            range: NSMakeRange(0, captionText.length))
            captionText.addAttribute(NSStrikethroughStyleAttributeName,
                                        value: 1, range: NSMakeRange(0, captionText.length))
        case .expired:
            captionText.addAttribute(NSFontAttributeName,
                                        value: UIFont.init(name: "HelveticaNeue-LightItalic", size: 17)!,
                                            range: NSMakeRange(0, captionText.length))
        }
        
        return captionText
    }
    
    private func toDoPriorityToColor(_ toDo: ToDoItem) -> UIColor {
        switch toDo.priority {
        case .high:
            return UIColor.red
        case .medium:
            return UIColor.orange
        default:
            return UIColor.blue
        }
    }
    
    private func toDoTimingToText(_ toDo: ToDoItem) -> String {
        switch toDo.timing {
        case .dueDate(let dueDate):
            return Util.formatDate(dueDate)
        case .immediate:
            return "..!"
        default:
            return "..?"
        }
    }
}

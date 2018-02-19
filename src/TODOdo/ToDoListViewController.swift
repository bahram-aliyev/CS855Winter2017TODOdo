//
//  ToDoListViewController.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-23.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController, ToDoListModelDelegate {

    static let filterActionKey = "ViewFilter"
    
    static let filterDictionary = [
        ItemsFilter.ActiveAndExpired: "Active and Expired",
        ItemsFilter.ActiveOnly : "Active Only",
        ItemsFilter.CompletedOnly  : "Completed Only",
        ItemsFilter.All  : "All",
    ]
    
    @IBOutlet var toDoTableView: UITableView!
    @IBOutlet weak var toDoListCaption: UINavigationItem!
    
    private var model : ToDoListModel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.model = ToDoListModel(toDoRepository: InMemoryToDoRepository())
        self.model.delegate = self
        
        self.model.loadToDoList(filter: ItemsFilter.ActiveAndExpired)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.toDoCategories.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (model.toDoList[model.toDoCategories[section]]?.count)!
    }

    // MARK: configure a ToDo cell view
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
                tableView.dequeueReusableCell(withIdentifier: "ToDoItem", for: indexPath) as! ToDoItemViewController
        
        cell.accessoryType = .disclosureIndicator
        
        cell.configureToDoView(self.toDoItemByIndexPath(indexPath)!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model.toDoCategories[section]
    }
    
    // MARK: Custom table row actions
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let toDoItem = self.toDoItemByIndexPath(indexPath)
        let buttonText = toDoItem?.status != .done ? "Done" : "Undo"
        
        let togleUndoAction =
                UITableViewRowAction(style: .normal, title: buttonText, handler: togleToDoItemDoneStatus)
        togleUndoAction.backgroundColor = toDoItem?.status != .done ? .orange : .lightGray
        
        let deleteAction =
                UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteToDoItem)
        
        return [deleteAction, togleUndoAction]
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            model.deleteToDo(toDo: self.toDoItemByIndexPath(indexPath)!)
        }
    }
    
    @IBAction func changeViewFilter(_ sender: Any) {
        let filterSelectorUIAlert = self.initFilterSelector()
        self.present(filterSelectorUIAlert, animated: true, completion:  nil)
    }
    
    // MARK: Handle row custom actions
    
    private func togleToDoItemDoneStatus(action: UITableViewRowAction, indexPath: IndexPath) {
        if let toDoItem = self.toDoItemByIndexPath(indexPath) {
            if toDoItem.status == .done {
                self.model.undoCompleted(toDo: toDoItem)
            }
            else {
                self.model.completeToDo(toDo: toDoItem)
            }
        }
    }
    
    private func deleteToDoItem(action: UITableViewRowAction, indexPath: IndexPath) {
        if let toDoItem = self.toDoItemByIndexPath(indexPath) {
            self.model.deleteToDo(toDo: toDoItem)
        }
    }
    
    
    // MARK: Filter selector
    
    private func initFilterSelector() -> UIAlertController {
        let filterSelectorUIAlert =
            UIAlertController(title: "ToDo Filter",
                              message: "Select ToDo's view fiter.",
                              preferredStyle: .actionSheet)
        
        for (filter, desc) in ToDoListViewController.filterDictionary {
            let style = (filter == self.model.filter
                ? UIAlertActionStyle.destructive
                : UIAlertActionStyle.default)
            
            let action = UIAlertAction(title: desc, style: style, handler: filterSelectorActionTemplate(filter: filter))
            filterSelectorUIAlert.addAction(action)
        }
        
        filterSelectorUIAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return filterSelectorUIAlert
    }
    
    private func filterSelectorActionTemplate(filter: ItemsFilter) -> (UIAlertAction) -> Void {
        return {
            (UIAlertAction) -> Void in
            self.model.loadToDoList(filter: filter)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditToDo" {
            self.setToDoForEdit(segue: segue, sender: sender)
        }
    }
    
    @IBAction
    func unwindToItemsList(sender: UIStoryboardSegue) {
        if sender.source is ToDoEntryViewController {
            self.model.loadToDoList()
        }
    }
    
    // MARK: ToDoListModelDelegate
    
    func toDoListChanged(groupedItems: [String:[ToDoItem]]) {
        toDoTableView.reloadData()
        toDoListCaption.title = ToDoListViewController.filterDictionary[model.filter]
    }
    
    // MARK: Utility methods
    
    private func toDoItemByIndexPath(_ indexPath: IndexPath) -> ToDoItem? {
        return model.toDoList[model.toDoCategories[indexPath.section]]?[indexPath.row]
    }
    
    private func setToDoForEdit(segue: UIStoryboardSegue, sender: Any?) {
        guard let toDoEntryController = segue.destination as? ToDoEntryViewController else {
            fatalError("Unexpected destination: [\(segue.destination)]")
        }
        
        guard let selectedToDoItem = sender as? ToDoItemViewController else {
            fatalError("Unexpected sender: [\(sender)]")
        }
        
        guard let indexPath = self.tableView.indexPath(for: selectedToDoItem) else {
            fatalError("The selected cell is not being displayed by the table.")
        }
        
        toDoEntryController.toDoId = toDoItemByIndexPath(indexPath)?.id
    }
}

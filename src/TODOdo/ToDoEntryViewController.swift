//
//  ToDoEntryViewController.swift
//  TODOdo
//
//  Created by Bahram Aliyev on 2017-02-23.
//  Copyright © 2017 Bahram Aliyev. All rights reserved.
//

import UIKit

class ToDoEntryViewController:
            UITableViewController,
            UIPickerViewDelegate,
            UIPickerViewDataSource,
            UITextFieldDelegate,
            UITextViewDelegate,
            UIImagePickerControllerDelegate,
            UINavigationControllerDelegate,
            ToDoEntryModelDelegate {
 
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet var toDoEntryTable: UITableView!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var priorityPicker: UIPickerView!
    @IBOutlet weak var toDoTitleText: UITextField!
    @IBOutlet weak var toDoDoneSwitch: UISwitch!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var priorityCell: UITableViewCell!
    @IBOutlet weak var timingCell: UITableViewCell!
    @IBOutlet weak var dueDateCell: UITableViewCell!
    @IBOutlet weak var toDoImageView: UIImageView!
    
    private let sectionsToCellMapping = [
        // TODO
        0 : 2,
        // DETAILS
        1 : 5,
        // BRIEF
        2 : 1,
        // MISCELLANEOUS
        3 : 3
    ]
    
    private let priorities = [
        (title:"High", color: UIColor.red, type: Priority.high),
        (title:"Medium", color: UIColor.orange, type: Priority.medium),
        (title:"Low", color: UIColor.blue, type: Priority.low)
    ]
    
    private let timings = [
        (title:"Immediate", type: Timing.immediate),
        (title:"Due Date", type: Timing.dueDate(Date())),
        (title:"Unspecified", type: Timing.unspecified)
    ]
    
    private var isPriorityPickerVisible = false
    private var isDueDateVisible = false
    private var isDueDatePickerVisible = false
    private var isCreatedVisible = false
    private var isCompletedVisible : Bool {
        return self.currentToDo.completedDate != nil
    }
    
    // sections and rows indexes start from 0
    private let priorityIndexPath = IndexPath(row: 0, section: 1)
    private let priorityPickerIndexPath = IndexPath(row: 1, section: 1)
    private let timingIndexPath = IndexPath(row: 2, section: 1)
    private let dueDateIndexPath = IndexPath(row: 3, section: 1)
    private let dueDatePickerIndexPath = IndexPath(row: 4, section: 1)
    private let completedIndexPath = IndexPath(row: 1, section: 3)
    private let toDoImageIndexPath = IndexPath(row: 1, section: 0)
    
    private var model: ToDoEntryModel!
    
    public var currentToDo: ToDoItem! {
        get {
            return model.current
        }
    }
    
    var toDoId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dueDatePicker.minimumDate = Date()
        self.priorityCell.accessoryType = .disclosureIndicator
        self.timingCell.accessoryType = .disclosureIndicator
        self.dueDateCell.accessoryType = .disclosureIndicator
        
        self.model = ToDoEntryModel(toDoRepository: InMemoryToDoRepository())
        self.model.delegate = self
        
        if self.toDoId != nil {
            self.model.loadToDo(toDoId: self.toDoId!)
        }
        else {
            self.model.newToDo()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsToCellMapping.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionsToCellMapping[section]!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case self.priorityIndexPath:
            self.togglePriorityPicker()
        case self.timingIndexPath:
            let timingSelectorAlert = self.initTimingSelector()
            self.present(timingSelectorAlert, animated: true, completion: nil)
        case self.dueDateIndexPath:
            self.toggleDueDatePicker()
        case self.toDoImageIndexPath:
            self.present(self.initPhotoSelector(), animated: true, completion: nil)
        default:
            self.isPriorityPickerVisible = false
            self.isDueDatePickerVisible = false
        }
        
        self.toDoEntryTable.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
            case
                self.dueDatePickerIndexPath where !self.isDueDatePickerVisible,
                self.priorityPickerIndexPath where !self.isPriorityPickerVisible,
                self.dueDateIndexPath where !self.isDueDateVisible,
                self.completedIndexPath where !self.isCompletedVisible:
                return 0
            default:
                return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    // MARK: UIPickerViewDataSource
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.priorities.count
    }
    
    // MARK: UIPickerViewDelegate
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return priorityOptionToText(self.priorities[row])
    }
    
    // MARK: Timing allert view
    
    private func initTimingSelector() -> UIAlertController {
        let timingSelectorUIAlert =
                UIAlertController(title: "ToDo Timing",
                                    message: "Set ToDo's timing.",
                                        preferredStyle: .actionSheet)
        
        for (title, timing) in self.timings {
            
            var actionStyle: UIAlertActionStyle
            switch (timing, self.currentToDo.timing) {
                case (.dueDate(_), .dueDate(_)):
                    actionStyle = .destructive
                case (.immediate, .immediate):
                    actionStyle = .destructive
                case (.unspecified, .unspecified):
                    actionStyle = .destructive
                default:
                    actionStyle = .default
            }
            
            let action =
                    UIAlertAction(title: title, style: actionStyle, handler:
                                    timingSelectorActionTemplate(timing: timing))
            timingSelectorUIAlert.addAction(action)
        }
        
        timingSelectorUIAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return timingSelectorUIAlert
    }
    
    private func timingSelectorActionTemplate(timing: Timing) -> (UIAlertAction) -> Void {
        return {
            (UIAlertAction) -> Void in
            
            self.currentToDo.timing = timing
            self.timingLabel.text = self.timingToDescriptor(toDo: self.currentToDo).title
            
            if case .dueDate(_) = timing {
                self.isDueDateVisible = true
                self.dueDateLabel.text = Util.formatDate(self.currentToDo.dueDate!)
            }
            else {
                self.isDueDateVisible = false
                self.isDueDatePickerVisible = false
                self.dueDateLabel.text = nil
            }
            
            self.refreshTableView()
        }
    }
    
    // Mark: Photo selector alert view
    
    private func initPhotoSelector() -> UIViewController {
        // if there is no available camera use only the photo library
        if(!UIImagePickerController.isSourceTypeAvailable(.camera)) {
            return initImagePicker()
        }
        
        let photoSelectorUIAlert =
                UIAlertController(title: "ToDo Image",
                                  message: "Select the source of the ToDo's image.",
                                  preferredStyle: .actionSheet)
        _ =
            [
                UIAlertAction(title: "Camera", style: .default, handler: photoSelectorActionTemplate(sourceType: .camera)),
                UIAlertAction(title: "Photo Library", style: .default, handler: photoSelectorActionTemplate(sourceType: .photoLibrary)),
                UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ].map({photoSelectorUIAlert.addAction($0)})
        
        return photoSelectorUIAlert
    }
    
    private func photoSelectorActionTemplate(sourceType: UIImagePickerControllerSourceType) -> (UIAlertAction) -> Void {
        return {
            (UIAlertAction) -> Void in
            self.present(self.initImagePicker(sourceType: sourceType), animated: true, completion: nil)
        }
    }
    
    func initImagePicker(sourceType: UIImagePickerControllerSourceType = .photoLibrary) -> UIViewController {
        self.toDoTitleText.resignFirstResponder()
        self.descriptionText.resignFirstResponder()
        
        // prepare image picker to show up
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        
        return imagePickerController
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.currentToDo.title = textField.text ?? ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.saveBarButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.updateSaveButtonState()
        self.navigationItem.title = textField.text
    }
    
    // MARK: UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if text == "\n" {
            textView.resignFirstResponder()
            self.currentToDo.notes = textView.text
            return false
        }
        
        return true
    }
    
    // MARK: UIImagePickerControllerDelegate

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // just close the image picker, no cnages on cancel
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("The appication was not able to retrive the selected image due to the follwing reason: '\(info)'")
        }
        
        self.currentToDo.imageThumbnail = UIImageJPEGRepresentation(image, 1.0)
        self.toDoImageView.image = image
    }
    
    // MARK: ToDoEntryModelDelegate
    
    func toDoReadyForEntry(toDo: ToDoItem) {
        // title
        self.navigationItem.title = toDo.title
        self.toDoTitleText.text = toDo.title
        
        if let imageDate = toDo.imageThumbnail {
            toDoImageView.image = UIImage(data: imageDate)
        }
        
        // details
        let priorityOption = self.priorities.first { $0.type == toDo.priority }
        self.priorityLabel.attributedText = self.priorityOptionToText(priorityOption!)
        
        let timingDescriptor = self.timingToDescriptor(toDo: toDo)
        self.timingLabel.text = timingDescriptor.title
        if timingDescriptor.dueDate != nil {
            self.dueDateLabel.text = Util.formatDate(timingDescriptor.dueDate!)
            self.isDueDateVisible = true
        }
        
        // bief
        if !self.model.isNew {
            self.descriptionText.text = toDo.notes
        }
        
        // miscellaneous
        if toDo.status == .done {
            self.completedLabel.text = Util.formatDate(toDo.completedDate!)
            self.toDoDoneSwitch.isOn = true
        }
        self.createdLabel.text = Util.formatDate(toDo.entryDate)
        
        self.updateSaveButtonState()
        
        self.toDoEntryTable.reloadData()
    }

    func toDoCancelled(toDo: ToDoItem) {
        if(self.presentingViewController is UINavigationController) {
            self.dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = self.navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ToDoEntryController is not inside a navigation controller.")
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageViewContoller = segue.destination as? ToDoImageViewController {
            imageViewContoller.toDoImage = sender as! UIImage
        }
        else if segue.destination is ToDoListViewController {
            model.saveToDo()
        }
    }

    // MARK: Action handlers
    
    @IBAction func toDoDoneStatusChanged(_ sender: Any) {
        let completedDate = self.toDoDoneSwitch.isOn ? Date() : nil
        self.currentToDo.completedDate = completedDate
        self.completedLabel.text = completedDate != nil
                                        ? Util.formatDate(completedDate!)
                                        : nil
        self.refreshTableView()
    }
    
    @IBAction func cancelDataEntry(_ sender: UIBarButtonItem) {
        model.cancelToDo()
    }

    // MARK: Utility methods
    
    private func togglePriorityPicker() {
        self.isDueDatePickerVisible = false
        
        if self.isPriorityPickerVisible {
            let selectedIndex = self.priorityPicker.selectedRow(inComponent: 0)
            let priorityOption = self.priorities[selectedIndex]
            self.currentToDo.priority = priorityOption.type
            self.priorityLabel.attributedText = self.priorityOptionToText(priorityOption)
        }
        else {
            let selectedIndex = self.priorities.index(where: { $0.type == self.currentToDo.priority})
            if let index = selectedIndex {
                self.priorityPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        self.isPriorityPickerVisible = !self.isPriorityPickerVisible
        self.refreshTableView()
    }
    
    private func toggleDueDatePicker() {
        self.isPriorityPickerVisible = false
        
        if self.isDueDatePickerVisible {
            self.currentToDo.timing = .dueDate(self.dueDatePicker.date)
            self.dueDateLabel.text = Util.formatDate(self.dueDatePicker.date)
        }
        else {
            self.dueDatePicker.setDate(self.currentToDo.dueDate ?? Date(), animated: false)
        }
        
        self.isDueDatePickerVisible = !self.isDueDatePickerVisible
        self.refreshTableView()
     }
    
    private func refreshTableView() {
        self.toDoEntryTable.beginUpdates()
        self.toDoEntryTable.endUpdates()
    }
    
    private func updateSaveButtonState() {
        self.saveBarButton.isEnabled = !((self.toDoTitleText.text?.isEmpty)!)
    }
    
    private func priorityOptionToText(_ option : (title:String, color: UIColor, type: Priority)) -> NSAttributedString {
        return
            NSAttributedString(string: option.title,
                                attributes: [NSForegroundColorAttributeName : option.color])
    }
    
    private func timingToDescriptor(toDo:ToDoItem) -> (title:String, dueDate:Date?) {
        for (title, timing) in self.timings {
            switch (timing, toDo.timing) {
                case (.dueDate(_), .dueDate(let dueDate)):
                    return (title: title, dueDate: dueDate)
                case (.immediate, .immediate):
                    return (title: title, dueDate: nil)
                case (.unspecified, .unspecified):
                    return (title: title, dueDate: nil)
                default:
                    break
            }
        }
        
        return (title: "", dueDate: nil)
    }
}

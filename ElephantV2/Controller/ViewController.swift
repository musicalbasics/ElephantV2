//
//  ViewController.swift
//  ElephantV2
//
//  Created by Lionel Yu on 11/27/22.
//

import UIKit

let model = Model()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var currentSelection: Item = Item(title: "Placeholder", timeDone: Date(), project: "None", uniqueNum: 0, status: "Active")
    var currentIndx = 0
    var numItemsShown = 1
    
    @IBOutlet weak var itemTableView: UITableView!
    
    @IBOutlet weak var firstThreeButtons: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        model.loadItems()
        
//        NSLayoutConstraint.activate([
//            firstThreeButtons.topAnchor.constraint(equalTo: topAnchor),
//            firstThreeButtons.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
//            firstThreeButtons.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//            firstThreeButtons.bottomAnchor.constraint(equalTo: itemTableView.topAnchor)
//        ])
        
        
        currentSelection = model.activeArray[0]
        
        
        itemTableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
//        itemTableView.register(UINib(nibName: "TestCell", bundle: nil), forCellReuseIdentifier: "testCell")
//        itemTableView.allowsSelection = false
        
        
        
        
//        itemTableView.delegate = self
//        itemTableView.dataSource = self
        
//
//        let insertArray = [
//        Item(title: "Insert 1 Item", timeDone: Date(), project: "Terrible", uniqueNum: 16, status: "Inact"),
//        Item(title: "Insert 2 Item", timeDone: Date(), project: "Terrible", uniqueNum: 17, status: "Inact"),
//        Item(title: "Insert 3 Item", timeDone: Date(), project: "Terrible", uniqueNum: 18, status: "Inact"),
//        Item(title: "Insert 4 Item", timeDone: Date(), project: "Terrible", uniqueNum: 19, status: "Inact"),
//        Item(title: "Insert 5 Item", timeDone: Date(), project: "Terrible", uniqueNum: 20, status: "Inact")
//        ]
//
//        model.inactiveArray = model.inactiveArray + insertArray
//        var completeRate = 3
//        var currentDeadline = Date()
        
        
        let currentDeadline2 = Calendar.current.date(byAdding: .day, value: 6, to: Date())
        let newProj = Project(name: "Terrible", completed: false, priority: 4, cycle: false, deadline: currentDeadline2)
        let insertMe = newProj.name
        model.projectArray.append(newProj)
        
//        model.insertProject(deadline: currentDeadline2!, proj: insertMe)
//        model.connectLevel(proj: "Piano")
        print(model.activeArray)
//        let myItem = model.activeArray[0]
//        model.splitAndKick(currentItem: myItem)
//        model.discardProject(proj: "Piano")
//        let anItem = model.activeArray[2]
//        model.deleteAndQuicken(chosenItem: anItem)
//        model.activateNextItem()
        print(model.activeArray)
        model.saveItems()
        
        model.backupPlistFiles()
    }
    
    
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        self.itemTableView.reloadData()
    }
    
    
//MARK: - top 3 items
    
    @IBAction func addItem(_ sender: UIButton) {
        var textField = UITextField()
        textField.delegate = self
        let alert = UIAlertController(title: "Add Item With None Project", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item With None Project", style: .default) { (action) in
            let tempTitle = textField.text!
            model.addItemNoneProject(itemTitle: tempTitle)
            model.saveItems()
//            print(model.inactiveArray)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add Item Here"
            textField = alertTextField
        }
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("Cancelled")
        })
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editItem(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Edit Current Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Edit This Item", style: .default) { (action) in
            var newItem = self.currentSelection
            newItem.title = textField.text!
            model.activeArray[self.currentIndx] = newItem
            model.saveItems()
            self.itemTableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = model.activeArray[self.currentIndx].title
            textField = alertTextField
        }
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("Cancelled")
        })
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func completeItem(_ sender: UIButton) {
        let tempNum = self.currentSelection.uniqueNum
        model.completeItem(uniqueNumba: tempNum)
        model.activateNextItem()
        model.saveItems()
        self.itemTableView.reloadData()
        self.currentSelection = model.activeArray[0]
        
    }
    
    
//MARK: - second row items
    
    //undo add pressed
    @IBAction func undoAdd(_ sender: UIButton) {
        model.undoAddItem()
        let alert = UIAlertController(title: "Last File Added Removed.", message: "", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    //show two items
    
    @IBAction func showMore(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Choose Number Of Items Shown", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Choose Number Of Items Shown", style: .default) { (action) in
            let numItemsSelected = textField.text!
            let intNumItemsSelected = Int(numItemsSelected)
            self.numItemsShown = intNumItemsSelected!
            self.itemTableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Integer"
            textField = alertTextField
        }
        alert.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("Cancelled")
        })
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    //undo item completed
    
    @IBAction func undoComplete(_ sender: UIButton) {
//        let currentSavedItemsCount = model.savedItems.count
//        model.activeArray.insert(model.savedItems[(currentSavedItemsCount - 1)], at: 0)
//        model.savedItems.remove(at: (currentSavedItemsCount - 1))
//        model.activeArray[0].status = "Active"
//        model.saveItems()
        model.uncompleteItem()
        self.itemTableView.reloadData()
        self.currentSelection = model.activeArray[0]
        
        let alert = UIAlertController(title: "Previous Task Uncompleted.", message: "", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
        
    }
    
//MARK: - Third row items
    
    //split and kick
    
    @IBAction func splitAndKick(_ sender: UIButton) {
//        let myItem = currentSelection
        model.splitAndKick(currentItem: currentSelection, currentIndx: currentIndx)
        model.saveItems()
        self.itemTableView.reloadData()
    }
    
    
    
    
    
    //show Item project
    
    //snip and quick
    
    
    
    
    
//MARK: - Fourth Row Items
    
    
    
    
    
//MARK: - table view methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return model.activeArray.count
        return numItemsShown
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemTableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ItemCell
        cell.titleLabel.text = model.activeArray[indexPath.row].title
        cell.titleLabel?.numberOfLines = 0;
        cell.titleLabel?.lineBreakMode = .byWordWrapping;

        cell.projLabel.text = model.activeArray[indexPath.row].project
        cell.projLabel?.numberOfLines = 0;
        cell.projLabel?.lineBreakMode = .byWordWrapping;
//        cell.selectionStyle = .none
        
//        cell.compLabel.addTarget(self, action: #selector(self.completePressed(_:)), for: UIControl.Event.touchUpInside)
//        cell.compLabel.tag = indexPath.row
//
//        cell.editLabel.addTarget(self, action: #selector(self.editPressed(_:)), for: UIControl.Event.touchUpInside)
//        cell.editLabel.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelection = model.activeArray[indexPath.row]
        currentIndx = indexPath.row
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func completePressed(_ sender: UIButton) {
        print(sender.tag)
        print("holler")
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        print(sender.tag)
        print("hola")
    }
    
    
    
    

//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header : TestCell = itemTableView.dequeueReusableCell(withIdentifier: "testCell") as! TestCell
//        header.compLabel.addTarget(self, action: #selector(self.completePressed(_:)), for: UIControl.Event.touchUpInside)
//        header.compLabel.tag = section
//
//
//        header.editLabel.addTarget(self, action: #selector(self.editPressed(_:)), for: UIControl.Event.touchUpInside)
//        header.editLabel.tag = section
//        return header
//
//    }

}

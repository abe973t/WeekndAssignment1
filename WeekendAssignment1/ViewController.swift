//
//  ViewController.swift
//  WeekendAssignment1
//
//  Created by mcs on 1/24/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TaskCreatedDelegate, TableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createNewBtn: UIButton!
    
    var tasks: [Task] = []
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.init(hex: "#2c3e50")
        
        self.title = "Current Tasks"
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            if key.contains("__") {
                do {
                    let task = try PropertyListDecoder().decode(Task.self, from: value as! Data)
                    
                    if !task.isComplete {
                        tasks.append(task)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func taskCompleted(index: IndexPath) {
        tasks[index.row].isComplete = true
        var task = tasks[index.row]
        task.isComplete = true
        
        UserDefaults.standard.set(try! PropertyListEncoder().encode(task), forKey: "__\(task.title)")
        tasks = tasks.filter({ return $0.isComplete == false })
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func createNewPressed(_ sender: Any) {
        let VC = storyboard?.instantiateViewController(withIdentifier: "createNew") as! CreateNewTaskVC
        VC.taskCreatedDelegate = self
        present(VC, animated: true, completion: nil)
    }

    func didCreateTask(title: String, desc: String, date: Date) {
        let task = Task(title: title, desc: desc, date: date, isComplete: false)
        tasks.append(task)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        UserDefaults.standard.set(try! PropertyListEncoder().encode(task), forKey: "__\(task.title)")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            defaults.removeObject(forKey: "__\(tasks[indexPath.row].title)")
            
            tasks.remove(at: indexPath.row)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.displayTask(task: tasks[indexPath.row])
        cell.delegate = self
        
        // midnight blue & peter river
        cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.init(hex: "#2c3e50") : UIColor.init(hex: "#bdc3c7")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
}


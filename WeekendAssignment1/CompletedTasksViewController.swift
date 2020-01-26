//
//  CompletedTasksViewController.swift
//  WeekendAssignment1
//
//  Created by mcs on 1/25/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit
import CoreData

class CompletedTasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var tasks: [Task] = []
    let df = DateFormatter()
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Completed"

        df.dateFormat = "MM-dd-yyyy hh:mm"
        
        tableView.backgroundColor = UIColor.init(hex: "#2c3e50")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tasks = []
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            if key.contains("__") {
                do {
                    let task = try PropertyListDecoder().decode(Task.self, from: value as! Data)
                    
                    if task.isComplete {
                        tasks.append(task)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")

        cell?.textLabel?.text = tasks[indexPath.row].title
        cell?.detailTextLabel?.text =  df.string(from: tasks[indexPath.row].date)
        cell?.backgroundColor = .clear
        
        return cell ?? UITableViewCell()
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
}

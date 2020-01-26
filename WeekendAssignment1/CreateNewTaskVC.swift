//
//  CreateNewTaskVC.swift
//  WeekendAssignment1
//
//  Created by mcs on 1/24/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit

protocol TaskCreatedDelegate {
    func didCreateTask(title: String, desc: String, date: Date)
}

struct Task: Codable {
    var title: String
    var desc: String
    var date: Date
    var isComplete: Bool
}

class CreateNewTaskVC: UIViewController {
    
    var taskCreatedDelegate: TaskCreatedDelegate!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func signUpTapped(_ sender: UIButton) {
        taskCreatedDelegate.didCreateTask(title: titleTextField.text ?? "No Title man", desc: descTextView.text ?? "Nothing here", date: datePicker.date)
        
        dismiss(animated: true, completion: nil)
    }
}

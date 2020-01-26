//
//  TableViewCell.swift
//  WeekendAssignment1
//
//  Created by mcs on 1/24/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit

protocol TableViewCellDelegate {
    func taskCompleted(index: IndexPath)
}

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    var delegate: TableViewCellDelegate?
    let df = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
            
        df.dateFormat = "MM-dd-yyyy hh:mm"
        // Belize Hole
        completeButton.backgroundColor = UIColor.init(hex: "#3498db")
    }

    @IBAction func completeButtonTapped(sender: UIButton) {
        delegate?.taskCompleted(index: getIndexPath()!)
    }
    
    func displayTask(task: Task) {
        titleLabel.text = task.title
        descLabel.text = task.desc
        
        dueDateLabel.textColor = task.date < Date() ? .red : .black
        dueDateLabel.text = df.string(from: task.date)
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UITableView else {
            print("superview is not a UITableView - getIndexPath")
            return nil
        }
        
        return superView.indexPath(for: self)
    }
}

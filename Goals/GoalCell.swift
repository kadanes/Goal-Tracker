//
//  GoalCell.swift
//  Goals
//
//  Created by Parth Tamane on 29/03/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var status: UILabel!
    
    func configurecell(goal: Dictionary<String,String>) {
        
        title.text = goal["title"] ?? "NIL"
        desc.text = goal["desc"] ?? "NIL"
        status.text = goal["status"] ?? "NIL"
        
    
        let startTimestamp = Double(goal["starts"]  ?? "0") ?? 0
        let endTimestamp = Double(goal["ends"] ?? "0") ?? 0
    
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd/MM/YY"
        
        let startDate = Date(timeIntervalSince1970: startTimestamp)
        let endDate = Date(timeIntervalSince1970: endTimestamp)

        
        let start = dateformatter.string(from: startDate)
        let end = dateformatter.string(from: endDate)
        
        duration.text = "\(start)-\(end)"
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  UpdateGoalVC.swift
//  Goals
//
//  Created by Parth Tamane on 28/03/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit
import Eureka
import FirebaseDatabase

class UpdateGoalVC: FormViewController {

    
    var goal = Dictionary<String,String>()
    
    var ID = ""
    
    var statusSection =  SelectableSection<ListCheckRow<String>>()
    var titleRow = TextRow()
    var descriptionRow = TextRow()
    var startDateRow = DateInlineRow()
    var endDateRow = DateInlineRow()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        titleRow = TextRow() { row in
            row.title = "Title"
            row.placeholder = "Enter goal name"
            row.tag = "title"
            row.value = goal["title"]
        }

        descriptionRow = TextRow() { row in
           
            row.title = "Description"
            row.placeholder = "Enter description name"
            row.tag = "description"
            row.value = goal["desc"]
            
        }
        
        startDateRow = DateInlineRow("Starts") {
            $0.title = $0.tag
            $0.tag = "Stars"
            
            if let  start = goal["starts"]  {
                
                let timestamp = Double(start)!
                
                $0.value = Date(timeIntervalSince1970: timestamp)
                
            } else {
               $0.value = Date()
            }
            
            
        }
        
        
        
        endDateRow = DateInlineRow("Ends"){
            $0.title = $0.tag
            $0.tag = "Ends"
            if let  ends = goal["ends"]  {
                
                let timestamp = Double(ends)!
                
                $0.value = Date(timeIntervalSince1970: timestamp)
                
            } else {
                $0.value = Date()
            }
            
        }
        
        
        statusSection = SelectableSection<ListCheckRow<String>>("What's the goal status?", selectionType: .singleSelection(enableDeselection: false))
        
        form +++ Section("Details")
        
            
            
            <<< titleRow
        
            <<< descriptionRow
        
            <<< startDateRow
            
            <<< endDateRow
        
            +++ statusSection
        
        let status = ["Started","In Progress", "Done", "Not Done"]
        
        for option in status {
            form.last! <<< ListCheckRow<String>(option){ listRow in
                listRow.title = option
                listRow.selectableValue = option
               
                if ( option == goal["status"]   ) {
                     listRow.value = "true"
                } else {
                    listRow.value = nil
                }
            }
        }
        
       form +++ Section("")
            
            <<< ButtonRow() { (row: ButtonRow) -> Void in
                row.title = "Submit"
                }
                .onCellSelection { [weak self] (cell, row) in
                    self?.submitGoal()
                }
    }
    
    func submitGoal() {
       
        goal["title"] = titleRow.value
        goal["desc"] = descriptionRow.value
        goal["status"] = statusSection.selectedRow()?.value
        goal["starts"] = getTimestamp(startDateRow.value ?? Date())
        goal["ends"] = getTimestamp(endDateRow.value ?? Date())
    
        if goal["title"] == "" || goal["desc"] == "" {
            self.navigationController?.popViewController(animated: true)
            return
        }
 
        
        if goal["ID"] == nil {
            
            print("New goal being added")
            
            let key = GOALS_ROOT.childByAutoId().key
            goal["ID"] = key
            GOALS_ROOT.child(key).setValue(goal)

        } else {
            let key = goal["ID"] ?? "0"
            GOALS_ROOT.child(key).setValue(goal)
            
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getTimestamp(_ date: Date)  -> String {
        
       
        
        let timestamp = String((Double((date.timeIntervalSince1970))).rounded())
        
        return timestamp
    }
}

//
//  UpdateGoalVC.swift
//  Goals
//
//  Created by Parth Tamane on 28/03/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit
import Eureka

class UpdateGoalVC: FormViewController {

    
    var goal = Dictionary<String,String>()
    
    var ID = ""
    
    var statusSection =  SelectableSection<ListCheckRow<String>>()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        form +++ Section("Details")
        
            <<< TextRow() { row in
                    row.title = "Title"
                    row.placeholder = "Enter goal name"
                    row.tag = "title"
                    row.value = goal["title"]
                }.onChange({ (row) in
                    
                    print("Title: ",row.value)
                    
                    self.goal["title"] =  row.value!
                })
            
        
            <<< TextRow() { row in
                    row.title = "Description"
                    row.placeholder = "Enter description name"
                    row.tag = "description"
                    row.value = goal["description"]
                
                }.onChange({ (row) in
                    
                    print("Description: ",row.value)
                    self.goal["description"] =  row.value!
                })
        
            <<< DateInlineRow("Starts") {
                $0.title = $0.tag
                $0.tag = "Stars"
                let timestamp = Double(goal["starts"]!) ?? 0
                
                $0.value = Date(timeIntervalSince1970: timestamp)
                }
                .onChange { [weak self] row in

                        let timestamp = String((Double((row.value?.timeIntervalSince1970)!) * 1000.0 ).rounded())
                    
                        self?.goal["starts"] = timestamp
                    
//                    if (timestamp < self?.goal["ends"] ?? "0") {
//
//                            self?.goal["start"] = timestamp
//                            row.cell!.backgroundColor = .white
//
//                    } else {
//                        row.cell.backgroundColor = .red
//                    }
                    
                }
            
            <<< DateInlineRow("Ends"){
                $0.title = $0.tag
                $0.tag = "Ends"
                let timestamp = Double(goal["ends"]! ) ?? 0
                
                $0.value = Date(timeIntervalSince1970: timestamp)
                
                }
                .onChange { [weak self] row in
    
                    var timestamp = String((Double((row.value?.timeIntervalSince1970)!) * 1000.0 ).rounded())
                    
                    self?.goal["ends"] = timestamp
                    
//                    if (timestamp > self?.goal["starts"] ?? "0") {
//
//                        self?.goal["start"] = timestamp
//                        row.cell!.backgroundColor = .white
//                    } else {
//                        row.cell.backgroundColor = .red
//                    }
                }
            

            statusSection = SelectableSection<ListCheckRow<String>>("What's the goal status?", selectionType: .singleSelection(enableDeselection: false))
        
            form +++ statusSection
        
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
        
        goal["status"] = statusSection.selectedRow()?.value
        print(goal)
        
    }
}

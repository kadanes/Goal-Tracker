//
//  Goals.swift
//  Goals
//
//  Created by Parth Tamane on 28/03/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Goals: UIViewController {
    
    var allGoals = [Dictionary<String,String>]()
    var startedGoals = [Dictionary<String,String>]()
    var progressingGoals = [Dictionary<String,String>]()
    var notDoneGoals = [Dictionary<String,String>]()
    var doneGoals = [Dictionary<String,String>]()
    
    @IBOutlet weak var goalCountLabel: UILabel!
    
    var currentStatus = "All"
    
    @IBOutlet weak var goalsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchGoals()
        
        goalsTableView.delegate = self
        goalsTableView.dataSource = self
        
    }

   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }


    @IBAction func addGoalTapped(_ sender: Any) {
        
        let emptyGoal = Dictionary<String,String>()
    
        performSegue(withIdentifier: "AddGoal", sender: emptyGoal)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "AddGoal" == segue.identifier {
            
            if let destination = segue.destination as? UpdateGoalVC, let goal = sender as? Dictionary<String,String> {
                
                destination.goal = goal
               
            }
            
        }
        
        if "EditGoal" == segue.identifier {
            
            if let destination = segue.destination as? UpdateGoalVC, let goal = sender as? Dictionary<String,String> {
                
                destination.goal = goal
                
            }
            
        }
    }
    
    func fetchGoals() {
      
        GOALS_ROOT.observe(.value) { (snapshot) in
            
            self.allGoals.removeAll()
            self.progressingGoals.removeAll()
            self.startedGoals.removeAll()
            self.doneGoals.removeAll()
            self.notDoneGoals.removeAll()
            
            if let value = snapshot.value as? Dictionary<String,Any> {
          
                for (_,goal) in value {
                    
                    if let goal = goal as? Dictionary<String,String> {
                        
                        self.allGoals.append(goal)
                        
                        if let status = goal["status"] {
                          
                            switch status {
                                
                            case "Started": self.startedGoals.append(goal)
                            case "In Progress": self.progressingGoals.append(goal)
                            case "Done": self.doneGoals.append(goal)
                            case "Not Done": self.notDoneGoals.append(goal)
                            default: break
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
            print("All data is: ",self.allGoals)
            
            self.goalsTableView.reloadData()
            self.updateCount()
        }
        
    }

    @IBAction func changeStatus(_ sender: UISegmentedControl) {
        
        currentStatus =  sender.titleForSegment(at: sender.selectedSegmentIndex)!
        
        goalsTableView.reloadData()
        updateCount()
    }
    
    func updateCount() {
        var count = 0
        switch currentStatus {
        case "All": count = allGoals.count
        case "Started": count = startedGoals.count
        case "In Progress": count =  progressingGoals.count
        case "Done": count = doneGoals.count
        case "Not Done": count = notDoneGoals.count
        default: count = 0
            
        }
        
        goalCountLabel.text = "Total: \(count)"
        
    }
}

extension Goals: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch currentStatus {
        case "All": return allGoals.count
        case "Started": return startedGoals.count
        case "In Progress": return progressingGoals.count
        case "Done": return doneGoals.count
        case "Not Done": return notDoneGoals.count
        default: return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        var goal = getCurrentGoal(index: indexPath.row)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell {
            
            cell.configurecell(goal: goal)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = getCurrentGoal(index: indexPath.row)
        
        performSegue(withIdentifier: "EditGoal", sender: goal)
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { (action, index) in
            
            
            let goal = self.getCurrentGoal(index: index.row)
            
            GOALS_ROOT.child(goal["ID"]!).removeValue()
        
        }
    
        return [remove]
    }
    
    func getCurrentGoal(index: Int) -> Dictionary<String,String> {
        switch currentStatus {
        case "All": return allGoals[index]
        case "Started": return startedGoals[index]
        case "In Progress": return progressingGoals[index]
        case "Done": return doneGoals[index]
        case "Not Done": return notDoneGoals[index]
        default: return Dictionary< String,String>()
    }
    
}
    

}

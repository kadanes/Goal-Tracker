//
//  Goals.swift
//  Goals
//
//  Created by Parth Tamane on 28/03/18.
//  Copyright © 2018 Parth Tamane. All rights reserved.
//

import UIKit

class Goals: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        
        var emptyGoal = Dictionary<String,String>()
        
        emptyGoal["title"] = ""
        emptyGoal["description"] = ""
        emptyGoal["starts"] = ""
        emptyGoal["ends"] = ""
        emptyGoal["status"] = "Not Done"
        
        performSegue(withIdentifier: "AddGoal", sender: emptyGoal)
    }
    
    @IBAction func addGoal1(_ sender: Any) {
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if "AddGoal" == segue.identifier {
            
            if let destination = segue.destination as? UpdateGoalVC, let goal = sender as? Dictionary<String,String> {
                
                destination.goal = goal
                destination.ID = "0"
                
            }
            
        }
    }

}


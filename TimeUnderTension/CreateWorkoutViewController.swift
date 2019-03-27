//
//  CreateWorkoutViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class CreateWorkoutViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create Workout"
        view.backgroundColor = .white
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightNavBarTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightNavBarTapped() {
        navigationController?.pushViewController(AddExerciseViewController(), animated: true)
    }
}

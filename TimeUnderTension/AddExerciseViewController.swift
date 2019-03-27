//
//  AddExerciseViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController {
    
    private let exerciseName = UITextField()
    private let weight = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Exercise"
        view.backgroundColor = .white
        
        setup()
    }
    
    func setup() {
        view.falsifyAutoresizingMask(for: exerciseName, weight)
        view.addSubviews(exerciseName, weight)
        
        exerciseName.text = "Exercise"
        exerciseName.textAlignment = .center
        weight.text = "KG"
        weight.textAlignment = .center
        
        let constraints: [NSLayoutConstraint] = [
            exerciseName.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0),
            exerciseName.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            exerciseName.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weight.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weight.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weight.topAnchor.constraint(equalTo: exerciseName.bottomAnchor, constant: 15.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

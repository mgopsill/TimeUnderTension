//
//  FirstViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 28/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    private let createWorkoutButton = UIButton()
    private let defaultWorkoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create Workout"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setup()
    }
    
    private func setup() {
        view.addSubviews(createWorkoutButton, defaultWorkoutButton)
        
        createWorkoutButton.backgroundColor = .blue
        createWorkoutButton.setTitle("Create Workout", for: .normal)
        createWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        createWorkoutButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        
        defaultWorkoutButton.backgroundColor = .gray
        defaultWorkoutButton.setTitle("Default Big Five Workout", for: .normal)
        defaultWorkoutButton.translatesAutoresizingMaskIntoConstraints = false
        // TODO: Default Button
        // TODO: Load saved / historical workout
        
        let constraints: [NSLayoutConstraint] = [
            createWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60.0),
            createWorkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60.0),
            createWorkoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 3),
            createWorkoutButton.heightAnchor.constraint(equalToConstant: 60.0),
            
            defaultWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60.0),
            defaultWorkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60.0),
            defaultWorkoutButton.topAnchor.constraint(equalTo: createWorkoutButton.bottomAnchor, constant: 40.0),
            defaultWorkoutButton.heightAnchor.constraint(equalToConstant: 60.0),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func startTapped() {
        let createVC = CreateWorkoutViewController()
        navigationController?.pushViewController(createVC, animated: true)
    }
}

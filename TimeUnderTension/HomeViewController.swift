//
//  HomeViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 28/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create Workout"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setup()
    }
    
    private func setup() {
        let createWorkoutButton = Factory.Button.blueButton
        let defaultWorkoutButton = Factory.Button.blueButton
        
        view.addSubviews(createWorkoutButton, defaultWorkoutButton)
        view.falsifyAutoresizingMask(for: createWorkoutButton, defaultWorkoutButton)
        
        createWorkoutButton.setTitle("Create Workout", for: .normal)
        createWorkoutButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        
        defaultWorkoutButton.backgroundColor = .gray
        defaultWorkoutButton.setTitle("Default Big Five Workout", for: .normal)
        defaultWorkoutButton.addTarget(self, action: #selector(defaultTapped), for: .touchUpInside)
        
        let constraints: [NSLayoutConstraint] = [
            createWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Factory.Insets.leadingInset),
            createWorkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Factory.Insets.trailingInset),
            createWorkoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 3),
            createWorkoutButton.heightAnchor.constraint(equalToConstant: 60.0),
            
            defaultWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Factory.Insets.leadingInset),
            defaultWorkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Factory.Insets.trailingInset),
            defaultWorkoutButton.topAnchor.constraint(equalTo: createWorkoutButton.bottomAnchor, constant: 40.0),
            defaultWorkoutButton.heightAnchor.constraint(equalToConstant: 60.0),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func startTapped() {
        let createVC = CreateWorkoutViewController(exercises: nil)
        navigationController?.pushViewController(createVC, animated: true)
    }
    
    @objc func defaultTapped() {
        let createVC = CreateWorkoutViewController(exercises: Exercise.defaultBigFive)
        navigationController?.pushViewController(createVC, animated: true)
    }
}

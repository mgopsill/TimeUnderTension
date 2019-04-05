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
        
        title = "Home"
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setup()
    }
    
    private func setup() {
        let createWorkoutButton = Factory.Button.defaultButton(color: .blue)
        let defaultWorkoutButton = Factory.Button.defaultButton(color: .gray)
        let savedWorkoutsButton = Factory.Button.defaultButton(color: .orange)
        
        view.addSubviews(createWorkoutButton, defaultWorkoutButton, savedWorkoutsButton)
        view.falsifyAutoresizingMask(for: createWorkoutButton, defaultWorkoutButton, savedWorkoutsButton)
        
        createWorkoutButton.setTitle("Create Workout", for: .normal)
        createWorkoutButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        
        defaultWorkoutButton.backgroundColor = .gray
        defaultWorkoutButton.setTitle("Default Big Five Workout", for: .normal)
        defaultWorkoutButton.addTarget(self, action: #selector(defaultTapped), for: .touchUpInside)
        
        savedWorkoutsButton.setTitle("Saved Workouts", for: .normal)
        savedWorkoutsButton.addTarget(self, action: #selector(savedTapped), for: .touchUpInside)
        
        let constraints: [NSLayoutConstraint] = [
            createWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Factory.Insets.leadingInset),
            createWorkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Factory.Insets.trailingInset),
            createWorkoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height / 3),
            createWorkoutButton.heightAnchor.constraint(equalToConstant: 60.0),
            
            defaultWorkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Factory.Insets.leadingInset),
            defaultWorkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Factory.Insets.trailingInset),
            defaultWorkoutButton.topAnchor.constraint(equalTo: createWorkoutButton.bottomAnchor, constant: 40.0),
            defaultWorkoutButton.heightAnchor.constraint(equalToConstant: 60.0),
            
            savedWorkoutsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Factory.Insets.leadingInset),
            savedWorkoutsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Factory.Insets.trailingInset),
            savedWorkoutsButton.topAnchor.constraint(equalTo: defaultWorkoutButton.bottomAnchor, constant: 40.0),
            savedWorkoutsButton.heightAnchor.constraint(equalToConstant: 60.0),
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
    
    @objc func savedTapped() {
        let savedVC = SavedWorkoutsViewController()
        navigationController?.pushViewController(savedVC, animated: true)
    }
}

class SavedWorkoutsViewController: UITableViewController {
    
    let workoutsManager = WorkoutsManager()
    var workouts: [Workout] = []
    
    override func viewDidLoad() {
        title = "Workout"
        view.backgroundColor = .white
        workouts = workoutsManager.allWorkouts
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = workouts[indexPath.row].date.description
        cell.detailTextLabel?.text = workouts[indexPath.row].exercises[0].name
        return cell
    }
}

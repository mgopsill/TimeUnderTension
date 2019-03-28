//
//  CreateWorkoutViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class CreateWorkoutViewController: UITableViewController {
    
    private var exercises: [Exercise] = []
    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Workout"
        view.backgroundColor = .white
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightNavBarTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        
        startButton.backgroundColor = .blue
        startButton.setTitle("Start", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.addSubview(startButton)
        
        let constraints: [NSLayoutConstraint] = [
            startButton.leadingAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.leadingAnchor, constant: 40.0),
            startButton.trailingAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.trailingAnchor, constant: -40.0),
            startButton.heightAnchor.constraint(equalToConstant: 80.0),
            startButton.bottomAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.bottomAnchor, constant: -100.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        startButton.removeFromSuperview()
    }

    @objc func rightNavBarTapped() {
        let addController = AddExerciseViewController()
        addController.delegate = self
        navigationController?.pushViewController(addController, animated: true)
    }
    
    @objc func startTapped() {
        let timer = TimerViewController()
        
        var newArray: [Exercise] = []
        for (index, exercise) in exercises.enumerated() {
            if index != exercises.count - 1 {
                let rest = Exercise(name: "Rest", weight: 0.0, time: 0.0, isRest: true)
                newArray.append(exercise)
                newArray.append(rest)
            } else {
                newArray.append(exercise)
            }
        }
        
        timer.exercises = newArray
        navigationController?.pushViewController(timer, animated: true)
    }
}

extension CreateWorkoutViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
                return UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "UITableViewCell")
            }
            return cell
        }()
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "Exercise"
            cell.detailTextLabel?.text = "Weight"
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
            return cell
        } else {
            cell.textLabel?.text = exercises[indexPath.row - 1].name
            cell.detailTextLabel?.text = String(exercises[indexPath.row - 1].weight) + "kg"
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete && indexPath.row != 0 {
            self.exercises.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension CreateWorkoutViewController: AddExerciseDelegate {
    func didSaveExercise(exercise: Exercise) {
        exercises.append(exercise)
        tableView.reloadData()
    }
}

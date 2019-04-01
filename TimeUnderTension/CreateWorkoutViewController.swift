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
    private let startButton = Factory.Button.blueButton
    private var selectedCellIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Workout"
        view.backgroundColor = .white
        
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightNavBarTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        setupFloatingStartButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        constrainFloatingStartButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        startButton.removeFromSuperview()
    }
    
    private func setupFloatingStartButton() {
        startButton.setTitle("Start", for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
    }
    
    private func constrainFloatingStartButton() {
        UIApplication.shared.keyWindow?.addSubview(startButton)
        
        let constraints: [NSLayoutConstraint] = [
            startButton.leadingAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.leadingAnchor, constant: Factory.Insets.leadingInset),
            startButton.trailingAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.trailingAnchor, constant: Factory.Insets.trailingInset),
            startButton.heightAnchor.constraint(equalToConstant: 60.0),
            startButton.bottomAnchor.constraint(equalTo: UIApplication.shared.keyWindow!.bottomAnchor, constant: -100.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc func rightNavBarTapped() {
        displayEditExercise(with: nil)
    }
    
    @objc func startTapped() {
        let timerViewController = TimerViewController(exercises: exercises.asExercisesWithRest)
        navigationController?.pushViewController(timerViewController, animated: true)
    }
    
    private func displayEditExercise(with exercise: Exercise?) {
        guard let snap = UIApplication.shared.keyWindow!.snapshotView(afterScreenUpdates: true) else { return }
        let editExerciseViewController = EditExerciseViewController(exercise: exercise)
        editExerciseViewController.backingImageView = snap
        editExerciseViewController.delegate = self
        navigationController?.present(editExerciseViewController, animated: false, completion: nil)
    }
}

extension CreateWorkoutViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Stop using TableViewCell as header
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
            // TODO: Stop using TableViewCell as header
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row - 1
        displayEditExercise(with: exercises[indexPath.row - 1])
    }
    // TODO: Ability to edit exercise from this view controller
}

extension CreateWorkoutViewController: EditExerciseDelegate {
    func didSaveExercise(exercise: Exercise) {
        if let selectedCellIndex = selectedCellIndex {
            exercises[selectedCellIndex] = exercise
        } else {
            exercises.append(exercise)
        }
        tableView.reloadData()
    }
}

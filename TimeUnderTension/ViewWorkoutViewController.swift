//
//  ViewWorkoutViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 09/04/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit


class ViewWorkoutViewController: UITableViewController {
    
    private let titleString: String
    private var exercises: [Exercise]
    private var laps: [TimeInterval]
    private var selectedCellIndex: Int = 0
    
    // TODO: Handle just laps being saved
    init(titleString: String, exercises: [Exercise] = [], laps: [TimeInterval] = []) {
        self.exercises = exercises
        self.laps = laps
        self.titleString = titleString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        title = titleString
        tableView.register(ExerciseWeightTimeCell.self, forCellReuseIdentifier: ExerciseWeightTimeCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !exercises.isEmpty {
            return exercises.count
        } else {
            return laps.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
                return UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "UITableViewCell")
            }
            return cell
        }()
        
        if !exercises.isEmpty {
            guard let newCell = tableView.dequeueReusableCell(withIdentifier: ExerciseWeightTimeCell.identifier, for: indexPath) as? ExerciseWeightTimeCell else { return UITableViewCell() }
            newCell.configure(for: exercises[indexPath.row])
            return newCell
        } else {
            cell.textLabel?.text = laps[indexPath.row].asStopwatchString
            cell.detailTextLabel?.text = laps[indexPath.row].asStopwatchString
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !exercises.isEmpty else { return }
        selectedCellIndex = indexPath.row
        let exercise = exercises[selectedCellIndex]
        let vc = EditExerciseViewController(exercise: exercise)
        guard let snap = UIApplication.shared.keyWindow!.snapshotView(afterScreenUpdates: true) else { return }
        vc.backingImageView = snap
        vc.delegate = self
        navigationController?.present(vc, animated: false, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if exercises.isEmpty {
                self.laps.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                self.exercises.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}

extension ViewWorkoutViewController: EditExerciseDelegate {
    func didSaveExercise(exercise: Exercise) {
        exercises[selectedCellIndex] = exercise
        tableView.reloadData()
    }
}

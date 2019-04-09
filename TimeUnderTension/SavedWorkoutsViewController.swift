//
//  SavedWorkoutsViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 09/04/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit


class SavedWorkoutsViewController: UITableViewController {
    
    let workoutsManager = WorkoutsManager()
    var workouts: [Workout] = []
    lazy var dateFormatter: DateFormatter = {
        let it = DateFormatter()
        it.dateStyle = .full
        it.locale = Locale(identifier: "en_GB")
        return it
    }()
    
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
        cell.textLabel?.text = dateFormatter.string(from: workouts[indexPath.row].date)
        cell.detailTextLabel?.text = workouts[indexPath.row].exercises[0].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = workouts[indexPath.row]
        let titleString = dateFormatter.string(from: workout.date)
        let exercises = workout.exercises
        let vc = ViewWorkoutViewController(titleString: titleString, exercises: exercises)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.workouts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            // TODO: Actually delete
        }
    }
}

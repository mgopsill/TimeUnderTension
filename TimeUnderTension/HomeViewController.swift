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
}

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

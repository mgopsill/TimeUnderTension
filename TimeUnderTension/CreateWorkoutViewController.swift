//
//  CreateWorkoutViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class CreateWorkoutViewController: UITableViewController {
    
    private var exercises: [Exercise]
    private let startButton = Factory.Button.defaultButton(color: .blue)
    private var selectedCellIndex: Int?
    
    init(exercises: [Exercise]?) {
        self.exercises = exercises ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        selectedCellIndex = nil
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
        return exercises.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
                return UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "UITableViewCell")
            }
            return cell
        }()
        
        cell.textLabel?.text = exercises[indexPath.row].name
        cell.detailTextLabel?.text = String(exercises[indexPath.row].weight) + "kg"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.exercises.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndex = indexPath.row
        displayEditExercise(with: exercises[indexPath.row ])
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = WorkoutHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
            return headerView
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30.0
        } else {
            return 0.0
        }
    }
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


class WorkoutHeaderView: UIView {
    private let exerciseNameLabel = UILabel()
    private let weightLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        exerciseNameLabel.text = "Exercise Name"
        exerciseNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        weightLabel.text = "Weight"
        weightLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        addSubviews(exerciseNameLabel, weightLabel)
        falsifyAutoresizingMask(for: exerciseNameLabel, weightLabel)
        let constraints: [NSLayoutConstraint] = [
            exerciseNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            exerciseNameLabel.topAnchor.constraint(equalTo: topAnchor),
            exerciseNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            weightLabel.topAnchor.constraint(equalTo: topAnchor),
            weightLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            weightLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

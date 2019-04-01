//
//  TimerViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    private var stopWatch = Stopwatch()
    private var selectedCellIndex: Int = 0
    private var laps: [TimeInterval] = []
    private var exercises: [Exercise]
    
    private let timerLabel = UILabel()
    private let buttonsView = UIView()
    private let resetLapButton = UIButton()
    private let startStopButton = UIButton()
    private let tableView = UITableView()
    
    private let stopWatchDefaultString = 0.asStopwatchString
    
    init(exercises: [Exercise]? = nil) {
        self.exercises = exercises ?? []
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Workout Timer"
        view.backgroundColor = .white
        
        addViews()
        configureButtons()
        setupViews()
        setupConstraints()
        
        stopWatch.delegate = self
        
        // TODO: Handle closing app and restarting the timer at the current time 
    }
    
    private func addViews() {
        view.falsifyAutoresizingMask(for: timerLabel, buttonsView, resetLapButton, startStopButton, tableView)
        view.addSubviews(timerLabel, buttonsView, tableView)
    }
    
    private func configureButtons() {
        buttonsView.addSubview(resetLapButton)
        buttonsView.addSubview(startStopButton)

        resetLapButton.backgroundColor = .black
        resetLapButton.layer.cornerRadius = 50.0
        resetLapButton.layer.borderWidth = 0.1
        resetLapButton.layer.borderColor = UIColor.black.cgColor
        resetLapButton.assignDefaultButtonAnimation()
        resetLapButton.assignBlinkAnimation()
        startStopButton.backgroundColor = .black
        startStopButton.layer.cornerRadius = 50.0
        startStopButton.layer.borderWidth = 0.1
        startStopButton.layer.borderColor = UIColor.black.cgColor
        startStopButton.assignDefaultButtonAnimation()
        startStopButton.assignBlinkAnimation()
        
        resetLapButton.setTitle("Reset", for: .normal)
        resetLapButton.addTarget(self, action: #selector(resetStopwatch), for: .touchUpInside)
        
        startStopButton.setTitle("Start", for: .normal)
        startStopButton.setTitle("Stop", for: .selected)
        startStopButton.addTarget(self, action: #selector(startStopwatch), for: .touchUpInside)
    }
    
    private func setupViews() {
        setupTimerLabel()
        setupTableView()
    }
    
    private func setupTimerLabel() {
        timerLabel.text = stopWatchDefaultString
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 80.0)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "X")
        tableView.register(ExerciseWeightTimeCell.self, forCellReuseIdentifier: ExerciseWeightTimeCell.identifier)
    }
    
    private func setupConstraints() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = navigationController!.navigationBar.frame.height
        let constraints: [NSLayoutConstraint] = [
            timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + navHeight),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timerLabel.heightAnchor.constraint(equalToConstant: view.frame.height / 2.4),
            buttonsView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 5.0),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 100.0),
            resetLapButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor, constant: 20.0),
            resetLapButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            resetLapButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            resetLapButton.widthAnchor.constraint(equalToConstant: 100.0),
            startStopButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor, constant: -20.0),
            startStopButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            startStopButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            startStopButton.widthAnchor.constraint(equalToConstant: 100.0),
            tableView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 5.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func startStopwatch() {
        if stopWatch.state != .running {
            stopWatch.start()
            startStopButton.isSelected = true
            resetLapButton.setTitle("Lap", for: .normal)
        } else if stopWatch.state == .running {
            stopWatch.pause()
            startStopButton.isSelected = false
            resetLapButton.setTitle("Reset", for: .normal)
        }
    }
    
    @objc func resetStopwatch() {
        if stopWatch.state != .running {
            stopWatch.reset()
            laps.removeAll()
            tableView.reloadData()
        } else if stopWatch.state == .running {
            stopWatch.lap()
        }
    }
}

extension TimerViewController: StopwatchDelegate {
    func updateView(with interval: TimeInterval) {
        timerLabel.text = interval.asStopwatchString
        let numberOfCells = (!exercises.isEmpty ? exercises.count : laps.count) - 1
        if exercises.isEmpty {
            guard let cell = tableView.cellForRow(at: IndexPath(row: numberOfCells, section: 0)) else { return }
            cell.textLabel?.text = interval.asStopwatchString
            cell.detailTextLabel?.text = interval.asStopwatchString
        }
        guard let cell = tableView.cellForRow(at: IndexPath(row: numberOfCells, section: 0)) as? ExerciseWeightTimeCell else { return }
        var exercise = exercises[numberOfCells]
        exercise.time = interval
        cell.configure(for: exercise)
    }
    
    func handleLatestLap(interval: TimeInterval) {
        if laps.count < exercises.count {
            exercises[laps.count].time = interval
        }
        laps.append(interval)
        tableView.reloadData()
    }
}

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !exercises.isEmpty {
            return exercises.count
        } else {
            return laps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

extension TimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !exercises.isEmpty else { return }
        selectedCellIndex = indexPath.row
        let exercise = exercises[selectedCellIndex]
        let vc = EditExerciseViewController(exercise: exercise)
        guard let snap = UIApplication.shared.keyWindow!.snapshotView(afterScreenUpdates: true) else { return }
        vc.backingImageView = snap
        vc.delegate = self
        navigationController?.present(vc, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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

extension TimerViewController: EditExerciseDelegate {
    func didSaveExercise(exercise: Exercise) {
        exercises[selectedCellIndex] = exercise
        tableView.reloadData()
    }
}

extension UIButton {
    func assignBlinkAnimation() {
        addTarget(self, action: #selector(blink), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func blink() {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveLinear, .autoreverse], animations: {
            self.alpha = 0.5
        }, completion: { bool in
            self.alpha = 1.0
        })
    }
}

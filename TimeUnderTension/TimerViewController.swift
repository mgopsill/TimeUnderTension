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
    private var timer: Timer?
    
    private let timerLabel = UILabel()
    private let buttonsView = UIView()
    
    private let resetLapButton = UIButton()
    private let startStopButton = UIButton()
    
    private let tableView = UITableView()
    
    private let stopWatchDefaultString = 0.asStopwatchString
    
    private var laps: [TimeInterval] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Stopwatch"
        view.backgroundColor = .white
        
        addViews()
        configureButtons()
        setupViews()
        setupConstraints()
        
        stopWatch.delegate = self
    }
    
    private func addViews() {
        view.falsifyAutoresizingMask(for: timerLabel, buttonsView, resetLapButton, startStopButton, tableView)
        view.addSubviews(timerLabel, buttonsView, tableView)
    }
    
    private func configureButtons() {
        buttonsView.backgroundColor = .blue

        buttonsView.addSubview(resetLapButton)
        buttonsView.addSubview(startStopButton)
        
        resetLapButton.backgroundColor = .black
        startStopButton.backgroundColor = .black
        
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
        timerLabel.backgroundColor = .red
        timerLabel.text = stopWatchDefaultString
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 80.0)
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .gray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "X")
    }
    
    private func setupConstraints() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navHeight = navigationController!.navigationBar.frame.height
        let constraints: [NSLayoutConstraint] = [
            timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: statusBarHeight + navHeight),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timerLabel.heightAnchor.constraint(equalToConstant: view.frame.height / 2.4),
            buttonsView.topAnchor.constraint(equalTo: timerLabel.bottomAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonsView.heightAnchor.constraint(equalToConstant: 100.0),
            resetLapButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            resetLapButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            resetLapButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            resetLapButton.widthAnchor.constraint(equalToConstant: 100.0),
            startStopButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            startStopButton.topAnchor.constraint(equalTo: buttonsView.topAnchor),
            startStopButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            startStopButton.widthAnchor.constraint(equalToConstant: 100.0),
            tableView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
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
    }
    
    func handleLatestLap(interval: TimeInterval) {
        laps.append(interval)
        tableView.reloadData()
    }
}

extension TimerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
                return UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "UITableViewCell")
            }
            return cell
        }()
        
        cell.detailTextLabel?.text = laps[indexPath.row].asStopwatchString
        cell.textLabel?.text = laps[indexPath.row].asStopwatchString
        return cell
    }
}

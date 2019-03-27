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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Stopwatch"
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
        
        stopWatch.delegate = self
    }
    
    private func setupViews() {
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.backgroundColor = .red
        timerLabel.text = stringFromTimeInterval(interval: 0)
        timerLabel.textAlignment = .center
        timerLabel.font = UIFont.systemFont(ofSize: 80.0)
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.backgroundColor = .blue
        
        resetLapButton.translatesAutoresizingMaskIntoConstraints = false
        startStopButton.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(resetLapButton)
        buttonsView.addSubview(startStopButton)
        resetLapButton.backgroundColor = .black
        startStopButton.backgroundColor = .black
        
        resetLapButton.setTitle("Reset", for: .normal)
        resetLapButton.addTarget(self, action: #selector(resetStopwatch), for: .touchUpInside)

        startStopButton.setTitle("Start", for: .normal)
        startStopButton.addTarget(self, action: #selector(startStopwatch), for: .touchUpInside)
        
        tableView.backgroundColor = .gray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        view.addSubview(timerLabel)
        view.addSubview(buttonsView)
        view.addSubview(tableView)
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
            startStopButton.setTitle("Stop", for: .normal)
        } else if stopWatch.state == .running {
            stopWatch.pause()
            startStopButton.setTitle("Start", for: .normal)
        }
    }
    
    @objc func resetStopwatch() {
        if stopWatch.state != .running {
            stopWatch.reset()
            timerLabel.text = stringFromTimeInterval(interval: 0)
            startStopButton.setTitle("Start", for: .normal)
        }
    }
}

extension TimerViewController: StopwatchDelegate {
    func updateView(with seconds: TimeInterval) {
        timerLabel.text = stringFromTimeInterval(interval: seconds)
    }

    func stringFromTimeInterval(interval: TimeInterval) -> String {
        
        let ti = NSInteger(interval)
        
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 10)
        
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        
        return String(format: "%0.2d:%0.2d.%0.1d",minutes,seconds,ms)
    }
}

//
//  Stopwatch.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import Foundation

enum StopwatchState {
    case running
    case paused
    case notStarted
}

protocol StopwatchDelegate {
    func updateView(with interval: TimeInterval)
    func handleLatestLap(interval: TimeInterval)
}

class Stopwatch {
    var elapsedTime: TimeInterval = 0.0
    var timer = Timer()
    var state: StopwatchState = .notStarted
    var startDate: Date?
    var endDate: Date?
    var delegate: StopwatchDelegate?
    
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        state = .running
        if startDate == nil {
            startDate = Date()
        }
    }
    
    public func refresh() {
        if let startDate = startDate {
            elapsedTime = Date().timeIntervalSince(startDate)
        }
    }
    
    @objc private func updateTimer() {
        elapsedTime += 0.1
        delegate?.updateView(with: elapsedTime)
    }
    
    public func pause() {
        state = .paused
        timer.invalidate()
    }
    
    public func reset() {
        timer.invalidate()
        elapsedTime = 0.0
        state = .notStarted
        delegate?.updateView(with: elapsedTime)
    }
    
    public func lap() {
        delegate?.handleLatestLap(interval: elapsedTime)
        reset()
        start()
    }
}

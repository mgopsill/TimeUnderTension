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
    func updateView(with seconds: TimeInterval)
}

class Stopwatch {
    var seconds = 0
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
    
    @objc private func updateTimer() {
//        seconds += 1
        elapsedTime += 0.1
        if let delegate = delegate {
            delegate.updateView(with: elapsedTime)
        }
    }
    
    public func pause() {
        state = .paused
        timer.invalidate()
    }
    
    public func reset() {
        timer.invalidate()
        elapsedTime = 0.0
        state = .notStarted
    }
}

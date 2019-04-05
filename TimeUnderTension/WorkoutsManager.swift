//
//  WorkoutsManager.swift
//  TimeUnderTension
//
//  Created by devpair45 on 04/04/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import Foundation

struct Workout: Codable {
    let date: Date
    let exercises: [Exercise]
    
    var key: String {
        return DefaultsKeys.workout.format(date.timeIntervalSince1970.asStopwatchString)
    }
}

class WorkoutsManager {
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let defaults = UserDefaults.standard

    init() { }
    
    func save(_ workout: Workout) {
        let workoutKey = workout.key
        if let encoded = try? encoder.encode(workout) {
            var dictionary: [String: Data] = defaults.object(forKey: DefaultsKeys.workouts) as? [String: Data] ?? [:]
            dictionary[workoutKey] = encoded
            defaults.set(dictionary, forKey: DefaultsKeys.workouts)
        }
    }
        
    var allWorkouts: [Workout] {
        guard let dictionary = defaults.object(forKey: DefaultsKeys.workouts) as? [String: Data] else { return [] }
        let workouts = dictionary.compactMap { (_, data) -> Workout? in
            guard let workout = try? decoder.decode(Workout.self, from: data) else { return nil }
            return workout
        }
        return workouts
    }
    
    func clearAll() {
        defaults.removeObject(forKey: DefaultsKeys.workouts)
    }
}

enum DefaultsKeys {
    static let workouts = "Workouts"
    static let workout = "IndividualWorkoutForDate%@"
}

extension String {
    func format(_ arguments: CVarArg...) -> String {
        return String(format: self, arguments: arguments)
    }
}

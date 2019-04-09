//
//  Exercise.swift
//  TimeUnderTension
//
//  Created by devpair45 on 01/04/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import Foundation

class Exercise: Equatable, Codable {
    let name: String
    var weight: Double = 0.0
    var time: TimeInterval = 0.0
    var isRest: Bool = false
    
    init(name: String, weight: Double, time: TimeInterval, isRest: Bool) {
        self.name = name
        self.weight = weight
        self.time = time
        self.isRest = isRest
    }
    
    static var emptyExercise: Exercise {
        return Exercise(name: "Exercise Name", weight: 0.0, time: 0.0, isRest: false)
    }
    
    public static func ==(lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.name == rhs.name && lhs.weight == rhs.weight && lhs.time == rhs.time && lhs.isRest == rhs.isRest
    }
}

extension Array where Element == Exercise {
    var asExercisesWithRest: [Exercise] {
        var newArray: [Exercise] = []
        for (index, exercise) in self.enumerated() {
            if index != self.count - 1 {
                let rest = Exercise(name: "Rest", weight: 0.0, time: 0.0, isRest: true)
                newArray.append(exercise)
                newArray.append(rest)
            } else {
                newArray.append(exercise)
            }
        }
        return newArray
    }
}

extension Exercise {
    static var defaultBigFive: [Exercise] {
        let row = Exercise(name: "Row", weight: 50.0, time: 0.0, isRest: false)
        let chestPress = Exercise(name: "Chest Press", weight: 50.0, time: 0.0, isRest: false)
        let pullDown = Exercise(name: "Pull Down", weight: 50.0, time: 0.0, isRest: false)
        let overheadPress = Exercise(name: "Overhead Press", weight: 20.0, time: 0.0, isRest: false)
        let legPress = Exercise(name: "Leg Press", weight: 100.0, time: 0.0, isRest: false)
        return [row, chestPress, pullDown, overheadPress, legPress]
    }
}



// MARK: General TODOs
// TODO: Move Saved Workouts VC
// TODO: Saved Workouts TableView Control
// TODO: Redo UI for iPhone 6s

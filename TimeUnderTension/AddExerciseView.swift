//
//  AddExerciseView.swift
//  TimeUnderTension
//
//  Created by devpair45 on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

protocol EditExerciseDelegate {
    func didSaveExercise(exercise: Exercise)
}

class AddExerciseView: UIView {

    private let exerciseName = UITextField()
    private let weight = UITextField() // TODO: when updating weight only allow numbers
    private let saveButton = Factory.Button.blueButton
    
    var delegate: EditExerciseDelegate?
    var exercise: Exercise?
    
    init(exercise: Exercise?) {
        super.init(frame: CGRect.zero)

        self.exercise = exercise
        if let exercise = exercise {
            exerciseName.text = exercise.name
            weight.text = String(exercise.weight)
        }
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        falsifyAutoresizingMask(for: exerciseName, weight, saveButton)
        addSubviews(exerciseName, weight, saveButton)
        
        exerciseName.placeholder = "Exercise Name"
        exerciseName.textAlignment = .center
        weight.placeholder = "0.0kg"
        weight.textAlignment = .center
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let constraints: [NSLayoutConstraint] = [
            exerciseName.topAnchor.constraint(equalTo: topAnchor, constant: 100.0),
            exerciseName.leadingAnchor.constraint(equalTo: leadingAnchor),
            exerciseName.trailingAnchor.constraint(equalTo: trailingAnchor),
            weight.leadingAnchor.constraint(equalTo: leadingAnchor),
            weight.trailingAnchor.constraint(equalTo: trailingAnchor),
            weight.topAnchor.constraint(equalTo: exerciseName.bottomAnchor, constant: 15.0),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40.0),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40.0),
            saveButton.topAnchor.constraint(equalTo: weight.bottomAnchor, constant: 15.0),
            saveButton.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func saveTapped() {
        guard let exerciseName = exerciseName.text else { return }
        let exercise = Exercise(name: exerciseName, weight: Double(weight.text ?? "0.0") ?? 0.0, time: 0.0, isRest: false)
        delegate?.didSaveExercise(exercise: exercise)
    }
}

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

    private let titleLabel = UILabel()
    private let exerciseName = UITextField()
    private let weight = UITextField() // TODO: when updating weight only allow numbers
    private let saveButton = Factory.Button.defaultButton(color: .blue)
    private let kgSuffix = " kg"
    
    var delegate: EditExerciseDelegate?
    var exercise: Exercise?
    
    init(exercise: Exercise?) {
        super.init(frame: CGRect.zero)

        self.exercise = exercise
        if let exercise = exercise {
            exerciseName.text = exercise.name
            weight.text = String(exercise.weight) + kgSuffix
            titleLabel.text = "Edit Exercise"
        } else {
            titleLabel.text = "Add Exercise"
        }
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24.0)
        
        let exerciseLabel = UILabel()
        let weightLabel = UILabel()
        exerciseLabel.text = "Exercise"
        weightLabel.text = "Weight"
        
        falsifyAutoresizingMask(for: titleLabel, exerciseLabel, weightLabel, exerciseName, weight, saveButton)
        addSubviews(titleLabel, exerciseLabel, weightLabel, exerciseName, weight, saveButton)
        
        exerciseName.placeholder = "Exercise Name"
        exerciseName.textAlignment = .center
        exerciseName.delegate = self
        exerciseName.tintColor = .clear
        exerciseName.layer.borderWidth = 1.0
        exerciseName.layer.cornerRadius = 5.0
        exerciseName.layer.borderColor = UIColor.clear.cgColor
        
        weight.placeholder = "0.0" + kgSuffix
        weight.textAlignment = .center
        weight.keyboardType = .decimalPad
        weight.delegate = self
        weight.tintColor = .clear
        weight.layer.borderWidth = 1.0
        weight.layer.cornerRadius = 5.0
        weight.layer.borderColor = UIColor.clear.cgColor
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let constraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 40.0),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            exerciseLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.0),
            exerciseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Factory.Insets.leadingInset),
            exerciseLabel.heightAnchor.constraint(equalToConstant: 40.0),
            exerciseName.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40.0),
            exerciseName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Factory.Insets.trailingInset),
            exerciseName.leadingAnchor.constraint(equalTo: exerciseLabel.trailingAnchor, constant: 30.0),
            exerciseName.heightAnchor.constraint(equalToConstant: 40.0),
            weightLabel.topAnchor.constraint(equalTo: exerciseLabel.bottomAnchor, constant: 30.0),
            weightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Factory.Insets.leadingInset),
            weightLabel.widthAnchor.constraint(equalToConstant: 60.0),
            weightLabel.heightAnchor.constraint(equalToConstant: 40.0),
            weight.topAnchor.constraint(equalTo: exerciseName.bottomAnchor, constant: 30.0),
            weight.trailingAnchor.constraint(equalTo: trailingAnchor,  constant: Factory.Insets.trailingInset),
            weight.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 30.0),
            weight.heightAnchor.constraint(equalToConstant: 40.0),
            saveButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Factory.Insets.leadingInset),
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Factory.Insets.trailingInset),
            saveButton.topAnchor.constraint(equalTo: weight.bottomAnchor, constant: 40.0),
            saveButton.heightAnchor.constraint(equalToConstant: 40.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func saveTapped() {
        guard let exerciseName = exerciseName.text else { return }
        let weightText = weight.text ?? "0.0"
        let weighTextNoKG = weightText.replacingOccurrences(of: kgSuffix, with: "")
        let weightAsDouble = Double(weighTextNoKG) ?? 0.0
        let exercise = Exercise(name: exerciseName, weight: weightAsDouble, time: 0.0, isRest: false)
        delegate?.didSaveExercise(exercise: exercise)
    }
}

extension AddExerciseView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == self.weight, let oldTextWithoutKG = textField.text?.replacingOccurrences(of: kgSuffix, with: "") else { return true }
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                textField.text = oldTextWithoutKG.dropLast() + kgSuffix
                return false
            }
        }
        
        let newText = oldTextWithoutKG + string
        let isNumeric = newText.isEmpty || (Double(newText) != nil)
        let numberOfDots = newText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = newText.index(of: ".") {
            numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        if isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2 {
            textField.text = newText + kgSuffix
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            textField.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            textField.backgroundColor = .clear
        }
    }
}

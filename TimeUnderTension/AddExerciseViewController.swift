//
//  AddExerciseViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

struct Exercise {
    let name: String
    var weight: Double = 0.0
    var time: TimeInterval = 0.0
    var isRest: Bool = false
}

protocol AddExerciseDelegate {
    func didSaveExercise(exercise: Exercise)
}

class AddExerciseViewController: UIViewController, AddExerciseDelegate {
    
    private let addExerciseView = AddExerciseView(exercise: nil)
    
    var delegate: AddExerciseDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Exercise"
        view.backgroundColor = .white
        addExerciseView.delegate = self
        
        setup()
    }
    
    private func setup() {
        view.addSubviews(addExerciseView)
        view.falsifyAutoresizingMask(for: addExerciseView)
        
        let constraints: [NSLayoutConstraint] = [
            addExerciseView.topAnchor.constraint(equalTo: view.topAnchor),
            addExerciseView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            addExerciseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addExerciseView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func didSaveExercise(exercise: Exercise) {
        delegate?.didSaveExercise(exercise: exercise)
        navigationController?.popViewController(animated: true)
    }
}

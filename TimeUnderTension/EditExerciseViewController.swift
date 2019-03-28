//
//  EditExerciseViewController.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 28/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class EditExerciseViewController: UIViewController, AddExerciseDelegate {
    
    private let addExerciseView: AddExerciseView
    
    var delegate: AddExerciseDelegate?
    var exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
        self.addExerciseView = AddExerciseView(exercise: exercise)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Edit Exercise"
        view.backgroundColor = .clear
        addExerciseView.delegate = self
        addExerciseView.backgroundColor = .white
        
        setup()
    }
    
    private func setup() {
        view.addSubviews(addExerciseView)
        view.falsifyAutoresizingMask(for: addExerciseView)
        
        let constraints: [NSLayoutConstraint] = [
            addExerciseView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            addExerciseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            addExerciseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            addExerciseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func didSaveExercise(exercise: Exercise) {
        delegate?.didSaveExercise(exercise: exercise)
        dismiss(animated: true, completion: nil)
    }
}

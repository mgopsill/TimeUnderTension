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
    var backingImageView = UIView()

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
        addExerciseView.layer.borderColor = UIColor.gray.cgColor
        addExerciseView.layer.borderWidth = 2.0
        addExerciseView.layer.cornerRadius = 20.0
            
        setup()
    }
    
    var addc: [NSLayoutConstraint] = []
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.backingImageView.alpha = 0.8
            self.addc[0].constant = 100.0
            self.view.layoutIfNeeded()
        }
    }
    
    private func setup() {
        view.addSubviews(backingImageView)
        view.insertSubview(addExerciseView, aboveSubview: backingImageView)
        view.falsifyAutoresizingMask(for: addExerciseView, backingImageView)
        
        let constraints: [NSLayoutConstraint] = [
            backingImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        
        addc = [
            addExerciseView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height),
            addExerciseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            addExerciseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            addExerciseView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.8)
        ]
        NSLayoutConstraint.activate(addc)
        view.layoutIfNeeded()
    }
    
    func didSaveExercise(exercise: Exercise) {
        delegate?.didSaveExercise(exercise: exercise)
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.backingImageView.alpha = 1.0
            self.addc[0].constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { bool in
            self.dismiss(animated: false, completion: nil)
        }
        
    }
}

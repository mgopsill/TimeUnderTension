//
//  ExerciseWeightTimeCell.swift
//  TimeUnderTension
//
//  Created by devpair45 on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

class ExerciseWeightTimeCell: UITableViewCell {
    
    static let identifier = "XWT"
    
    private let exerciseNameLabel = UILabel()
    private let weightLabel = UILabel()
    private let timeLabel = UILabel()
    
    private let exercise: Exercise? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubviews(exerciseNameLabel, weightLabel, timeLabel)
        contentView.falsifyAutoresizingMask(for: exerciseNameLabel, weightLabel, timeLabel)
        
        let constraints: [NSLayoutConstraint] = [
            contentView.heightAnchor.constraint(equalToConstant: 44.0),
            exerciseNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            exerciseNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            exerciseNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            weightLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weightLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            weightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(for exercise: Exercise) {
        exerciseNameLabel.text = exercise.name
        weightLabel.text = exercise.weight.asWeightString
        timeLabel.text = exercise.time.asStopwatchString
    }
}

extension Double {
    var asWeightString: String {
        return self == 0.0 ? "" : String(self) + " kg"
    }
}

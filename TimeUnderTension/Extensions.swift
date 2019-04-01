//
//  UI+Extensions.swift
//  TimeUnderTension
//
//  Created by Mike Gopsill on 27/03/2019.
//  Copyright © 2019 Mike Gopsill. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func falsifyAutoresizingMask(for views: UIView...) {
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
    }
}

extension TimeInterval {
    var asStopwatchString: String {
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 10)
        let ti = Int(self)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        return String(format: "%0.2d:%0.2d.%0.1d",minutes,seconds,ms)
    }
}

struct Factory {
    
    struct Insets {
        static let leadingInset: CGFloat = 50.0
        static let trailingInset: CGFloat = -50.0
    }
    
    struct Button {        
        static var blueButton: UIButton {
            let blueButton = UIButton()
            blueButton.backgroundColor = .blue
            blueButton.layer.borderColor = UIColor.blue.cgColor
            blueButton.layer.borderWidth = 0.5
            blueButton.layer.cornerRadius = 5.0
            return blueButton
        }
    }
}

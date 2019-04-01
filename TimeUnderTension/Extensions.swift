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
        static func defaultButton(color: UIColor) -> UIButton {
            let defaultButton = UIButton()
            defaultButton.backgroundColor = color
            defaultButton.layer.borderColor = color.cgColor
            defaultButton.layer.borderWidth = 0.5
            defaultButton.layer.cornerRadius = 5.0
            defaultButton.assignDefaultButtonAnimation()
            return defaultButton
        }
    }
}

extension UIButton {
    
    func assignDefaultButtonAnimation() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
        }, completion: nil)
    }
}

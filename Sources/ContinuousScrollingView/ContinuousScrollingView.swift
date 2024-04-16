//
//  ContinuousScrollingView.swift
//
//
//  Created by Deniz Yüce on 24.03.2024.
//

import UIKit

final class ContinuousScrollingView: UIView {
    
    var textToScroll = ""
    var font: UIFont =  UIFont.systemFont(ofSize: 14.0)
    var textColor: UIColor = .black
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    func startAnimations() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.setupScrollView()
        }
    }
    
    private func setupScrollView() {
        self.removeAllSubviews()
        
        let scrollView = UIScrollView()
        let movingLabelFirstPart = UILabel()
        let movingLabelSecondContinious = UILabel()
        
        scrollView.removeFromSuperview()
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        self.setUpTexts(movingLabelFirstPart: movingLabelFirstPart, movingLabelSecondContinious: movingLabelSecondContinious, scrollView: scrollView)
        self.startScrolling(movingLabelFirstPart: movingLabelFirstPart, movingLabelSecondContinious: movingLabelSecondContinious, scrollView: scrollView)
    }
    
    private func setUpTexts(movingLabelFirstPart: UILabel, movingLabelSecondContinious: UILabel, scrollView: UIScrollView) {
        let screenSize = bounds.width
        var repeatedText = textToScroll
        while repeatedText.width(withConstrainedHeight: 32, font: font) < screenSize * 2 {
            repeatedText += textToScroll
        }
        
        movingLabelFirstPart.text = repeatedText
        movingLabelSecondContinious.text = repeatedText
        
        movingLabelFirstPart.textColor = textColor
        movingLabelSecondContinious.textColor = textColor
        
        movingLabelFirstPart.sizeToFit()
        movingLabelSecondContinious.sizeToFit()
        
        scrollView.addSubview(movingLabelFirstPart)
        scrollView.addSubview(movingLabelSecondContinious)
        
        movingLabelFirstPart.frame.origin = .zero
        movingLabelSecondContinious.frame.origin = CGPoint(x: movingLabelFirstPart.bounds.width, y: 0)
        
        scrollView.contentSize.width = movingLabelFirstPart.bounds.width * 2
        scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func startScrolling(movingLabelFirstPart: UILabel, movingLabelSecondContinious: UILabel, scrollView: UIScrollView) {
        let duration: TimeInterval = 30
        
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .curveLinear], animations: {
            scrollView.contentOffset.x = movingLabelFirstPart.frame.width
        }, completion: nil)
    }
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UIView {
    func removeAllSubviews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
}

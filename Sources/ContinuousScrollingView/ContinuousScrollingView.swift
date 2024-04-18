//
//  ContinuousScrollingView.swift
//
//
//  Created by Deniz Yüce on 24.03.2024.
//

import UIKit

final public class ContinuousScrollingView: UIView {
    
    public var textToScroll = ""
    public var font: UIFont = .systemFont(ofSize: 14.0)
    public var textColor: UIColor = .black
    public var duration: TimeInterval = 30
    public var delay: CGFloat = 0.2
    
    private let scrollView = UIScrollView()
    private let movingLabelFirstPart = UILabel()
    
    public func startAnimations() {
        setupScrollView()
    }
    
    private func setupScrollView() {
        removeAllSubviews()
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
        
        setUpTexts()
        startScrolling()
    }
        
    private func setUpTexts() {
        let repeatedText = textToScroll.repeated(toFillScreenWidthTwice: font, screenWidth: UIScreen.main.bounds.width)
        movingLabelFirstPart.text = repeatedText
        movingLabelFirstPart.textColor = textColor
        movingLabelFirstPart.sizeToFit()
        
        scrollView.addSubview(movingLabelFirstPart)
        
        movingLabelFirstPart.frame.origin = .zero
        
        scrollView.contentSize.width = movingLabelFirstPart.bounds.width * 2
    }
    
    private func startScrolling() {
        UIView.animate(withDuration: duration, delay: delay, options: [.repeat, .curveLinear], animations: { [unowned self] in
            self.scrollView.contentOffset.x = self.movingLabelFirstPart.frame.width
        })
    }
}

extension String {
    fileprivate func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    fileprivate func repeated(toFillScreenWidthTwice font: UIFont, screenWidth: CGFloat) -> String {
        let textWidth = self.width(withConstrainedHeight: 32, font: font)
        let repetitionsNeeded = Int(ceil((screenWidth * 2) / textWidth))
        return String(repeating: self, count: repetitionsNeeded)
    }
}


extension UIView {
    fileprivate func removeAllSubviews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
}

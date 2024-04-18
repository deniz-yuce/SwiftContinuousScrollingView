//
//  ContinuousScrollingView.swift
//
//
//  Created by Deniz Yüce on 24.03.2024.
//

import UIKit

final public class ContinuousScrollingView: UIView {
    
    // MARK: - Public Properties
    
    public var textToScroll = ""
    public var font: UIFont = .systemFont(ofSize: 14.0)
    public var textColor: UIColor = .black
    public var textBackgroundColor: UIColor = .white
    public var viewBackgroundColor: UIColor = .clear
    public var duration: TimeInterval = 30
    public var delay: CGFloat = 0.2
    
    // MARK: - Computed Properties
    
    public var textHeight: CGFloat {
        textToScroll.size(withFont: font).height
    }
    
    // MARK: - Private Properties
    
    private let scrollView = UIScrollView()
    private let movingLabel = UILabel()
    
    // MARK: - Start View
    
    public func startAnimations() {
        setupScrollView()
    }
    
    // MARK: - Prepare View
    
    private func setupScrollView() {
        scrollView.backgroundColor = viewBackgroundColor
        scrollView.isUserInteractionEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        
        // Reset View
        removeAllSubviews()
        scrollView.removeFromSuperview()
        
        let textSize = textToScroll.size(withFont: font)
        
        // Set ScrollView Constraints
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        // Avaiod constraints conflict, when to give another heightAnchor
        let heightConstraint = scrollView.heightAnchor.constraint(equalToConstant: textSize.height)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
        
        setUpTexts(textWidth: textSize.width)
        startScrolling()
    }
        
    private func setUpTexts(textWidth: CGFloat) {
        let repeatedText = textToScroll.repeated(textWidth: textWidth, screenWidth: UIScreen.main.bounds.width)
        movingLabel.text = repeatedText
        movingLabel.font = font
        movingLabel.textColor = textColor
        movingLabel.backgroundColor = textBackgroundColor
        movingLabel.sizeToFit()
        
        // Set movingLabel Constraints
        scrollView.addSubview(movingLabel)
        movingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movingLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            movingLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            movingLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            movingLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        scrollView.contentSize.width = movingLabel.bounds.width * 2
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
    }
    
    // MARK: - Animations
    
    private func startScrolling() {
        UIView.animate(withDuration: duration, delay: delay, options: [.repeat, .curveLinear], animations: {
            self.scrollView.contentOffset.x = self.movingLabel.frame.width + UIScreen.main.bounds.width
        })
    }
}

// MARK: - String Extension

fileprivate extension String {
    func size(withFont font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return CGSize(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
    }
    
    func repeated(textWidth: CGFloat, screenWidth: CGFloat) -> String {
        let repetitionsNeeded = Int(ceil((screenWidth * 2) / textWidth))
        return String(repeating: self, count: repetitionsNeeded)
    }
}

// MARK: - UIView Extension

fileprivate extension UIView {
    func removeAllSubviews() {
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
}

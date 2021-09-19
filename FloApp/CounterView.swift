//
//  CounterView.swift
//  FloApp
//
//  Created by Denis Sychev on 9/18/21.
//

import UIKit

@IBDesignable
class CounterView: UIView {
    
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }

    @IBInspectable var counter: Int = 7 {
        didSet {
            if counter <= Constants.numberOfGlasses {
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = .blue
    @IBInspectable var counterColor: UIColor = .orange
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = max(bounds.width, bounds.height) / 2
        
        let startAngle: CGFloat = 3 * .pi / 4
        let endAngle: CGFloat = .pi / 4
        
        let path = UIBezierPath(arcCenter: center,
                                radius: radius - Constants.arcWidth / 2,
                                startAngle: startAngle,
                                endAngle: endAngle
                                , clockwise: true)
        
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        
        // first calculate the difference between the two angles ensuring it is positive
        let angleDifference: CGFloat = 2 * .pi - startAngle + endAngle
        // then calculate the arc for each single arc
        let arcLengthPerGlass: CGFloat = angleDifference / CGFloat(Constants.numberOfGlasses)
        // then multiply out by the actual glasses drunk
        let outLineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
        
        // draw the outer arc
        let outerArcRadius = bounds.width / 2 - Constants.halfOfLineWidth
        let outlinePath = UIBezierPath(
            arcCenter: center,
            radius: outerArcRadius,
            startAngle: startAngle,
            endAngle: outLineEndAngle,
            clockwise: true)
        
        // draw the inner arc
        let innerArcRadius = bounds.width / 2 - Constants.arcWidth + Constants.halfOfLineWidth
        
        outlinePath.addArc(withCenter: center,
                           radius: innerArcRadius,
                           startAngle: outLineEndAngle, endAngle: startAngle, clockwise: false)
        // close the path
        outlinePath.close()
        
        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
    }
    	
}

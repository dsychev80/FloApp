//
//  PushButton.swift
//  FloApp
//
//  Created by Denis Sychev on 9/18/21.
//

import UIKit

@IBDesignable
class PushButton: UIButton {

    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
    
    @IBInspectable var fillColor: UIColor = .green
    @IBInspectable var isAddButton: Bool = true
    
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
    
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    
    /*
        Never call draw(_:) directly. If view is not being updated, then call setNeedsDisplay().
        setNeedsDisplay() does not itself call draw(_:), but it flags the view as “dirty,” triggering a redraw using draw(_:) on the next screen update cycle. Even if you call setNeedsDisplay() five times in the same method, you’ll call draw(_:) only once.
    */
    override func draw(_ rect: CGRect) {
        // Drawing code
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        
        // set up the width and height variables for horizontal stroke
        let plusWidth = min(bounds.width, bounds.height) * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        let plusPath = UIBezierPath()
        // set the path's line width to the height of the stroke
        plusPath.lineWidth = Constants.plusLineWidth
        // move the initial point of the path to the start of the horizontal stroke
        plusPath.move(to: CGPoint(
                        x: halfWidth - halfPlusWidth + Constants.halfPointShift,
                        y: halfHeight + Constants.halfPointShift))
        // add a point to the path at the end of the stroke
        plusPath.addLine(to: CGPoint(
                            x: halfWidth + halfPlusWidth + Constants.halfPointShift,
                            y: halfHeight + Constants.halfPointShift))
        
        if isAddButton {
            plusPath.move(to: CGPoint(
                            x: halfWidth + Constants.halfPointShift,
                            y: halfHeight + halfPlusWidth + Constants.halfPointShift))
            plusPath.addLine(to: CGPoint(
                                x: halfWidth + Constants.halfPointShift,
                                y: halfHeight - halfPlusWidth + Constants.halfPointShift))
        }
        // set the stroke color
        UIColor.white.setStroke()
        
        // draw the stroke
        plusPath.stroke()
    }
    

}

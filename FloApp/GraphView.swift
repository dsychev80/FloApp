//
//  GraphView.swift
//  FloApp
//
//  Created by Denis Sychev on 9/20/21.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60.0
        static let bottomBorder: CGFloat = 50.0
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    
    var graphPoints = [4, 2, 6, 4, 5, 8, 3]
    
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    override func draw(_ rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        // Clipping area
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let colors = [startColor.cgColor, endColor.cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors as CFArray,
                                        locations: colorLocations) else {
            return
        }
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0,
                               y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: [])
        
        // calculate the x - point
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        let columnXPoint = { (column: Int) -> CGFloat in
            // Calculate the gap between points
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
        // calculate the y - point
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        let graphHeight = height - topBorder - bottomBorder
        guard let maxValue = graphPoints.max() else { return }
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            return graphHeight + topBorder - yPoint // flip the graph
        }
        // draw the line graph
        UIColor.white.setFill()
        UIColor.white.setStroke()
        // set up the points line
        let graphPath = UIBezierPath()
        // go to start line
        graphPath.move(to: CGPoint(x: columnXPoint(0),
                                   y: columnYPoint(graphPoints[0])))
        // add points for each item in the graphPoints array
        // at the correct (x, y) for the point
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i),
                                    y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }

        // Gradient for the path
        // create the clipping path for the graph gradient
        context.saveGState()
        // make the copy of the path
        guard let clippingPath = graphPath.copy() as? UIBezierPath else { return }
        // add lines to the copied path to complete the clip area
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1),
                                         y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0),
                                         y: height))
        clippingPath.close()
        // add the clipping path to the context
        clippingPath.addClip()

        let highestYPoint = columnYPoint(maxValue)
        let graphStartPoint = CGPoint(x: margin,
                                      y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin,
                                    y: bounds.height)
        context.drawLinearGradient(gradient,
                                   start: graphStartPoint,
                                   end: graphEndPoint,
                                   options: [])

         context.restoreGState()
        
        // draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0
        graphPath.stroke()
        
        // draw the circles on top of the graph stroke
        for i in 1..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i),
                                y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(
                ovalIn: CGRect(origin: point,
                               size: CGSize(width: Constants.circleDiameter,
                                            height: Constants.circleDiameter)))
            circle.fill()
            
            // draw horizontal graph lines on the top of everything
            let linePath = UIBezierPath()
            
            // top line
            linePath.move(to: CGPoint(x: margin, y: topBorder))
            linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
            
            // center line
            let center = graphHeight / 2 + topBorder
            linePath.move(to: CGPoint(x: margin, y: center))
            linePath.addLine(to: CGPoint(x: width - margin, y: center))
            
            // bottom line
            linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
            linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
            
            let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
            color.setStroke()
            
            linePath.lineWidth = 1.0
            linePath.stroke()
            
            
        }
    }
    
    
}

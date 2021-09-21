//
//  ViewController.swift
//  FloApp
//
//  Created by Denis Sychev on 9/18/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var counterLabel: UILabel!
    
    @IBOutlet weak var averageWaterDrunk: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var isGraphViewShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        counterLabel.text = String(counterView.counter)
    }

    @IBAction func pushButtonPressed(_ button: PushButton) {
        if button.isAddButton {
            counterView.counter += 1
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
        
        if isGraphViewShowing {
            counterViewTap(nil)
        }
    }
    
    @IBAction func counterViewTap(_ gesture: UITapGestureRecognizer?) {
        // Hide graph
        if isGraphViewShowing {
            UIView.transition(from: graphView,
                              to: counterView,
                              duration: 1.0,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion: nil)
        } else {
            UIView.transition(from: counterView,
                              to: graphView,
                              duration: 1.0,
                              options: [.transitionFlipFromLeft, .showHideTransitionViews],
                              completion: nil)
            setupGraphDisplay()
        }
        isGraphViewShowing.toggle()
    }
    
    func setupGraphDisplay() {
        let maxDayIndex = stackView.arrangedSubviews.count - 1
        
        // 1. Replace last day with today's actual data
        graphView.graphPoints[graphView.graphPoints.count - 1] = counterView.counter
        // 2. Indicate that the graph needs to be redrawn
        graphView.setNeedsDisplay()
        maxLabel.text = "\(graphView.graphPoints.max() ?? 0)"
        
        // 3. Calculate avarage from graphPoints
        let average = graphView.graphPoints.reduce(0, +) / graphView.graphPoints.count
        averageWaterDrunk.text = "\(average)"
        
        // 4. Setup date formatter and calendar
        let today = Date()
        let calendar = Calendar.current
        
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        
        // 5. Set up the day name labels with correct days
        for i in 0...maxDayIndex {
            if let date = calendar.date(byAdding: .day, value: -i, to: today) {
                let label = stackView.arrangedSubviews[maxDayIndex - i] as? UILabel
                label?.text = formatter.string(from: date)
            }
        }
    }
}


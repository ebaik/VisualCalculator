//
//  GraphViewController.swift
//  Graphing Calculator
//
//  Created by EB on 6/6/15.
//  Copyright (c) 2015 Test Labs. All rights reserved.
//

import UIKit


class GraphViewController: UIViewController, GraphViewDataSource {
    
    private var brain = CalculatorBrain()
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "handleScale:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "handlePan:"))
            graphView.addGestureRecognizer(UITapGestureRecognizer(target: graphView, action: "handleTap:"))
        }
    }
    

    func funcValueForGraphView(sender: GraphView, x: CGFloat) -> CGFloat? {
        brain.variableValues[brain.variableKey] = Double(x)
        if let y = brain.evaluateVariable() {
            return CGFloat(y)
        }
        return nil
    }

}

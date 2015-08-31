//
//  GraphView.swift
//  Graphing Calculator
//
//  Created by EB on 6/7/15.
//  Copyright (c) 2015 Test Labs. All rights reserved.
//

import UIKit

protocol GraphViewDataSource: class {
    func funcValueForGraphView(sender: GraphView, x: CGFloat ) -> CGFloat?
}

@IBDesignable
class GraphView: UIView {

    var graphOrigin: CGPoint = CGPointZero {
        didSet {
            resetOrigin = false
            setNeedsDisplay()
        }
    }
    
    private var resetOrigin: Bool = true
    
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet { setNeedsDisplay() } }  // points per unit
    @IBInspectable
    var lineWidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blackColor() { didSet { setNeedsDisplay() } }
    
    weak var dataSource: GraphViewDataSource?

    override func drawRect(rect: CGRect) {
        if resetOrigin {
            graphOrigin = convertPoint(center, fromView: superview)
        }
        // Drawing code
        let axesPath = AxesDrawer(contentScaleFactor: contentScaleFactor)
        println("scale = \(scale)")
        axesPath.drawAxesInRect(bounds, origin: graphOrigin, pointsPerUnit: scale)
        let graphPath = UIBezierPath()
        graphPath.lineWidth = lineWidth
        var firstValue = true
        var point = CGPointZero
        for var i = 0; i <= Int(bounds.size.width * contentScaleFactor); i++ {  // iterate over pixels
            point.x = CGFloat(i) / contentScaleFactor  // work in points
            if let y = dataSource?.funcValueForGraphView(self, x: (point.x - graphOrigin.x) / scale )
            {
                if y.isNormal || y.isZero {
                    point.y = graphOrigin.y - y * scale
                    if firstValue {
                        graphPath.moveToPoint(point)
                        firstValue = false
                    } else {
                        graphPath.addLineToPoint(point)
                    }
                }
                else {
                    firstValue = true
                }
            }
        }
        graphPath.stroke()
        
    }
    
    func handleScale(gesture: UIPinchGestureRecognizer) {
        if gesture.state == .Changed {
            scale *= gesture.scale
            gesture.scale = 1
        }
    }
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = gesture.translationInView(self)
            graphOrigin.x += translation.x
            graphOrigin.y += translation.y
            gesture.setTranslation(CGPointZero, inView: self)
        default: break
        }
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        gesture.numberOfTapsRequired = 2
        switch gesture.state {
        case .Ended:
            var tapLocation: CGPoint = gesture.locationInView(self)
            graphOrigin.x = tapLocation.x
            graphOrigin.y = tapLocation.y
        default: break
        }
    }

}

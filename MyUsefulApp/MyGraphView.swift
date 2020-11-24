//
//  MyGraphView.swift
//  MyUsefulApp
//
//  Created by amooyts on 24.11.2020.
//

import Foundation
import UIKit

@IBDesignable
class MyGraphView: UIView {
    var yForX: ((Double) -> Double)? { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scale: CGFloat = 15.0 { didSet {setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable
    var colorAxes: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    var originSet: CGPoint? { didSet { setNeedsDisplay() } }
    private var origin: CGPoint {
        get {
            return originSet ?? CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        }
        set {
            originSet = newValue
        }
    }
    
    private var axesDrawes = AxesDrawer()
    override func draw(_ rect: CGRect) {
        axesDrawes.contentScaleFactor = contentScaleFactor
        axesDrawes.color = colorAxes
        axesDrawes.drawAxes(in: bounds, origin: origin, pointsPerUnit: scale)
        drawCurveInRect(bounds, origin: origin, scale: scale)
    }
    
    func drawCurveInRect(_ bounds: CGRect, origin: CGPoint, scale: CGFloat) {
        var xGraph, yGraph: CGFloat
        var x, y: Double
        var isFirstPoint = true
        
        let oldYGraph: CGFloat = 0.0
        var disContinuity: Bool {
            return abs(yGraph - oldYGraph) > max(bounds.width, bounds.height) * 1.5
        }
        
        if yForX != nil {
            color.set()
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            
            var xArray: [Double] = []
            for i in -6...6 {
                xArray.append(Double(i))
                if i == 6 {
                    break
                }
                for _ in 0...4 {
                    xArray.append(Double(0))
                }
            }
            var i: Int = 0
            while i < xArray.count {
                if Int(xArray[i]) == 6 {
                    break
                }
                xArray[i + 1] = xArray[i] + 0.2
                xArray[i + 2] = xArray[i] + 0.35
                xArray[i + 3] = xArray[i] + 0.55
                xArray[i + 4] = xArray[i] + 0.7
                xArray[i + 5] = xArray[i] + 0.9
                i = i + 6
            }
            
            for i in xArray{
                x = Double(i)
                
                xGraph = CGFloat(x) * scale + origin.x
                
                y = (yForX)!(x)
                
                guard y.isFinite else {
                    continue
                }
                yGraph = origin.y - CGFloat(y) * scale
                if isFirstPoint {
                    path.move(to: CGPoint(x: xGraph, y: yGraph))
                    isFirstPoint = false
                } else {
                    if disContinuity {
                        isFirstPoint = true
                    } else {
                        path.addLine(to: CGPoint(x: xGraph, y: yGraph))
                    }
                }
            }
            path.stroke()
        }
    }
    
    @objc func originMove(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .ended:
            fallthrough
        case .changed:
            let translation = gesture.translation(in: self)
            if translation != CGPoint.zero {
                origin.x += translation.x
                origin.y += translation.y
                gesture.setTranslation(CGPoint.zero, in: self)
            }
        default:
            break
        }
    }
    
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
            scale *= gesture.scale
            gesture.scale = 1.0
        }
    }
    
    @objc func origin(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            origin = gesture.location(in: self)
        }
    }
}

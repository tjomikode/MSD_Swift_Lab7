//
//  MyChartView.swift
//  MyUsefulApp
//
//  Created by amooyts on 24.11.2020.
//

import Foundation
import UIKit

@IBDesignable
class MyChartView: UIView {
    
    @IBInspectable var progressGreen: CGFloat = 35
    @IBInspectable var progressYellow: CGFloat = 40
    @IBInspectable var progressRed: CGFloat = 25
    
    let lineWidth: CGFloat = 50
    let radius: CGFloat = 100

    override func draw(_ rect: CGRect) {
        
        let pathGreen = UIBezierPath()
        let pathYellow = UIBezierPath()
        let pathRed = UIBezierPath()
        
        pathGreen.lineWidth = lineWidth
        pathYellow.lineWidth = lineWidth
        pathRed.lineWidth = lineWidth
            
        pathGreen.addArc(withCenter: CGPoint(x:self.bounds.width / CGFloat(2) , y: self.bounds.height / CGFloat(2)), radius: radius, startAngle: 0, endAngle: (2.0 * CGFloat.pi) * progressGreen / 100.0 , clockwise: true)
        
        pathYellow.addArc(withCenter: CGPoint(x:self.bounds.width / CGFloat(2) , y: self.bounds.height / CGFloat(2)), radius: radius, startAngle: (2 * CGFloat.pi) * progressGreen / 100.0, endAngle: 2.0 * CGFloat.pi * (progressYellow + progressGreen) / 100.0 , clockwise: true)
        
        pathRed.addArc(withCenter: CGPoint(x: self.bounds.width / CGFloat(2), y: self.bounds.height / CGFloat(2)), radius: radius, startAngle: 2.0 * CGFloat.pi * (progressYellow + progressGreen) / 100.0, endAngle: 2.0 * CGFloat.pi, clockwise: true)
        
        UIColor.green.setStroke()
        pathGreen.stroke()
        UIColor.yellow.setStroke()
        pathYellow.stroke()
        UIColor.red.setStroke()
        pathRed.stroke()
    }
}

//
//  MyGraphControllerView.swift
//  MyUsefulApp
//
//  Created by amooyts on 24.11.2020.
//

import Foundation
import UIKit

class MyGraphControllerView: UIViewController {
    
    // Model for Graph
    var yForX: ((Double) -> Double)? { didSet { refreshGraph() } }
    
    // Views
    @IBOutlet weak var viewGraph: MyGraphView! { didSet {
        viewGraph.addGestureRecognizer(UIPinchGestureRecognizer(target: viewGraph, action: #selector(MyGraphView.scale(_:))))
        viewGraph.addGestureRecognizer(UIPanGestureRecognizer(target: viewGraph, action: #selector(MyGraphView.originMove(_:))))
        let doubleTapRecognizer = UITapGestureRecognizer(target: viewGraph, action: #selector(MyGraphView.origin(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        viewGraph.addGestureRecognizer(doubleTapRecognizer)
        refreshGraph() } }
    
    @IBOutlet weak var viewChart: MyChartView!
    @IBOutlet weak var labelGreenProgress: UILabel!
    @IBOutlet weak var labelYellowProgress: UILabel!
    @IBOutlet weak var labelRedProgress: UILabel!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func chooseView(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            viewGraph.isHidden = false
            viewChart.isHidden = true
        case 1:
            viewGraph.isHidden = true
            viewChart.isHidden = false
            labelGreenProgress.text = "\(Int(viewChart.progressGreen))%"
            labelGreenProgress.textColor = UIColor.green
            labelYellowProgress.text = "\(Int(viewChart.progressYellow))%"
            labelYellowProgress.textColor = UIColor.yellow
            labelRedProgress.text = "\(Int(viewChart.progressRed))%"
            labelRedProgress.textColor = UIColor.red
        default:
            break
        }
    }
    
    func refreshGraph() {
        viewGraph.yForX = yForX
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yForX = { exp($0) }
    }
}

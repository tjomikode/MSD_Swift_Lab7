//
//  AddingMovieViewController.swift
//  MyUsefulApp
//
//  Created by amooyts on 17.11.2020.
//

import Foundation
import UIKit

protocol DataEnteredDelegate: class {
    func userEnterInfo(info1: String, info2: String, info3: String)
}

class AddingMovieViewController: UIViewController {
    
    weak var delegate: DataEnteredDelegate? = nil
    
    @IBOutlet weak var titleNewMovie: UITextField!
    @IBOutlet weak var typeNewMovie: UITextField!
    @IBOutlet weak var yearNewMovie: UITextField!
    
    @IBAction func buttonAddNewMovie(_ sender: Any) {
        delegate?.userEnterInfo(info1: titleNewMovie.text!, info2: typeNewMovie.text!, info3: yearNewMovie.text!)
        _ = self.navigationController?.popViewController(animated: true)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    
}

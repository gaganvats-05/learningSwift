//
//  ResultViewController.swift
//  BMI Calculator
//
//  Created by Gagan vats on 04/02/21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    var bmiValue:String?// set by calculator brain from calculate view controller at prepeare for segue
    var advice:String?
    var color:UIColor?
    
    
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var adviceLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()// we always use this method so that viewDidLoadcan perform its fuction
        bmiLabel.text=bmiValue
        adviceLabel.text = advice
        view.backgroundColor = color
    }
    // when the button is pressed the current view is dismissed
    @IBAction func recalculatePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

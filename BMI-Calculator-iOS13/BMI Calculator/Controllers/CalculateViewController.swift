//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController {
    
    var calculatorBrain = CalculatorBrain()// assigns the calcuatorBrian struct
    
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
   
    @IBAction func heightSliderChanged(_ sender: UISlider) {
        // shows the value upto 2 decimal place
        heightLabel.text = String(format: "%.2f m", sender.value)
    }
    
    @IBAction func weightSliderChanged(_ sender: UISlider) {
        // shows weight as a whole number
        weightLabel.text = String(format: "%.0f kg", sender.value)


    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func calculatePressed(_ sender: UIButton) {
        let height = heightSlider.value// sets hieght as the slider value
        let weight = weightSlider.value// sets weights as the slider value
        calculatorBrain.calculateBMI(height: height , weight: weight )//calls the calculator brain
        
        //Initiates the segue with the identifier "go to result"(set in storyboard) from the current view controller's storyboard file.
        self.performSegue(withIdentifier: "goToResult", sender: self)
        }
    //Notifies the view controller that a segue is about to be performed.
    // sender can be usesd to specify which object initiated the segue
    /*the segue object contains information about the transition, including references to both view controllers that are
     involved.*/

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            // sets the destination of the segue as resultViewController
            let destinationVC = segue.destination as! ResultViewController
            // sets the bmiValue parameter value of the resultView controller as the  calculator brain one's
            destinationVC.bmiValue = calculatorBrain.getBMIValue()
            // sets the getAdvice parameter value of the resultView controller as the  calculator brain one's
            destinationVC.advice = calculatorBrain.getAdvice()
            // sets the color parameter value of the resultView controller as the  calculator brain one's
            destinationVC.color = calculatorBrain.getColor()
            
        }
        
    }
}


//
//  CalculatorBrain.swift
//  BMI Calculator
//
//  Created by Gagan vats on 04/02/21.


import UIKit
struct CalculatorBrain {
    var bmi:BMI? // makes a variable bmi of the type BMI optionals struct
    
    func getBMIValue() -> String {// will get the bmi value from calculateViewController
        
        let bmiTo1DecimalPlace = String(format: "%.1f", bmi?.value ?? 0.0)// sets the recieved string in the desired format
        return bmiTo1DecimalPlace
        
        
    }
    
    // logical calculations for bmi
    // and setting up the color, advice for the bmi
    mutating func calculateBMI(height: Float, weight: Float)  {
         let bmiValue = weight/(height*height)
        if bmiValue < 18.5 {
            bmi = BMI(value: bmiValue, advice: "Eat More", color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
        } else if bmiValue < 24.9 {
            bmi = BMI(value: bmiValue, advice: "Fit ", color: #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))

        }
        else{
            bmi = BMI(value: bmiValue, advice: "Eat Less", color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))

        }
    }
    //will get the advice text from calculate bmi but if it is null then show the folloeing string
    func getAdvice() -> String{
        let adviceText = bmi?.advice ?? "Eat A Balanced Diet"
        
        return adviceText
    }
    
    // will give the color based in the bmi value from calculate bmi
    func getColor() -> UIColor {
        let color = bmi?.color ?? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return color
        
    }
    
}

//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
 
    @IBOutlet weak var valueOfBitcoin: UILabel?
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()// assigns the coin manager

    //MARK: - viewDidLoad
    override func viewDidLoad() {
     
        super.viewDidLoad()
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }

   
    

    
}

//MARK: - UIpickerViewDataSource
extension ViewController: UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}


//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate{
    func didUpdaterice(price: String, currency: String) {
        // dispatchQueue make a task to to completed on the main thread
        // as we are updating the uiview this task needs to be done on the main thread
        DispatchQueue.main.async {
            
            self.valueOfBitcoin?.text = price
            self.currencyLabel.text = currency
        }

    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}



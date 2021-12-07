//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currecyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currecyPicker.dataSource = self
        currecyPicker.delegate = self
        coinManager.delegate = self
    }
}
extension ViewController : UIPickerViewDataSource,UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //to determine how many columns we want in our picker.
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let seletedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: seletedCurrency)
    }
}
extension ViewController : CoinManagerDelegate{
    func didUpdatePrice(rate:String,currency:String) {
        
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = rate
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }

}


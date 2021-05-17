//
//  ViewController.swift
//  Clima
//
//  Created by gagan vats


import UIKit
import CoreLocation
class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!// this is used to for the background based on the weather condition
    @IBOutlet weak var temperatureLabel: UILabel!// this gives the temprature
    @IBOutlet weak var cityLabel: UILabel!//name of city
    @IBOutlet weak var searchTextFeild: UITextField!//UItextField where you type the name
    
    var weatherManager = WeatherManager()// calls the struct from weathermanager
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
      
        weatherManager.delegate = self
        searchTextFeild.delegate = self// sets the default delegate properties for the searchtextField
    }
    @IBAction func goToCurrentLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        searchTextFeild.endEditing(true)// causes the search field to resign from the first responder status
    }
    
    // textFieldShouldReturn tells what to do after the return button is pressed in the keyboard
    // it Asks the delegate whether to process the pressing of the Return button for the text field.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.text != "" {// here is the text is not empty then this func returns true
            return true
        }else{
            textField.placeholder = "Type Something" //the placeholder shows to type something
            return false
        }
    }
    // textFieldDidEndEditing tells the ui kit what to do after the text field quits its first responder status
    // in the workflow it is called after the textfeild should return
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextFeild.text {  // here we use searchTextFeild.text to get the weather for that city.
            weatherManager.fetchWeather(cityName: city)// we give the fetch weathers cityName Query the name of the city
        }else{
            weatherManager.fetchWeather(cityName: "Delhi")// else we show the weather of the city
        }
        searchTextFeild.text=""// after all the work is done we make the textholder empty again
    }
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:WeatherModel)  {
        DispatchQueue.main.async {
            self.temperatureLabel.text=weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - LocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: latitude, longitude: longitude)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error)
    }
}

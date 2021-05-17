//
//  WeatherManager.swift
//  Clima
//
//  Created by Gagan vats on 06/02/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation
// this is a delegate which have the requirement of a function didUpdateWeather
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:WeatherModel)
    func didFailWithError(error: Error)
}
struct WeatherManager { // creates the struct weather manager
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0085518fa11c161fe1c79af5de7e20a8&units=metric"// we recieve the  url of the api in form of a string
    
    var delegate:WeatherManagerDelegate? 
    
    
    
    func fetchWeather(cityName: String )  {// this function gets the name of the city typed in the text field and pass it to then append the url strings query such that we get the weather of that city only
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with : urlString)
    }
    
    func fetchWeather(latitude:CLLocationDegrees,longitude: CLLocationDegrees  )  {// this function gets the name of the city typed in the text field and pass it to then append the url strings query such that we get the weather of that city only
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with : urlString)
    }
    
    
    /*
     function below perform the request from the api, this is doen in the following steps:
     1) it creates the url from the string
     2)we create a url session that is we provide the api the right to get and post the data
     3)we give the session a task I.E it Creates a task that retrieves the contents of the specified URL, then calls a handler upon completion.
    */
    func performRequest( with urlString: String )  {
    //1)create URL
        if let url = URL(string: urlString){
            //2) create URL session
            let session = URLSession(configuration: .default)
            // 3)give the session the task
            let task = session.dataTask(with: url) { (data, response, error) in // here we make a delegate such that we dont have to write the completion handler ...
                if error != nil {// if data is empty then we show an error
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{// data represents the data retrieved from the api
                    if let weather = self.parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather:weather)
                    }
                }
            }
            //4)start the task
            task.resume()// resumes the task if it is suspended, newly initialzed tasks begin in suspended state
            
        }
        
    }
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        // do try catch statement in swift is a error haldling method in swift
        //if any error is gives by the do clause then the code will executed from catch
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)// it gives the decoded datea from the weather data class
            let id = decodedData.weather[0].id// this gives the  weather id from the array formed in the weather data
            let temp = decodedData.main.temp// this brings the temprature from the api
            let name = decodedData.name// this brings the name of the city from the api
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)// this assign the value in weathermodel formatt and stores it in weather
            return weather
        }catch{
            delegate?.didFailWithError(error: error)// is there is any error in parsing the json then error is printed
            return nil
        }
        
    }
    
   
    func handle(data: Data?, resoponse: URLResponse? , error: Error?) -> Void {
        if error != nil{
            print("error")
            return
        }
        if let safeData = data {
            let dataString  = String(data: safeData, encoding: .utf8)
            print(dataString ?? "")
        }
    }
}

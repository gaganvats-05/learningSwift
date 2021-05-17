//
//  weatherModel.swift
//  Clima
//
//  Created by Gagan vats on 08/02/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

// here we create a struct weathermodel such that we can get the data retrieved from the api in a speicific model
struct WeatherModel {
    let conditionId: Int// will store the weather id from the api
    let cityName : String// will store the city name form the api
    let temperature: Double// will store the temprature from api.
    
    
    // this gives the temprature upto one decimal place
    var temperatureString:String{
        return String(format: "%.1f", temperature)
    }
    // here we create the condition name such that we can change the image according to the weather code provoded by the api
    var conditionName: String{
        switch conditionId {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud.bolt"
                default:
                    return "cloud"
                }
    }
    
}

//
//  WeatherData.swift
//  Clima
//
//  Created by Gagan vats on 08/02/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
// this is basically to dela woth the api interface
// weather , name ,main are all stored in the api
struct WeatherData: Codable { // codebale is a type alaiis for both the protocols decodable and encodable

    let name: String
    let main: Main
    let weather: [Weather]
    
    
}
struct Main: Codable {
    let temp:Double
}

struct Weather: Codable {
    let description: String
    let id : Int
}

//
//  OpenWeatherResponse.swift
//  VirtualTourist
//
//  Created by Alhanouf Alawwad on 21/12/1442 AH.
//

import Foundation
class OpenWeatherResponse {
    
    struct WeatherIno:Codable {
        let weather:[Weather]?
        let main:Main?
        let name: String?
    }
    
    struct Main: Codable {
        let temp:  Double?
    }
    
    struct Weather: Codable {
        let description:String?
        let icon:String?
    }
    
}

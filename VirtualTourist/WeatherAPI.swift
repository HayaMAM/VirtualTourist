//
//  Weather.swift
//  VirtualTourist
//
//  Created by Haya Mousa on 9/07/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let summary:String
    let icon:String
    let temperature:Double
    let humidity:Double
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    
    init(json:[String:Any]) throws {
        
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temp is missing")}
        guard let humidity = json["humidity"] as? Double else {throw SerializationError.missing("humidity is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        self.humidity = humidity
        
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/b7a7a18717ea37a63ad1ea1c5462e9a9/"
    static func forecast (withLocation location:CLLocationCoordinate2D, completion: @escaping ([Weather]?) -> ()) {
        
        let url = basePath + "\(location.latitude),\(location.longitude)?lang=ar&units=si"
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(forecastArray)
            }
        }
        
        task.resume()
    }
}

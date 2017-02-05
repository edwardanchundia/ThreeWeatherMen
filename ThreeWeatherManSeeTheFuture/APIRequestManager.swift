//
//  APIRequestManager.swift
//  ThreeWeatherManSeeTheFuture
//
//  Created by Tong Lin on 11/7/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

internal class APIRequestManager{
    
    internal static let manager: APIRequestManager = APIRequestManager()
    init () {}
    
    func getWeatherData(apiKey key: String, zip: String, callback: @escaping ((Data?)->Void)) {
        let url: URL = URL(string: "http://api.openweathermap.org/data/2.5/weather?appid=\(key)&zip=\(zip),us")!
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil{
                print("URL error for today weather: \(error!)")
            }
            
            if data != nil{
                print("got today's weather data!!!!")
                callback(data)
            }
            
        }.resume()
    }
    
    func getForecast(apiKey key: String, id: Int, callback: @escaping ((Data?)->Void)){
        let url: URL = URL(string: "http://api.openweathermap.org/data/2.5/forecast?appid=\(key)&id=\(String(id))")!
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil{
                print("URL error for forecast: \(error!)")
            }
            
            if data != nil{
                print("got forcast data for city \(String(id))!!!!")
                callback(data)
            }
        }.resume()
    }
    
    // 0 for random pic or 1 for icon
    func getPicture(name: String, endpiontSwitch: Int, callback: @escaping (Data?) -> Void) {
        let myURL: URL
        
        switch endpiontSwitch {
        case 0:
            myURL = URL(string: "http://loremflickr.com/320/240/\(name)")!
        case 1:
            myURL = URL(string: "http://openweathermap.org/img/w/\(name).png")!
        case 3:
            myURL = URL(string: "http://loremflickr.com/750/1334/\(name)")!
        default:
            myURL = URL(string: " ")!
        }
        
        let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error during session: \(error!)")
            }
            guard let validData = data else { return }
            callback(validData)
        }.resume()
    }
    
}

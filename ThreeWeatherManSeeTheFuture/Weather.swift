//
//  Weather.swift
//  ThreeWeatherManSeeTheFuture
//
//  Created by Tong Lin on 11/7/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation
/*
 {
 "coord": {
 "lon": -73.93,
 "lat": 40.87
 },
 "weather": [
 {
 "id": 800,
 "main": "Clear",
 "description": "clear sky",
 "icon": "01d"
 }
 ],
 "base": "stations",
 "main": {
 "temp": 285.53,
 "pressure": 1029,
 "humidity": 28,
 "temp_min": 284.15,
 "temp_max": 287.15
 },
 "visibility": 16093,
 "wind": {
 "speed": 1.5,
 "deg": 20
 },
 "clouds": {
 "all": 1
 },
 "dt": 1478553300,
 "sys": {
 "type": 1,
 "id": 1969,
 "message": 0.0111,
 "country": "US",
 "sunrise": 1478518501,
 "sunset": 1478555006
 },
 "id": 5122280,
 "name": "Inwood",
 "cod": 200
 } */


enum APIWeatherError: Error {
    case respone
    case weather
    case main
    case wind
    case time
}

class Weather {
    let description: String
    let temperture: Double
    let pressure: Int
    let humidity: Int
    let temp_min: Double
    let temp_max: Double
    let visibility: Int
    let speed: Double
    let deg: Int
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let id: Int
    let name: String
    let icon: String
    
    init(description: String, temperture: Double, pressure: Int, humidity: Int, temp_min: Double, temp_max: Double, visibility: Int, speed: Double, deg: Int, dt: Int, sunrise: Int, sunset: Int, id: Int, name: String, icon: String) {
        self.description = description
        self.temperture = temperture
        self.pressure = pressure
        self.humidity = humidity
        self.temp_min = temp_min
        self.temp_max = temp_max
        self.visibility = visibility
        self.speed = speed
        self.deg = deg
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.id = id
        self.name = name
        self.icon = icon
    }
    
    static func getWeather(weatherData: AnyObject) -> Weather?{
        do {
            
            guard let weather: [Any] = weatherData["weather"] as? [Any],
                let temp: [String: Any] = weather[0] as? [String: Any],
                let description: String = temp["description"] as? String,
                let icon: String = temp["icon"] as? String else {
                    throw APIWeatherError.weather
            }
            
            guard let main: [String: Any] = weatherData["main"] as? [String: Any],
                let temperture: Double = main["temp"] as? Double,
                let pressure: Int = main["pressure"] as? Int,
                let humidity: Int = main["humidity"] as? Int,
                let temp_min: Double = main["temp_min"] as? Double,
                let temp_max: Double = main["temp_max"] as? Double else {
                    throw APIWeatherError.main
            }
            
            guard let wind: [String: Any] = weatherData["wind"] as? [String: Any],
                let speed: Double = wind["speed"] as? Double,
                let deg: Int = wind["deg"] as? Int else {
                    throw APIWeatherError.wind
            }
            
            guard let dt: Int = weatherData["dt"] as? Int else {
                throw APIWeatherError.time
            }
            
            guard let visibility: Int = weatherData["visibility"] as? Int,
                let sys: [String: Any] = weatherData["sys"] as? [String: Any],
                let sunrise: Int = sys["sunrise"] as? Int,
                let sunset: Int = sys["sunset"] as? Int,
                let id: Int = weatherData["id"] as? Int,
                let name: String = weatherData["name"] as? String else {
                    let finalWeather = Weather(description: description, temperture: temperture, pressure: pressure, humidity: humidity, temp_min: temp_min, temp_max: temp_max, visibility: 0, speed: speed, deg: deg, dt: dt, sunrise: 0, sunset: 0, id: 0, name: "", icon: icon)
                    
                    return finalWeather
            }
            
            let finalWeather = Weather(description: description, temperture: temperture, pressure: pressure, humidity: humidity, temp_min: temp_min, temp_max: temp_max, visibility: visibility, speed: speed, deg: deg, dt: dt, sunrise: sunrise, sunset: sunset, id: id, name: name, icon: icon)
            
            return finalWeather
            
        } catch APIWeatherError.weather {
            print("error here on parsing weather data:")
        } catch APIWeatherError.main {
            print("error here on parsing main data:")
        } catch APIWeatherError.wind {
            print("error here on parsing wind data:")
        } catch APIWeatherError.time {
            print("error here on parsing time data:")
        } catch {
            print("unkown error")
        }
        
        return nil
    }
    
    static func setWeather(from data: Data) -> Weather?{
        do {
            let rawData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            let weather: AnyObject = rawData as AnyObject
            
            let finalWeather = getWeather(weatherData: weather)
            
            return finalWeather
            
        }catch {
            print("unkown in setWeather func")
        }
        
        return nil
    }
    
    static func setForecast(from data: Data) -> [Weather]?{
        var forecastArr: [Weather] = []
        do {
            let validData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let rawData: [String: AnyObject] = validData as? [String: AnyObject],
                let weatherList: [AnyObject] = rawData["list"] as? [AnyObject] else {
                    throw APIWeatherError.respone
            }
            
            for weather in weatherList{
                if let temp = getWeather(weatherData: weather){
                    forecastArr.append(temp)
                }
            }
            
            return forecastArr
            
        } catch APIWeatherError.respone {
            print("error here on parsing raw json data:")
        } catch {
            print("unknow error in setForecast func")
        }
        
        return nil
    }
    
}

















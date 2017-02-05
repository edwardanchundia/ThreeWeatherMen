//
//  DataTypeManager.swift
//  ThreeWeatherManSeeTheFuture
//
//  Created by Tong Lin on 11/9/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

internal class DataTypeManager{
    
    internal static let manager: DataTypeManager = DataTypeManager()
    init() {}
    
    func tempertureConversion(temperture temp: Double, tempType segmentIndex: Int) -> String?{
        switch segmentIndex {
        case 0:
            print("switch to Kelvin")
            return String(format: "%.1f", temp) + " K"
        case 1:
            print("switch to Fahrenheit")
            return String(format: "%.1f", ((temp - 273.15) * 9/5 + 32)) + " F"
        case 2:
            print("switch to Celsius")
            return String(format: "%.1f", (temp - 273.15)) + " C"
        default:
            print("no idea what's going on")
        }
        return nil
    }
    
    func windDegreeConversion(degreeDirection: Int) -> String {
        print(degreeDirection)
        print("..............................................")
        switch degreeDirection {
        case 0...11, 348...360:
            print("switch to North")
            return "N"
        case 12...34:
            print("switch To North-NorthEast")
            return "NNE"
        case 35...56:
            print("switch to NorthEast")
            return "NE"
        case 57...79:
            print("switch to East-NorthEast")
            return "ENE"
        case 80...101:
            print("switch to East")
            return "E"
        case 102...124:
            print("switch to East-SouthEast")
            return "ESE"
        case 125...146:
            print("switch to SouthEast")
            return "SE"
        case 147...169:
            print("switch to South-SouthEast")
            return "SSE"
        case 170...191:
            print("switch to South")
            return("S")
        case 192...214:
            print("Switch to South-SouthWest")
            return("SSW")
        case 215...236:
            print("Switch to SouthWest")
            return "SW"
        case 237...259:
            print("Switch to West-SouthWest")
            return "WSW"
        case 260...281:
            print("Switch to West")
            return "W"
        case 282...304:
            print("Switch to West-NorthWest")
            return "WNW"
        case 305...326:
            print("Switch to NorthWest")
            return "NW"
        case 327...347:
            print("Switch to North-NorthWest")
            return "NNW"
        default:
            print("I am the weatherMan! Feel my winds upon your soul, you pleb")
            return " I am an error in the WindDegreeConvesion Fucntion"
        }
    }
    
    
    func timestampToString(unix a: Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(a))
        
        let timePeriodFormatter = DateFormatter()
        timePeriodFormatter.dateFormat = "HH:mm"
        
        let finalTime = timePeriodFormatter.string(from: date)
        print(finalTime)
        
        return finalTime
    }
    
    
    
    
    
}

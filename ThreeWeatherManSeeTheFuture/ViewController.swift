//
//  ViewController.swift
//  ThreeWeatherManSeeTheFuture
//
//  Created by Tong Lin on 11/7/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: width, height: height)))
        APIRequestManager.manager.getPicture(name: "sky", endpiontSwitch: 3) {
            (backgroundData: Data?) in
            if backgroundData != nil{
                DispatchQueue.main.async {
                    imageViewBackground.image = UIImage(data: backgroundData!)
                }
            }
        }
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    private let apiKey = "93163a043d0bde0df1a79f0fdebc744f"
    private var zipCode = "10002"
    
    private let collectionCellIdentifier = "ForcastingWeatherCellIdentifier"
    //private let sectionInsets = UIEdgeInsets(top: 1.0, left: 2.0, bottom: 1.0, right: 2.0)
    //private let itemsPerRow: CGFloat = 3
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var tempTypesSegment: UISegmentedControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDegLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var randomPicView: UIImageView!
    
    @IBOutlet weak var forecastCollectionView: UICollectionView!
    
    var weather: Weather!
    var forecast = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground()
        self.tempTypesSegment.selectedSegmentIndex = 1
        loadData()
        
        searchBar.delegate = self
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if self.searchBar.text?.characters.count == 5 {
            return true
        } else {
            return false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        zipCode = searchBar.text!
        
        loadData()
    }
    
    func loadData() {
        APIRequestManager.manager.getWeatherData(apiKey: apiKey, zip: zipCode){ (myData: Data?) in
            if myData != nil{
                if let finalWeather = Weather.setWeather(from: myData!){
                    DispatchQueue.main.async {
                        self.weather = finalWeather
                        self.setupView()
                        self.loadForecast(cityID: self.weather.id)
                        self.loadImage(name: self.weather.name)
                    }
                }
            }
        }
    }
    
    func loadForecast(cityID: Int){
        APIRequestManager.manager.getForecast(apiKey: self.apiKey, id: cityID) {
            (data: Data?) in
            
            if data != nil{
                DispatchQueue.main.async {
                    self.forecast = Weather.setForecast(from: data!)!
                    //dump(self.forecast)
                    self.forecastCollectionView?.reloadData()
                }
            }
        }
    }
    
    func setupView(){
        self.navigationItem.title = self.weather.name
        self.currentTempLabel.text = DataTypeManager.manager.tempertureConversion(temperture: self.weather.temperture, tempType: self.tempTypesSegment.selectedSegmentIndex)!
        self.maxTempLabel.text = "Hi: " + DataTypeManager.manager.tempertureConversion(temperture: self.weather.temp_max, tempType: self.tempTypesSegment.selectedSegmentIndex)!
        self.minTempLabel.text = "Lo: " + DataTypeManager.manager.tempertureConversion(temperture: self.weather.temp_min, tempType: self.tempTypesSegment.selectedSegmentIndex)!
        self.descriptionLabel.text = "Description: \(self.weather.description)"
        self.pressureLabel.text = "Pressure: \(String(self.weather.pressure))"
        self.humidityLabel.text = "Humidity: \(String(self.weather.humidity))"
        self.visibilityLabel.text = "Visibility: \(String(self.weather.visibility))"
        self.windSpeedLabel.text = "Wind Speed: \(String(self.weather.speed))"
        self.windDegLabel.text = "Wind Deg: " + DataTypeManager.manager.windDegreeConversion(degreeDirection: self.weather.deg)
        self.sunriseLabel.text = "Sunrise: " + DataTypeManager.manager.timestampToString(unix: self.weather.sunrise)
        self.sunsetLabel.text = "Sunset: " + DataTypeManager.manager.timestampToString(unix: self.weather.sunset)
    }
    
    func loadImage(name: String){
        let imageName: String = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        APIRequestManager.manager.getPicture(name: imageName, endpiontSwitch: 0) {
            (imageData: Data?) in
            if imageData != nil{
                DispatchQueue.main.async {
                    self.randomPicView.image = UIImage(data: imageData!)
                }
            }
        }
    }
    
    @IBAction func tempTypeSwitch(_ sender: UISegmentedControl) {
        self.setupView()
        self.forecastCollectionView?.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! ForecastCollectionViewCell
        let currentTemp = forecast[indexPath.row]
        cell.castedTemp.text = DataTypeManager.manager.tempertureConversion(temperture: currentTemp.temperture, tempType: self.tempTypesSegment.selectedSegmentIndex)
        cell.timeLabel.text = DataTypeManager.manager.timestampToString(unix: currentTemp.dt)
        
        APIRequestManager.manager.getPicture(name: currentTemp.icon, endpiontSwitch: 1) {
            (iconData: Data?) in
            if iconData != nil{
                DispatchQueue.main.async {
                    cell.iconImage.image = UIImage(data: iconData!)
                }
            }
        }
        return cell
    }


}


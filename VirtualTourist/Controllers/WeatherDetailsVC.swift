//
//  WeatherDetailsVC.swift
//  VirtualTourist
//
//  Created by Haya Mousa on 9/07/2019.
//  Copyright © 2019 HayaMousa. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherDetailsVC: UITableViewController, UISearchBarDelegate {
   
    
    @IBOutlet weak var weatherForSearch: UISearchBar!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
 
    var weatherData = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherForSearch.delegate = self
        getWeatherLocation(location: "Riyadh")
        navigationItem.title = "Weather"
        activityIndicator.center = self.tableView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        tableView.addSubview(activityIndicator)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            getWeatherLocation(location: locationString)
        }
    }
    
    func updateTheUI(processing: Bool){
        tableView.isUserInteractionEnabled = !processing
        if processing {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        }else{
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
    }
    
    func displayAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func getWeatherLocation (location:String) {
        
        self.updateTheUI(processing: true)
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            
            guard error == nil else {
                self.displayAlert(title: "Unable to get results", message: error?.localizedDescription)
                self.updateTheUI(processing: false)
                return
            }
            if error == nil {
                if let location = placemarks?.first?.location {
                    Weather.forecast(withLocation: location.coordinate, completion: { (results:[Weather]?) in
                        if let weatherData = results {
                            self.weatherData = weatherData
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.updateTheUI(processing: false)
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return weatherData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = Calendar.current.date(byAdding: .day, value: section, to: Date())
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        
        return dateFormatter.string(from: date!)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
        
        let weatherObject = weatherData[indexPath.section]
        cell.textLabel?.text = weatherObject.summary
        cell.detailTextLabel?.text = "\(Int(weatherObject.temperature)) °C, Humidity: \((weatherObject.humidity))%"
        cell.imageView?.image = UIImage(named: weatherObject.icon)
        
        return cell
    }
}

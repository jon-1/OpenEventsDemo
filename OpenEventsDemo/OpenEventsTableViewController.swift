//
//  OpenEventsTableViewController.swift
//  OpenEventsDemo
//
//  Created by Jon on 10/5/16.
//  Copyright © 2016 jm. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation
import SwiftyJSON

class OpenEventsTableViewController: UITableViewController, AlertPresenter {
    // MARK: - Properties
    lazy var locationManager : CLLocationManager = {
        [unowned self] in
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        return locationManager
    }()
    
    var openEvents : [OpenEvent]?
    let CELL_HEIGHT : CGFloat = 110.0
    
    
    // MARK: - UIViewController 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.alpha = 0.0
        self.tableView.register(UINib(nibName: "OpenEventTableViewCell", bundle: nil), forCellReuseIdentifier: OpenEventTableViewCell.reuseIdentifier)
        locationManager.requestLocation()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openEvents?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OpenEventTableViewCell.reuseIdentifier, for: indexPath) as? OpenEventTableViewCell else {
            fatalError("Error - Expected an OpenEventTableViewCell")
        }
        
        cell.openEvent = openEvents![indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CELL_HEIGHT
    }
    
    // MARK: - API call
 
    func getEventsForCoordinates(lat: String, lon: String) {
        let params = ["lat" : lat, "lon" : lon]
        let callback : Callback = (
            success: { result in
                if let json = result {
                    
                    self.openEvents = json["results"].arrayValue
                        .map { OpenEvent.fromJSON($0) }
                        .sorted { first, second in return first.distance < second.distance }
                    
                    self.tableView.reloadData()
                    UIView.animate(withDuration: 0.35, animations: { self.tableView.alpha = 1.0 })
                    self.title = "\(self.openEvents?.count ?? 0) nearby events"
                }
            },
            failure: { _ in self.presentAlert(alertOptions: AlertOptions(message: "Error retrieving events."))}
        )
        APIManager.sharedInstance.getNearbyEvents(params: params, callback: callback)
    }
    
}



    // MARK: - Location manager delegate
extension OpenEventsTableViewController : CLLocationManagerDelegate {
    
    func gotLocation(locations: [CLLocation]?, error: Error?) {
        if let locs = locations, let firstLoc = locs.first {
            let latString = String(describing: firstLoc.coordinate.latitude)
            let lonString = String(describing: firstLoc.coordinate.longitude)
            self.getEventsForCoordinates(lat: latString, lon: lonString)
        } else {
            self.presentAlert(alertOptions: AlertOptions(message: "Wasn't able to get your location."))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        gotLocation(locations: locations, error: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        gotLocation(locations: nil, error: error)
        
    }
}

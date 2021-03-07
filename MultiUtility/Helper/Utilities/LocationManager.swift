//
//  LocationService.swift
//
//
//  Created by Vaibhav Agarwal on 05/11/2018.
//
//
import Foundation
import CoreLocation
import UIKit

protocol LocationServiceDelegate {
    func tracingLocation()

}

struct Location {
    
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var state: String?
    var country: String?
    var pincode: String?
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static var locationService: LocationService?
    var locationManager: CLLocationManager?
    var delegate: LocationServiceDelegate?
    var
    location = Location()
    
    var notdeterminedRequest: Bool{
        return CLLocationManager.authorizationStatus() == .notDetermined
    }
    
    var deniedRequest: Bool{
        return CLLocationManager.authorizationStatus() == .denied
    }
    
    var deviceLocationEnabled: Bool{
        return !CLLocationManager.locationServicesEnabled()
    }
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        authorizeLocation()
    }
    
    class func instance(){
        self.locationService = LocationService.init()
    }
    
    func authorizeLocation(){
        
        guard let locationManager = self.locationManager else {
            return
        }
        
        if notdeterminedRequest{
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestAlwaysAuthorization()
        }
        else if deniedRequest{
            
            UIApplication.topViewController()?.alert(title: "Evolko", message: "Please provide location permission.", defaultButton: "Settings", cancelButton: "Cancel", completion: { (finished) in
                
                ///to open the settings page of location in case if location is denied.
                if finished{
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                }
            })
        }
        
        setupLocationServices()
    }
    
    func setupLocationServices(){
        
        location = Location()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager?.distanceFilter = 400 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager?.delegate = self
    }
    
    func startUpdating() {
        location = Location()
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdating() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if (status == CLAuthorizationStatus.denied) {
            // The user denied authorization
        } else if (status == CLAuthorizationStatus.authorizedAlways) || status == .authorizedWhenInUse {
            // The user accepted authorization
            startUpdating()
        }
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if location.latitude == nil, let last = locations.last{
            
            location = Location()
            location.latitude = last.coordinate.latitude
            location.longitude = last.coordinate.longitude
            locationManager?.stopMonitoringSignificantLocationChanges()
            updateLocation()
            stopUpdating()
        }
    }
    
    func fetchCityAndCountry() {
        
        if let lat = location.latitude, let long = location.longitude{
            
            let loc: CLLocation = CLLocation(latitude: lat, longitude: long)
            CLGeocoder().reverseGeocodeLocation(loc) { placemarks, error in
                
                self.location.city = placemarks?.first?.locality
                self.location.state = placemarks?.first?.administrativeArea
                self.location.country = placemarks?.first?.country
                self.location.pincode = placemarks?.first?.postalCode
                self.delegate?.tracingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print(value:"error in  location")
    }
    
    // Private function
    private func updateLocation(){
        fetchCityAndCountry()
    }
    
    func checkForAuthorization(completion: @escaping ((Bool)->())){
        
        guard let top = UIApplication.topViewController else {
            completion(false)
            return
        }
        
        if deviceLocationEnabled{
            
            top.alert(title: "Evolko Patient", message: "Please enable location to proceed for registration.", defaultButton: "Okay", cancelButton: nil) { (finished) in
                completion(true)
            }
        }
        else if location.latitude == nil{
            
            if deniedRequest{
                
                top.alert(title: "Evolko Patient", message: "Please allow app to access your location for registration.", defaultButton: "Allow", cancelButton: "Deny") { (finished) in
                    
                    if finished{
                        UIApplication.openAppSetting()
                        completion(true)
                    }
                    else{
                        completion(false)
                    }
                }
            }
            else{
                authorizeLocation()
                completion(true)
            }
        }
        else{
            completion(true)
        }
    }
}

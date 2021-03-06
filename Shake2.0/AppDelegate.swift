//
//  AppDelegate.swift
//  Shake2.0
//
//  Created by Antonio Padilla on 5/30/19.
//  Copyright © 2019 GenOrg. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: AppDelegate
// TODO: - control flow for location manager and UI updates must be a little more robust
//         there are several bugs when switching between windows 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    // The window, location manager, and user's coordinates are all we need globally
    //  and at all times.
    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()
    var userCoord: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var locationServicesOn: Bool = false

    // MARK: Location Manager setup method
    
    // Request permission from the user to use their location
    // Granted => start shaking for CoinFlip ATMs!
    // Denied => Display alternate screen with directions for user to allow location access
    //           through the Settings app on the device (only way to use Shake! for CoinFlip)
    func locationManagerSetup() {
        // IDEA - 7.2.19
        // Instead of a branch here, why not instead store a variable indicating
        //  whether or not the user has given permission or not?  I suggest this
        //  bc this function is CALLED IN APPLICATION()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationServicesOn = true
            locationManager.delegate = self
            locationManager.distanceFilter = 20.0
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    //MARK: - Location Manager delegate methods
    
    // Tells the delegate that the authorization status for the application has changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationServicesOn = true
            print("Location Services Enabled")
        }
        switch status {
        // User hasn't yet made a choice
        case .notDetermined:
            print("not determined")
            locationServicesOn = false
            locationManager.requestWhenInUseAuthorization()
        // User explicitly denied location service access
        case .denied, .restricted:
            print("denied or restricted")
            let vc: ViewController? = UIApplication.shared.topMostViewController() as? ViewController
            if let viewController = vc {
                viewController.animateUserCancelledLabel()
            }
            locationServicesOn = false
        
        // App is authorized to start most location services while in the foreground
        case .authorizedWhenInUse:
            locationManager.requestLocation()
            //runNearbyQuery()
            
        // App is authorized to start location services AT ANY TIME
        case .authorizedAlways:
            // TODO: - only request location if the user has moved X meters since
            //         requesting previously
            locationManager.requestLocation()
            
        default:
            // Default behavior should be identical to .notDetermined
            print("Location Manager Status: \(status)")
            locationServicesOn = false
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Tells the delegate that new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // most recent location update at end of locations array
        if let location = locations.last {
            self.userCoord = location.coordinate
        }
    }
    
    // Tells the delegate that the location manager was unable to retrieve a location value
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let vc: ViewController? = UIApplication.shared.topMostViewController() as? ViewController
        if let viewController = vc {
            showGoToSettingsController(from: viewController)
        } else {
            print("Location Manager error: \(error)")
            //TODO: - update UI for error in retrieving location services
        }
    }
    
    // Tells the delegate that the location manager received updated heading information
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // TODO: implement compass logic here
        let viewController = UIApplication.shared.topMostViewController() as? ViewController
        if let controller = viewController {
            let i = shakeNum
            let label: UILabel = controller.distanceLabel
            let place: Place = controller.viewModel.places[i]
            controller.viewModel.configureDistance(label, using: place, manager)
        } else {
            // TODO: - handle case: application couldn't retrieve ViewController from view hierarchy
        }
    }
    
    private func runNearbyQuery() {
        let viewController = UIApplication.shared.topMostViewController() as? ViewController
        if self.locationManager.location != nil, let controller = viewController {
            if controller.userCanceledMessageLabel != nil {
                controller.userCanceledMessageLabel!.removeFromSuperview()
                controller.iconImage.alpha = 1
            }
            if controller.initialLoad {
                controller.viewModel.runNearbyQuery()
            }
        }
    }
    
    
    //MARK: - Application Delegate methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        locationManagerSetup()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.'
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        let vc: ViewController? = UIApplication.shared.topMostViewController() as? ViewController
//        if let viewController = vc {
//            if viewController.userCanceledMessageLabel == nil {
//                viewController.iconImage.alpha = 1
//            }
//        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // TODO : - we don't want the query to be run EVERY time the user goes back into the app once they have left
        runNearbyQuery()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

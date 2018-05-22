//
//  DetailViewController.swift
//  GoogleMap
//
//  Created by loctv on 5/11/18.
//  Copyright © 2018 loctv. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class DetailViewController: UIViewController {
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    var placesClient: GMSPlacesClient!
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var addressLabel: UILabel?
    
    // You don't need to modify the default init(nibName:bundle:) method.
    
    override func loadView() {
        let lat = 21.015036
        let long = 105.8176057
       self.initMap(lattitude: lat, longitude:long)
    }
    
    func initMap(lattitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: lattitude, longitude: longitude, zoom: 16.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        marker.title = "165 Thái Hà"
        marker.snippet = "Đống Đa, Hà Nội, Việt Nam"
        marker.map = mapView
    }
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.timestamp!.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
        placesClient = GMSPlacesClient.shared()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if let navigationHeight = self.navigationController?.navigationBar.frame.size.height {
            AppDelegate.sharedMainApplication().splitViewController?.updateCloseIcon(height: navigationHeight)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.initMap()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Event? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel?.text = "No current place"
            self.addressLabel?.text = ""
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel?.text = place.name
                    self.addressLabel?.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
    }
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    @IBAction func pickPlace(_ sender: UIButton) {
        let center = CLLocationCoordinate2D(latitude: 37.788204, longitude: -122.411937)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                self.nameLabel?.text = place.name
                self.addressLabel?.text = place.formattedAddress?.components(separatedBy: ", ")
                    .joined(separator: "\n")
            } else {
                self.nameLabel?.text = "No place selected"
                self.addressLabel?.text = ""
            }
        })
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(_ sender: UIButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Set a filter to return only addresses.
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Populate the address form fields.
    func fillAddressForm() {
//        address_line_1.text = street_number + " " + route
//        city.text = locality
//        state.text = administrative_area_level_1
//        if postal_code_suffix != "" {
//            postal_code_field.text = postal_code + "-" + postal_code_suffix
//        } else {
//            postal_code_field.text = postal_code
//        }
//        country_field.text = country
//
//        // Clear values for next time.
//        street_number = ""
//        route = ""
//        neighborhood = ""
//        locality = ""
//        administrative_area_level_1  = ""
//        country = ""
//        postal_code = ""
//        postal_code_suffix = ""
    }
}

// Handle the user's selection.
extension DetailViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        let coordinate = place.coordinate
        self.initMap(lattitude: coordinate.latitude, longitude:coordinate.longitude)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
 
}

extension DetailViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Print place info to the console.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        // Get the address components.
        if let addressLines = place.addressComponents {
//            // Populate all of the address fields we can find.
//            for field in addressLines {
//                switch field.type {
//                case kGMSPlaceTypeStreetNumber:
//                    street_number = field.name
//                case kGMSPlaceTypeRoute:
//                    route = field.name
//                case kGMSPlaceTypeNeighborhood:
//                    neighborhood = field.name
//                case kGMSPlaceTypeLocality:
//                    locality = field.name
//                case kGMSPlaceTypeAdministrativeAreaLevel1:
//                    administrative_area_level_1 = field.name
//                case kGMSPlaceTypeCountry:
//                    country = field.name
//                case kGMSPlaceTypePostalCode:
//                    postal_code = field.name
//                case kGMSPlaceTypePostalCodeSuffix:
//                    postal_code_suffix = field.name
//                // Print the items we aren't using.
//                default:
//                    print("Type: \(field.type), Name: \(field.name)")
//                }
//            }
        }
        
        // Call custom function to populate the address form.
        fillAddressForm()
        
        // Close the autocomplete widget.
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


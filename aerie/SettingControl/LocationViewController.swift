//
//  LocationViewController.swift
//  aerie
//
//  Created by Gitjillian on 2021/3/15.
//  Copyright © 2021 Yejing Li. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel
import CoreLocation

class LocationViewController: UIViewController, UISearchBarDelegate, SearchMapControllerDelegate{
    
    let pin   = MKPointAnnotation()
    let panel = FloatingPanelController()
    let searchVC = SearchMapController()
    @IBOutlet weak var myMapView : MKMapView!
    func searchMapController(_ vc: SearchMapController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        guard let coordinates = coordinates else{
            return
        }
        panel.move(to: .tip, animated: true)
        myMapView.removeAnnotations(myMapView.annotations)
        
        pin.coordinate = coordinates
        //adding a pin to select location
        myMapView.addAnnotation(pin)
        myMapView.setRegion(MKCoordinateRegion(
            center: coordinates,
            span: MKCoordinateSpan(latitudeDelta: 0.7,
            longitudeDelta: 0.7)
        ),
        animated: true)
    }
    
    
    //@IBOutlet weak var searchBtn : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting view panels and search controllers
        self.hideKeyboardWhenTappedElseWhere()
        searchVC.delegate = self
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
    }
}

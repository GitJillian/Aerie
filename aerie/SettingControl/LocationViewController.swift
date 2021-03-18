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

class LocationViewController: UIViewController, SearchMapControllerDelegate{
    
    let pin   = MKPointAnnotation()
    let panel = FloatingPanelController()
    let searchVC = SearchMapController()
    @IBOutlet weak var myMapView : MKMapView!
    
    func searchMapController(_ vc: SearchMapController, didSelectLocationWith location: Location?) {
        guard let location = location, location.coordinates != nil else{
            return
        }
        panel.move(to: .tip, animated: true)
        myMapView.removeAnnotations(myMapView.annotations)
        
        pin.coordinate = location.coordinates!
        //adding a pin to select location
        myMapView.addAnnotation(pin)
        myMapView.setRegion(MKCoordinateRegion(
            center: location.coordinates!,
            span: MKCoordinateSpan(latitudeDelta: 0.7,
            longitudeDelta: 0.7)
        ),
        animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting view panels and search controllers
        self.hideKeyboardWhenTappedElseWhere()
        searchVC.delegate = self
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
    }
}

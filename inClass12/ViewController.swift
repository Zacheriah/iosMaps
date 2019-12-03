//
//  ViewController.swift
//  inClass12
//
//  Created by Wayman, Zacheriah on 4/17/19.
//  Copyright © 2019 Wayman, Zacheriah. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    var dbRef = Database.database().reference()
    let user = Auth.auth().currentUser
    var trip : Trip?
    var name :String?
    var markers  = [GMSMarker]()
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if trip != nil{
            
        }else{
            self.trip = Trip()
        }
        var id = dbRef.childByAutoId().key!
        txtName.text! = trip!.name!
        self.title = "Trip"
        if trip!.id! == ""{
            trip!.id! = id
        }else{
            id = trip!.id!
        }
        
        print(trip!.markers.count)
        for marker in trip!.markers{
            let newmark = GMSMarker()
            newmark.position = CLLocationCoordinate2D(latitude: marker.lat!, longitude: marker.long!)
            newmark.map = self.mapView
            markers.append(newmark)
        }
        if trip!.name! != ""{
            let camera = GMSCameraPosition.camera(withLatitude: markers[0].position.latitude, longitude: markers[0].position.longitude, zoom: 5)
            self.mapView.camera = camera
        }
    }
    
    @IBAction func logOutBtn(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure?", message: "If you delete this trip, all markers associated with this trip will be removed", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            self.dbRef.child(self.user!.uid).child("trips").child(self.trip!.id!).setValue(nil, withCompletionBlock: { (error, dbRef) in
                self.navigationController?.popViewController(animated: true)
            })
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel"), style: .cancel, handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func subButton(_ sender: Any) {
        if txtName.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "Trip requires name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            dbRef.child(user!.uid).child("trips").child(trip!.id!).updateChildValues(["name" : txtName.text!, "id" : trip!.id!]) { (error, dbRef) in
                if error == nil{
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}


extension ViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        let marker = GMSMarker()
        marker.position = coordinate
        marker.map = self.mapView
        dbRef.child(user!.uid).child("trips").child(trip!.id!).child("markers").childByAutoId().updateChildValues(["lat" : coordinate.latitude, "long" : coordinate.longitude]) { (error, dbRef) in
            
        }
    }
}

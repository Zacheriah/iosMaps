//
//  TripsViewController.swift
//  inClass12
//
//  Created by Wayman, Zacheriah on 4/17/19.
//  Copyright © 2019 Wayman, Zacheriah. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class TripsViewController: UIViewController {
    var trips = [Trip]()
    var currentTrip :Trip?
    var dbRef = DatabaseReference()
    let user = Auth.auth().currentUser
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newSeg"{
            let destinationvc = segue.destination as! ViewController
            destinationvc.trip = currentTrip
        }else{
            
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        trips.removeAll()
        currentTrip = nil
        dbRef.child(user!.uid).child("trips").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value != nil{
                for child in snapshot.children{
                    let trip = Trip()
                    let childSnapshot = child as! DataSnapshot
                    
                    if childSnapshot.hasChild("name"){
                        trip.name = (childSnapshot.childSnapshot(forPath: "name").value as! String)
                    }
                    
                    if childSnapshot.hasChild("id"){
                        trip.id = (childSnapshot.childSnapshot(forPath: "id").value as! String)
                    }
                    
                    if childSnapshot.hasChild("markers"){
                        self.dbRef.child(self.user!.uid).child("trips").child(trip.id!).child("markers").observe(.value, with: { (snapshot2) in
                            for children in snapshot2.children{
                                let marker = Marker()
                                let childSnapshot2 = children as! DataSnapshot
                                
                                if childSnapshot2.hasChild("long"){
                                    marker.long = childSnapshot2.childSnapshot(forPath: "long").value as! Double
                                }
                                
                                if childSnapshot2.hasChild("lat"){
                                    marker.lat = childSnapshot2.childSnapshot(forPath: "lat").value as! Double
                                }
                                trip.markers.append(marker)
                            }
                        })
                    }
                    self.trips.append(trip)
                    self.tableView.reloadData()
                }
            }
        }) { (error) in
            
        }
        
        
    }
    
    @IBAction func logOutBtn(_ sender: UIBarButtonItem) {
        do{
            try Auth.auth().signOut()
            AppDelegate.showLogin()
        }catch{
            print(error.localizedDescription)
        }
    }
    @IBAction func addButton(_ sender: Any) {
        
        performSegue(withIdentifier: "newSeg", sender: self)
        
    }
}

extension TripsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let trip = trips[indexPath.row]
        cell.textLabel?.text = trip.name!
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTrip = trips[indexPath.row]
        performSegue(withIdentifier: "newSeg", sender: self)
        print(currentTrip!.markers.count)
    }
}

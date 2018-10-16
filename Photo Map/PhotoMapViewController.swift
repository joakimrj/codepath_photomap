//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var photo: UIImage!
    
    var title: String? {
        return "\(coordinate.latitude)"
    }
}


class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate  {
    
    var vc = UIImagePickerController()
    var selectedImage: UIImage?

    @IBOutlet weak var mapView: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(37.783333, -122.416667), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mapView.setRegion(sfRegion, animated: false)
        
        
        vc.delegate = self
        vc.allowsEditing = true
        
        mapView.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = String(describing: locationCoordinate.latitude)
        annotation.subtitle = "Picture!"
        mapView.addAnnotation(annotation)
        
        self.navigationController?.popToViewController(self, animated: true)
        
    }

    @IBAction func onPhoto(_ sender: Any) {
        self.present(vc, animated: true, completion: nil)
    }

    

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[.originalImage] as! UIImage
        self.selectedImage = originalImage
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: {
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        })
    }
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height: 50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
            
        imageView.image = selectedImage
        
        return annotationView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! LocationsViewController
        destinationVC.delegate = self
    }
    
 
    

}

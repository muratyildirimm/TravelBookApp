
import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController {
  // MARK: IBOutlet
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var nameTF: UITextField!
  @IBOutlet weak var commentTF: UITextField!
  
  // MARK: Variables
  var locationManager = CLLocationManager()
  var chosenLatitude = Double()
  var chosenLongitude = Double()
  override func viewDidLoad() {
    super.viewDidLoad()
        getUsersLocation()
createGestureRecognizer()
    
  }
  // Get User's Current Location
  func getUsersLocation() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  func createGestureRecognizer() {
    let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
    gestureRecognizer.minimumPressDuration = 3
    mapView.addGestureRecognizer(gestureRecognizer)
  }
  @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer) {
    if gestureRecognizer.state == .began {
      let touchedPoint = gestureRecognizer.location(in: self.mapView)
      let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
      chosenLatitude = touchedCoordinates.latitude
      chosenLongitude = touchedCoordinates.longitude
      let annotation = MKPointAnnotation()
      annotation.coordinate = touchedCoordinates
      annotation.title = nameTF.text
      annotation.subtitle = commentTF.text
      self.mapView.addAnnotation(annotation)
    }
  }
  
  
  @IBAction func saveButton(_ sender: Any) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
    if let title = nameTF.text, let subtitle = commentTF.text {
      newPlace.setValue(title, forKey: "title")
      newPlace.setValue(subtitle, forKey: "subtitle")
      newPlace.setValue(UUID(), forKey: "id")
      newPlace.setValue(chosenLatitude, forKey: "latitude")
      newPlace.setValue(chosenLongitude, forKey: "longitude")
      do {
        try context.save()
        print("Date Save Operation Succeed")
      } catch {
        print(error.localizedDescription)
      }
    } else {
      self.popupAlert(title: "Notice", message: "Please enter name and comment", actionStyle: .default)
    }
    
 
    
  }
}


extension ViewController: MKMapViewDelegate {
  
}

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    // Get Location
    let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
    // Zoom
    let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    // Create Region
    let region = MKCoordinateRegion(center: location, span: span)
    mapView.setRegion(region, animated: true)
  }
}

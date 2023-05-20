
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
  // MARK: IBOutlet
  @IBOutlet weak var mapView: MKMapView!
  // MARK: Variables
  var locationManager = CLLocationManager()
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
      let annotation = MKPointAnnotation()
      annotation.coordinate = touchedCoordinates
      annotation.title = "New Annotation"
      annotation.subtitle = "Travel Book"
      self.mapView.addAnnotation(annotation)
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

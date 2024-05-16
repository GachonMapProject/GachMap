import SwiftUI
import MapKit
import CoreLocation

class CustomPathAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let name: String

    init(coordinate: CLLocationCoordinate2D, name: String) {
        self.coordinate = coordinate
        self.name = name
    }
}

struct ChoosePathView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var globalViewModel: GlobalViewModel
    @EnvironmentObject var navi: NavigationController

    @State private var region: MKCoordinateRegion
    @State private var lineCoordinates: [[CLLocationCoordinate2D]]
    @State var selectedPath: Int = 0

    @State var isAROn = false
    @State var isOnlyAROn = false
    @State var isOnlyMapOn = false

    @State var path: [PathTime]
    var locations = [CLLocation]()
    var nodes = [[Node]]()
    let startText: String
    let endText: String
    @State var isLogin: Bool = false
    
    // CLLocationManager 인스턴스 추가
    @StateObject private var locationManager = LocationManager()

    init(paths: [PathData], startText: String, endText: String) {
        self.startText = startText
        self.endText = endText

        var isLogin = false
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
            if loginInfo.userCode != nil {
                isLogin = true
                self.isLogin = isLogin
            }
        }

        var lines = [[CLLocationCoordinate2D]]()
        var pathTimes = [PathTime]()
        for path in paths {
            var coordinates = [CLLocationCoordinate2D]()
            var nodes = [Node]()
            for i in path.nodeList {
                let coordinate = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
                coordinates.append(coordinate)

                let location = CLLocation(coordinate: coordinate, altitude: i.altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
                locations.append(location)
                let node = Node(name: String(i.nodeId), id: i.nodeId, location: location)
                nodes.append(node)
            }
            self.nodes.append(nodes)

            let pathTime = PathTime(pathName: path.routeType, time: path.totalTime, isLogin: isLogin, line: coordinates)
            pathTimes.append(pathTime)
            lines.append(coordinates)
        }
        self.lineCoordinates = lines

        let centerLatitude = (paths[0].nodeList[0].latitude + paths[0].nodeList[paths[0].nodeList.count - 1].latitude) / 2
        let centerLongitude = (paths[0].nodeList[0].longitude + paths[0].nodeList[paths[0].nodeList.count - 1].longitude) / 2
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let meter = locations[0].distance(from: locations[locations.count - 1]) + 100
        region = MKCoordinateRegion(center: center, latitudinalMeters: meter, longitudinalMeters: meter)

        path = pathTimes
    }

    var body: some View {
        if !isAROn && !isOnlyMapOn {
            ZStack {
                MapView(region: region, lineCoordinates: path, selectedPath: $selectedPath, currentLocation: $locationManager.currentLocation, startText: startText)
                    .ignoresSafeArea()
                
                VStack {
                    VStack {
                        HStack {
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            })
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 40, height: 40)
                                    .shadow(radius: 5)
                            )
                            
                            
                            Spacer()
                            
                            Button(action: {
                                // dismiss()
                                globalViewModel.showSearchView = false
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            })
                            .background(
                                Circle()
                                    .fill(.white)
                                    .frame(width: 40, height: 40)
                                    .shadow(radius: 5)
                            )
                        }
                        .frame(width: UIScreen.main.bounds.width - 40)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }

                    VStack {
                        SearchPathView(startText: startText, endText: endText, isAROn: $isAROn, isOnlyMapOn: $isOnlyMapOn)
                        if isLogin {
                            AIDescriptionView()
                        }
                        Spacer()
                        PathTimeTestView(selectedPath: $selectedPath, path: path)
                            .padding(.bottom, 10)
                    }
                }
            }
        } else if isAROn && !isOnlyMapOn {
            let path = nodes[selectedPath]
            ARMainView(isAROn: $isAROn, path: path, departures: path[0].id, arrivals: path[path.count - 1].id)
        } else if !isAROn && isOnlyMapOn {
            OnlyMapView(path: nodes[selectedPath])
        }
    }
}

struct MapView: UIViewRepresentable {
    let region: MKCoordinateRegion
    let lineCoordinates: [PathTime]
    @Binding var selectedPath: Int
    @Binding var currentLocation: CLLocationCoordinate2D?
    let startText: String

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region

        for (index, lineCoordinate) in lineCoordinates.enumerated() {
            let polyline = MKPolyline(coordinates: lineCoordinate.line, count: lineCoordinate.line.count)
            if index == 0 && lineCoordinate.time != nil {
                polyline.title = "Path0"
                polyline.subtitle = "Path0"
            } else if index == 1 && lineCoordinate.time != nil {
                polyline.title = "Path1"
                polyline.subtitle = "Path1"
            } else if index == 2 && lineCoordinate.time != nil {
                polyline.title = "Path2"
                polyline.subtitle = "Path2"
            }
            mapView.addOverlay(polyline)
        }

        if startText == "현재 위치" {
            if let currentLocation = currentLocation {
                addMapMarker(for: currentLocation, with: "start", to: mapView)
            }
        } else {
            addMapMarker(for: lineCoordinates.first?.line.first, with: "start", to: mapView)
        }
        addMapMarker(for: lineCoordinates.first?.line.last, with: "end", to: mapView)
        
        if startText == "현재 위치", let currentLocation = currentLocation, let firstNode = lineCoordinates.first?.line.first {
            let coordinates = [currentLocation, firstNode]
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            polyline.title = "CurrentToFirstNode"
            mapView.addOverlay(polyline)
        }

        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        context.coordinator.parent = self
        view.removeOverlays(view.overlays)
        for (index, lineCoordinate) in lineCoordinates.enumerated() {
            let polyline = MKPolyline(coordinates: lineCoordinate.line, count: lineCoordinate.line.count)
            if index == 0 && lineCoordinate.time != nil {
                polyline.title = "Path0"
                polyline.subtitle = "Path0"
            } else if index == 1 && lineCoordinate.time != nil {
                polyline.title = "Path1"
                polyline.subtitle = "Path1"
            } else if index == 2 && lineCoordinate.time != nil {
                polyline.title = "Path2"
                polyline.subtitle = "Path2"
            }
            view.addOverlay(polyline)
        }

        if startText == "현재 위치" {
            if let currentLocation = currentLocation {
                addMapMarker(for: currentLocation, with: "start", to: view)
            }
        } else {
            addMapMarker(for: lineCoordinates.first?.line.first, with: "start", to: view)
        }
        addMapMarker(for: lineCoordinates.first?.line.last, with: "end", to: view)
        
        if startText == "현재 위치", let currentLocation = currentLocation, let firstNode = lineCoordinates.first?.line.first {
            let coordinates = [currentLocation, firstNode]
            let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
            polyline.title = "CurrentToFirstNode"
            view.addOverlay(polyline)
        }
    }

    private func addMapMarker(for coordinate: CLLocationCoordinate2D?, with title: String, to mapView: MKMapView) {
        guard let coordinate = coordinate else { return }
        let annotation = CustomPathAnnotation(coordinate: coordinate, name: title)
        mapView.addAnnotation(annotation)
    }

    func makeCoordinator() -> PathCoordinator {
        PathCoordinator(self)
    }
}

class PathCoordinator: NSObject, MKMapViewDelegate {
    var parent: MapView

    init(_ parent: MapView) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        
        if polyline.title == "CurrentToFirstNode" {
            renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 0.7)
            renderer.lineDashPattern = [1, 7] // 점선 패턴 설정
            renderer.lineWidth = 4
        } else if polyline.title == "Path0" {
            if parent.selectedPath == 0 {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            } else {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 0.5)
            }
            renderer.lineWidth = 8
        } else if polyline.title == "Path1" {
            if parent.selectedPath == 1 {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            } else {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 0.5)
            }
            renderer.lineWidth = 8
        } else if polyline.title == "Path2" {
            if parent.selectedPath == 2 {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            } else {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 0.5)
            }
            renderer.lineWidth = 8
        }

        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customPathAnnotation = annotation as? CustomPathAnnotation else { return nil }
        let reuseIdentifier = "customPathAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        let imageName = customPathAnnotation.name == "start" ? "startMarker" : "endMarker"

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: customPathAnnotation, reuseIdentifier: reuseIdentifier)
            if let image = UIImage(named: imageName) {
                let size = CGSize(width: 30, height: 41)
                let renderer = UIGraphicsImageRenderer(size: size)
                let resizedImage = renderer.image { context in
                    image.draw(in: CGRect(origin: .zero, size: size))
                }
                annotationView?.image = resizedImage
                annotationView?.centerOffset = CGPoint(x: 0, y: -20)
            }
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location.coordinate
    }
}

#Preview {
    ChoosePathView(paths: [GachMap.PathData(routeType: "SHORTEST", totalTime: Optional(0), nodeList: [GachMap.NodeList(nodeId: 281, latitude: 37.45092, longitude: 127.12745, altitude: 55.8), GachMap.NodeList(nodeId: 282, latitude: 37.45061, longitude: 127.12745, altitude: 55.8), GachMap.NodeList(nodeId: 186, latitude: 37.45068, longitude: 127.12719, altitude: 56.8)]), GachMap.PathData(routeType: "OPTIMAL", totalTime: Optional(0), nodeList: [GachMap.NodeList(nodeId: 281, latitude: 37.45092, longitude: 127.12745, altitude: 55.8), GachMap.NodeList(nodeId: 282, latitude: 37.45061, longitude: 127.12745, altitude: 55.8), GachMap.NodeList(nodeId: 186, latitude: 37.45068, longitude: 127.12719, altitude: 56.8)]), GachMap.PathData(routeType: "busRoute", totalTime: nil, nodeList: [])], startText: "기본", endText: "기본")
}

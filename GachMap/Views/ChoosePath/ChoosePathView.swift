//
//  ChoosePathView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

class CustomPathAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}


import SwiftUI
import MapKit

struct ChoosePathView: View {
    let paths = [Path().pathExmaple, Path().pathExmaple1, Path().pathExmaple2]
    @State private var region: MKCoordinateRegion
    @State private var lineCoordinates: [[CLLocationCoordinate2D]]
    @State var selectedPath : Int = 0   // 선택한 경로
    
    @State private var isAROn = false
    
    @State var test : [PathTime]
    
    init() {
        var locations = [CLLocation]()
        
        var lines = [[CLLocationCoordinate2D]]()
        for path in paths {
            var coordinates = [CLLocationCoordinate2D]()
            for i in path {
                locations.append(i.location)
                coordinates.append(i.location.coordinate)
            }
            lines.append(coordinates)
        }
        self.lineCoordinates = lines
        
        let centerLatitude = (paths[0][0].location.coordinate.latitude + paths[0][paths[0].count - 1].location.coordinate.latitude) / 2
        let centerLongitude = (paths[0][0].location.coordinate.longitude + paths[0][paths[0].count - 1].location.coordinate.longitude) / 2
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let meter = locations[0].distance(from: locations[locations.count - 1]) + 100
        region = MKCoordinateRegion(center: center, latitudinalMeters: meter, longitudinalMeters: meter)
        
        test = [PathTime(pathName: "최적 경로", time: "33", isLogin: true, line: lines[0]),
         PathTime(pathName: "무당이 경로", time: nil, isLogin: true, line: lines[1]),
         PathTime(pathName: "최단 경로", time: "3", isLogin: true, line: lines[2])
        ]
    }
    
    var body: some View {
        if !isAROn {
            ZStack{
                MapView(region: region, lineCoordinates: test, selectedPath : $selectedPath)
                    .ignoresSafeArea(.all)
                
                VStack{
                    ZStack(alignment : .trailing){
                        SearchMainView()
                        Button(action: {
                            isAROn = true
                        }, label: {
                            Text("길안내")
                        })
                        .frame(width: 50, height: 50)
                        
                    }
                    
                    AIDescriptionView() // 로그인 유무에 따라 바뀌게 설정
                    Spacer()
                    PathTimeTestView(selectedPath: $selectedPath, test: test)
                        .padding(.bottom, 10)
                }
            }
        }
        else{
            ARMainView(isAROn: $isAROn)
        }
    }
}


struct MapView: UIViewRepresentable {

  let region: MKCoordinateRegion
  let lineCoordinates: [PathTime]
    @Binding var selectedPath : Int

  func makeUIView(context: Context) -> MKMapView {
      print(lineCoordinates)
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.region = region

      for (index, lineCoordinate) in lineCoordinates.enumerated() {
          let polyline = MKPolyline(coordinates: lineCoordinate.line, count: lineCoordinate.line.count)
           if index == 0 && lineCoordinate.time != nil{
               polyline.title = "Path0"
               polyline.subtitle = "Path0" // Optional subtitle, not required
           } else if index == 1 && lineCoordinate.time != nil{
               polyline.title = "Path1"
               polyline.subtitle = "Path1" // Optional subtitle, not required
           }else if index == 2 && lineCoordinate.time != nil{
               polyline.title = "Path2"
               polyline.subtitle = "Path2" // Optional subtitle, not required
           }
           mapView.addOverlay(polyline)
       }
      
      addMapMarker(for: lineCoordinates.first?.line.first, with: "start", to: mapView)
      addMapMarker(for: lineCoordinates.last?.line.last, with: "end", to: mapView)
   

    return mapView
  }

  func updateUIView(_ view: MKMapView, context: Context) {
      print(selectedPath)
      context.coordinator.parent = self
      view.removeOverlays(view.overlays) // 모든 오버레이를 삭제하여 다시 그리도록 유도
      for (index, lineCoordinate) in lineCoordinates.enumerated() {
          let polyline = MKPolyline(coordinates: lineCoordinate.line, count: lineCoordinate.line.count)
          if index == 0 && lineCoordinate.time != nil{
              polyline.title = "Path0"
              polyline.subtitle = "Path0" // Optional subtitle, not required
          } else if index == 1 && lineCoordinate.time != nil {
              polyline.title = "Path1"
              polyline.subtitle = "Path1" // Optional subtitle, not required
          }else if index == 2 && lineCoordinate.time != nil{
              polyline.title = "Path2"
              polyline.subtitle = "Path2" // Optional subtitle, not required
          }
        view.addOverlay(polyline)
       }
      
      addMapMarker(for: lineCoordinates.first?.line.first, with: "start", to: view)
      addMapMarker(for: lineCoordinates.last?.line.last, with: "end", to: view)

  }
    
    private func addMapMarker(for coordinate: CLLocationCoordinate2D?, with title: String, to mapView: MKMapView) {
        guard let coordinate = coordinate else { return }
        let annotation = CustomPathAnnotation(coordinate: coordinate)
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
        print("mapView : \(parent.selectedPath)")
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }
        
        let renderer = MKPolylineRenderer(polyline: polyline)
        
        if polyline.title == "Path0" {
            if parent.selectedPath == 0 {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            } else {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 0.5)
            }
        } else if polyline.title == "Path1" {
            if parent.selectedPath == 1 {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            } else {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 0.5)
            }
        } else if polyline.title == "Path2" {
            if parent.selectedPath == 2 {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
            } else {
                renderer.strokeColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 0.5)
            }
        }

        renderer.lineWidth = 10
        return renderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         guard let customPathAnnotation = annotation as? CustomPathAnnotation else { return nil }
         let reuseIdentifier = "customPathAnnotation"
         var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

         if annotationView == nil {
             annotationView = MKAnnotationView(annotation: customPathAnnotation, reuseIdentifier: reuseIdentifier)
             annotationView?.image = UIImage(named: "PathDot") // Set custom marker image based on annotation title
             annotationView?.canShowCallout = false
         } else {
             annotationView?.annotation = annotation
         }

         return annotationView
     }
}
#Preview {
    ChoosePathView()
}

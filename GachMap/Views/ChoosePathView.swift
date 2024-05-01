//
//  ChoosePathView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI
import MapKit

struct ChoosePathView: View {
    let paths = [Path().ITtoGachon, Path().ITtoGlobal]
    @State private var region: MKCoordinateRegion
    @State private var lineCoordinates: [[CLLocationCoordinate2D]]
    init() {
        region = MKCoordinateRegion(center: Path().ITtoGachon[0].location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        
        var lines = [[CLLocationCoordinate2D]]()
        for path in paths {
            var coordinates = [CLLocationCoordinate2D]()
            for i in path {
                coordinates.append(i.location.coordinate)
            }
            lines.append(coordinates)
        }
        self.lineCoordinates = lines
    }
    
    var body: some View {
        ZStack{
            MapView(region: region, lineCoordinates: lineCoordinates)
                .ignoresSafeArea(.all)
            
            VStack{
                SearchMainView()
                Spacer()
                PathTimeTestView()
                    .padding(.bottom, 10)
            }
           
            
        }
    }
}


struct MapView: UIViewRepresentable {

  let region: MKCoordinateRegion
  let lineCoordinates: [[CLLocationCoordinate2D]]

  func makeUIView(context: Context) -> MKMapView {
      print(lineCoordinates)
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.region = region

      for (index, lineCoordinate) in lineCoordinates.enumerated() {
           let polyline = MKPolyline(coordinates: lineCoordinate, count: lineCoordinate.count)
           if index == 0 {
               polyline.title = "Path1"
               polyline.subtitle = "Path1" // Optional subtitle, not required
           } else if index == 1 {
               polyline.title = "Path2"
               polyline.subtitle = "Path2" // Optional subtitle, not required
           }
           mapView.addOverlay(polyline)
       }
   

    return mapView
  }

  func updateUIView(_ view: MKMapView, context: Context) {}

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
        
        if polyline.title == "Path1" {
            renderer.strokeColor = .blue
        } else if polyline.title == "Path2" {
            renderer.strokeColor = .red
        }
        
        renderer.lineWidth = 7
        return renderer
    }
}
#Preview {
    ChoosePathView()
}

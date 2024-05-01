//
//  ChoosePathView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI
import MapKit

struct ChoosePathView: View {
    let paths = [Path().pathExmaple, Path().pathExmaple1, Path().pathExmaple2]
    @State private var region: MKCoordinateRegion
    @State private var lineCoordinates: [[CLLocationCoordinate2D]]
    @State var selectedPath : Int = 0   // 선택한 경로
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
            MapView(region: region, lineCoordinates: lineCoordinates, selectedPath : $selectedPath)
                .ignoresSafeArea(.all)
            
            VStack{
                SearchMainView()
                Spacer()
                PathTimeTestView(selectedPath: $selectedPath)
                    .padding(.bottom, 10)
            }
           
            
        }
    }
}


struct MapView: UIViewRepresentable {

  let region: MKCoordinateRegion
  let lineCoordinates: [[CLLocationCoordinate2D]]
    @Binding var selectedPath : Int

  func makeUIView(context: Context) -> MKMapView {
      print(lineCoordinates)
    let mapView = MKMapView()
    mapView.delegate = context.coordinator
    mapView.region = region

      for (index, lineCoordinate) in lineCoordinates.enumerated() {
           let polyline = MKPolyline(coordinates: lineCoordinate, count: lineCoordinate.count)
           if index == 0 {
               polyline.title = "Path0"
               polyline.subtitle = "Path0" // Optional subtitle, not required
           } else if index == 1 {
               polyline.title = "Path1"
               polyline.subtitle = "Path1" // Optional subtitle, not required
           }else if index == 2 {
               polyline.title = "Path2"
               polyline.subtitle = "Path2" // Optional subtitle, not required
           }
           mapView.addOverlay(polyline)
       }
   

    return mapView
  }

  func updateUIView(_ view: MKMapView, context: Context) {
      print(selectedPath)
      context.coordinator.parent = self
      view.removeOverlays(view.overlays) // 모든 오버레이를 삭제하여 다시 그리도록 유도
      for (index, lineCoordinate) in lineCoordinates.enumerated() {
           let polyline = MKPolyline(coordinates: lineCoordinate, count: lineCoordinate.count)
          if index == 0 {
              polyline.title = "Path0"
              polyline.subtitle = "Path0" // Optional subtitle, not required
          } else if index == 1 {
              polyline.title = "Path1"
              polyline.subtitle = "Path1" // Optional subtitle, not required
          }else if index == 2 {
              polyline.title = "Path2"
              polyline.subtitle = "Path2" // Optional subtitle, not required
          }
        view.addOverlay(polyline)
       }

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
}
#Preview {
    ChoosePathView()
}

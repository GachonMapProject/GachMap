//
//  ChoosePathView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

class CustomPathAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let name : String

    init(coordinate: CLLocationCoordinate2D, name :String) {
        self.coordinate = coordinate
        self.name = name
    }
}


import SwiftUI
import MapKit

struct ChoosePathView: View {
//    let paths = [Path().pathExmaple, Path().pathExmaple1, Path().pathExmaple2]
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var globalViewModel: GlobalViewModel
    @EnvironmentObject var navi: NavigationController
    
    @State private var region: MKCoordinateRegion
    @State private var lineCoordinates: [[CLLocationCoordinate2D]]
    @State var selectedPath : Int = 0   // 선택한 경로
    
    @State var isAROn = false       // AR 찾다 돌아갈 때 다시 이전 화면으로 돌아감
    @State var isOnlyAROn = false   // 출발지 현재위치일 경우 AR
    @State var isOnlyMapOn = false  // 출발지 현재위치 아닐 경우 지도 따라가기
    
    @State var path : [PathTime]
    var locations = [CLLocation]()
    var nodes = [[Node]]()
    let startText : String
    let endText : String
    @State var isLogin : Bool = false
    init(paths : [PathData], startText : String, endText : String) {
        self.startText = startText
        self.endText = endText
        
        
        // 로그인 유뮤 가져오기
        var isLogin = false
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
            print("loginInfo.userCode: \(String(describing: loginInfo.userCode))")
            print("loginInfo.guestCode: \(String(describing: loginInfo.guestCode))")
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
//        print("------------------------------------")
//        print(path)
//        path = [PathTime(pathName: "최적 경로", time: 33, isLogin: isLogin, line: lines[1]),
//         PathTime(pathName: "최단 경로", time: 3, isLogin: isLogin, line: lines[0]),
//         PathTime(pathName: "무당이 경로", time: nil, isLogin: isLogin, line: lines[2])
//        ]
    }
    
    var body: some View {
        if !isAROn && !isOnlyMapOn {
            ZStack{
                MapView(region: region, lineCoordinates: path, selectedPath : $selectedPath)
                    .ignoresSafeArea()
                VStack{
                    VStack{
                        HStack {
                            // 뒤로 가기 버튼
                            Button(action: {
                                dismiss()
                            }, label: {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            })
                            
                            Spacer()
                            
                            // 검색창 종료 버튼
                            Button(action: {
                                // 버튼을 눌렀을 때 내비게이션 스택을 모두 지우고 root 뷰로 돌아가기
                                dismiss()
                                globalViewModel.showSearchView = false
                                
                                print("go rootView")
                            }, label: {
                                Image(systemName: "xmark")
                                    .font(.title2)
                                    .foregroundColor(.black)
                            })
                        }
                        .frame(width: UIScreen.main.bounds.width - 40)
                        //                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }
                    
                    
                    VStack{
                        SearchPathView(startText: startText, endText: endText, isAROn : $isAROn, isOnlyMapOn : $isOnlyMapOn)
                        if isLogin{
                            AIDescriptionView() // 로그인 유무에 따라 바뀌게 설정
                        }
                        Spacer()
                        PathTimeTestView(selectedPath: $selectedPath, path: path)
                            .padding(.bottom, 10)
                    }
                }
//                NavigationLink("", isActive: $isOnlyMapOn) {
//                    OnlyMapView(path: nodes[selectedPath])
//                        .navigationBarBackButtonHidden()
//
//                }
//                NavigationLink("", isActive: $isAROn) {
//                    let path = nodes[selectedPath]
//                    ARMainView(path: path, departures:  path[0].id, arrivals:  path[path.count - 1].id)
//                        .navigationBarBackButtonHidden()
//
//                }
            } // end of ZStack
        }
        else if isAROn && !isOnlyMapOn{
            let path = nodes[selectedPath]
            ARMainView(isAROn : $isAROn, path: path, departures:  path[0].id, arrivals:  path[path.count - 1].id)
        }
        else if !isAROn && isOnlyMapOn {
            OnlyMapView(path: nodes[selectedPath])
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
      addMapMarker(for: lineCoordinates.first?.line.last, with: "end", to: mapView)
   

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
      addMapMarker(for: lineCoordinates.first?.line.last, with: "end", to: view)

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

        renderer.lineWidth = 8
        return renderer
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         guard let customPathAnnotation = annotation as? CustomPathAnnotation else { return nil }
         let reuseIdentifier = "customPathAnnotation"
         var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        let image = customPathAnnotation.name == "start" ? "startMarker" : "endMarker"

         if annotationView == nil {
             annotationView = MKAnnotationView(annotation: customPathAnnotation, reuseIdentifier: reuseIdentifier)
             if let image = UIImage(named: image) {
                 let size = CGSize(width: 30, height: 41) // 원하는 크기로 설정
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

#Preview {
    ChoosePathView(paths: [GachMap.PathData(routeType: "SHORTEST", totalTime: Optional(0), nodeList: [GachMap.NodeList(nodeId: 281, latitude: 37.45092, longitude: 127.12745, altitude: 55.8), GachMap.NodeList(nodeId: 282, latitude: 37.45061, longitude: 127.12745, altitude: 55.8), GachMap.NodeList(nodeId: 186, latitude: 37.45068, longitude: 127.12719, altitude: 56.8)]), GachMap.PathData(routeType: "OPTIMAL", totalTime: Optional(0), nodeList: [GachMap.NodeList(nodeId: 281, latitude: 37.45092, longitude: 127.12745, altitude: 55.8), GachMap.NodeList(nodeId: 282, latitude: 37.45061, longitude: 127.12745, altitude: 55.8), GachMap.NodeList(nodeId: 186, latitude: 37.45068, longitude: 127.12719, altitude: 56.8)]), GachMap.PathData(routeType: "busRoute", totalTime: nil, nodeList: [])], startText: "기본", endText: "기본")
}

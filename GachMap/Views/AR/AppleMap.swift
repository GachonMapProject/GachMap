import SwiftUI
import MapKit

class CustomAnnotation: NSObject, MKAnnotation, Identifiable{
    let id = UUID()
    var customImage : UIImage
    var coordinate : CLLocationCoordinate2D
    var reuseIdentifier: String  // 추가
    init(customImage : UIImage, coordinate : CLLocationCoordinate2D, reuseIdentifier : String){
        self.customImage = customImage
        self.coordinate = coordinate
        self.reuseIdentifier = reuseIdentifier
        super.init()
    }
}

struct AppleMapView : View{
    @EnvironmentObject var coreLocation : CoreLocationEx
    let path : [Node]
    @Binding var isARViewVisible: Bool
    @State private var appleMap: AppleMap
    let rotationList : [Rotation]
    let onlyMap : Bool

    init(path: [Node], isARViewVisible: Binding<Bool>, rotationList : [Rotation], onlyMap : Bool, coreLocation : CoreLocationEx) {
        self.path = path
        self._isARViewVisible = isARViewVisible
        self.rotationList = rotationList
        self.onlyMap = onlyMap
        
        _appleMap = State(initialValue: AppleMap(path: path, coreLocation: coreLocation, isOnlyMapOn: false))
    }
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            if isARViewVisible {
                    appleMap
                    .frame(height: 300)
                    .edgesIgnoringSafeArea(.all)
//                    .onAppear(){
//                        appleMap.setRegionToUserLocation()
//                    }
                    
            }
            else{
                appleMap
                    .ignoresSafeArea(.all)
//                    .onAppear(){
//                        appleMap.setRegionToUserLocation()
//                    }
                ScrollView(.horizontal){
                    ZStack(){
                        LazyHStack{
                            ForEach(rotationList) { rotation in
                                NavigationInfoView(distance: Int(rotation.distance), rotation: rotation.rotation)
                                    .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1.0 : 0.8)
                                            .scaleEffect(phase.isIdentity ? 1.0 : 0.8)
                                    }
                            }
                        } // end of LazyStack
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
                        .scrollTargetLayout()
                        
                    } // end of ZStack
                    
                } // end of ScrollView
                .scrollTargetBehavior(.viewAligned)
                .frame(height: UIScreen.main.bounds.width * 0.3)
            }
            if !onlyMap{
                VStack(spacing: 0){
                    Button(action: {
                        isARViewVisible.toggle()
                    },
                           label: {Text(isARViewVisible ? "2D" : "AR")
                    })
                    .frame(width: 45, height: 50)
                    .foregroundColor(.gray)
                    .bold()
                    
                    Divider().background(.gray) // 중앙선

                    Button(action: {
                        // 버튼을 누를 때 현재 위치를 중심으로 지도의 중심을 설정하는 함수 호출
                        appleMap.setRegionToUserLocation()
                    },
                           label: {Image(systemName: "location")
                    })
                    .frame(width: 45, height: 50)
                    .foregroundColor(.gray)
                    .bold()
                    
                }
                .frame(width: 45, height: 100)
                .background(.white)
                .cornerRadius(15)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: isARViewVisible ? 40 : 40 + UIScreen.main.bounds.width * 0.3, trailing: 20)) // bottomTrailing 마진 추가
            }
            else {
                VStack {
                    Button(action: {
                        // 버튼을 누를 때 현재 위치를 중심으로 지도의 중심을 설정하는 함수 호출
                        appleMap.setRegionToUserLocation()
                    },
                           label: {Image(systemName: "location")
                    })
                    .frame(width: 45, height: 50)
                    .foregroundColor(.gray)
                    .bold()
                }
                .frame(width: 50, height: 50)
                .background(.white)
                .cornerRadius(15)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: isARViewVisible ? 40 : 40 + UIScreen.main.bounds.width * 0.3, trailing: 20)) // bottomTrailing 마진 추가

            }

        }
    }
}


struct AppleMap: UIViewRepresentable {
    var mapView = MKMapView()
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    @State var isCameraFixed : Bool = true
    @ObservedObject var coreLocation : CoreLocationEx
    let isOnlyMapOn : Bool
    
    // coreLocation이 변경될 때마다 init 됨
    init(path : [Node], coreLocation : CoreLocationEx, isOnlyMapOn : Bool) {
        self.coreLocation = coreLocation
        self.isOnlyMapOn = isOnlyMapOn
        region = MKCoordinateRegion(
            center: isOnlyMapOn ? path[0].location.coordinate : coreLocation.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
            latitudinalMeters: 200,
            longitudinalMeters: 200
        )
  
        lineCoordinates =  path.map{CLLocationCoordinate2D(latitude: $0.location.coordinate.latitude, longitude: $0.location.coordinate.longitude)
        }
    }
    
    // 현재 위치를 기반으로 지도의 중심을 설정하는 함수
    func setRegionToUserLocation() {
        if let userLocation = self.coreLocation.location {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.region = region
        }
    }
    
  // Create the MKMapView using UIKit.
    func makeUIView(context: Context) -> MKMapView {
        
        mapView.delegate = context.coordinator
        mapView.region = region
//        mapView.userTrackingMode  = .followWithHeading
      
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)

        // 출발지 표시 마커 추가
        if let startImage = UIImage(named: "startMarker") {
            let startAnnotation = CustomAnnotation(customImage: startImage, coordinate: lineCoordinates.first!, reuseIdentifier: "start")
            mapView.addAnnotation(startAnnotation)
        }
        
        // 경로 중간 노드 표시 (출발, 도착 제외)
        if let middleImage = UIImage(named: "circlebadge"){
            for i in 1..<lineCoordinates.count - 1{
                let middleAnnotation = CustomAnnotation(customImage: middleImage, coordinate: lineCoordinates[i], reuseIdentifier: "middle")
                mapView.addAnnotation(middleAnnotation)
            }
        }
      
        
        // 도착지 표시 마커 추가
        if let destinationImage = UIImage(named: "endMarker") {
            let destinationAnnotation = CustomAnnotation(customImage: destinationImage, coordinate: lineCoordinates.last!, reuseIdentifier: "end")
            mapView.addAnnotation(destinationAnnotation)
        }
        
        mapView.showsUserLocation = true
        
        return mapView
    }

  // We don't need to worry about this as the view will never be updated.
  func updateUIView(_ view: MKMapView, context: Context) {
      
      
//      view.setUserTrackingMode(.followWithHeading, animated: true)
      if isCameraFixed && !isOnlyMapOn{
          
//          print("updateUIView - isCameraFixed (true)")
          if let userLocation = coreLocation.location {
              let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 150, longitudinalMeters: 150)
              mapView.region = region
          }
      }
      
      // 사용자 위치를 추적합니다.
      // follow : 현재 위치를 보여줍니다.
      // followWithHeading : 핸드폰 방향에 따라 지도를 회전시켜 보여줍니다.(앞에 레이더 포함)
//      view.userTrackingMode  = .follow
      
//
//      // 이것도 사용자 위치를 추적하는데, 애니메이션 효과가 추가 되어 부드럽게 화면 확대 및 이동
//      view.setUserTrackingMode(.follow, animated: true) 
      
      
  }

  // Link it to the coordinator which is defined below.
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
    

}

class Coordinator: NSObject, MKMapViewDelegate {
  var parent: AppleMap

  init(_ parent: AppleMap) {
    self.parent = parent
  }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      if let routePolyline = overlay as? MKPolyline {
        let renderer = MKPolylineRenderer(polyline: routePolyline)
        renderer.strokeColor = UIColor.systemBlue
        renderer.lineWidth = 8
        return renderer
      }
      return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            // 사용자 위치 표시 마커를 커스텀 이미지로 설정
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
            annotationView.image = UIImage(named: "userLocation")?.resizedAndScaledToFit(targetSize: CGSize(width: 25, height: 25))


//            annotationView.frame.size = CGSize(width: 25, height: 27)
//            if let image = UIImage(systemName: "location.north.fill") {
//                let coloredImage = image.withTintColor(.red)
//                annotationView.image = coloredImage.resize(targetSize: CGSize(width: 40, height: 40))
//            }
            
            return annotationView
        }
        else if let customAnnotation = annotation as? CustomAnnotation {
            // CustomAnnotation 객체인 경우
            if customAnnotation.reuseIdentifier == "middle" {
                // 중간 노드 어노테이션일 때
                if let middleImage = UIImage(named: "middleNode"){
                    //                    let resizedImage = middleImage.resize(targetSize: CGSize(width: 100, height: 100))
                    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "middle")
                    annotationView.image = middleImage
                    annotationView.frame.size = CGSize(width: 15, height: 15)
                    return annotationView
                }
            } else if customAnnotation.reuseIdentifier == "start" {
                if let image = UIImage(named: "startMarker") {
                    let size = CGSize(width: 30, height: 41) // 원하는 크기로 설정
                    let renderer = UIGraphicsImageRenderer(size: size)
                    let resizedImage = renderer.image { context in
                        image.draw(in: CGRect(origin: .zero, size: size))
                    }
                    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: customAnnotation.reuseIdentifier)
                    annotationView.image = resizedImage
                    annotationView.centerOffset = CGPoint(x: 0, y: -20)
                    return annotationView
                }
            } else if  customAnnotation.reuseIdentifier == "end" {
                if let image = UIImage(named: "endMarker") {
                    let size = CGSize(width: 30, height: 41) // 원하는 크기로 설정
                    let renderer = UIGraphicsImageRenderer(size: size)
                    let resizedImage = renderer.image { context in
                        image.draw(in: CGRect(origin: .zero, size: size))
                    }
                    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: customAnnotation.reuseIdentifier)
                    annotationView.image = resizedImage
                    annotationView.centerOffset = CGPoint(x: 0, y: -20)
                    return annotationView
                }
            }
//            } else if customAnnotation.reuseIdentifier == "start" {
//                // 출발지 어노테이션일 때
//                if let startImage = UIImage(named: "Start3") {
//                    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "start")
//                    annotationView.image = startImage
//                    annotationView.frame.size = CGSize(width: 40, height: 30)
//                    return annotationView
//                }
//            } else if customAnnotation.reuseIdentifier == "destination" {
//                // 도착지 어노테이션일 때
//                if let destinationImage = UIImage(systemName: "flag.fill") {
//                    let coloredImage = destinationImage.withTintColor(.red)
//                    let resizedImage = coloredImage.resize(targetSize: CGSize(width: 40, height: 40))
//                    let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "destination")
//                    annotationView.image = resizedImage
//                    annotationView.frame.size = CGSize(width: 30, height: 30)
//                    return annotationView
//                }
//            }
        }

        return nil
    }
    
    // 사용자가 지도를 이동시킬 때 호출되는 메서드
      func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
          // 사용자가 지도를 이동시키면 카메라 고정 해제
          self.parent.isCameraFixed = false
          
          // 지도 회전 각도를 얻어와서 마커의 회전 각도를 설정
//            let rotation = mapView.camera.heading
//            mapView.annotations.forEach { annotation in
//                if let annotationView = mapView.view(for: annotation) {
//                    annotationView.transform = CGAffineTransform(rotationAngle: CGFloat(rotation) * .pi / 180)
//                }
//            }
      }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        // 현재 지도의 확대/축소 수준을 추정합니다.
//        print("mapView.camera.altitude : \(mapView.camera.altitude)")
        
        var markerSize = CGSize()
        switch mapView.camera.altitude {
        // 확대 수준에 따라 마커 크기를 조정
        case 0..<300:
            markerSize = CGSize(width: 40, height: 40)
        case 300..<500:
            markerSize = CGSize(width: 36, height: 36)
        case 500..<700:
            markerSize = CGSize(width: 33, height: 33)
        case 700..<1000:
            markerSize = CGSize(width: 30, height: 30) //
        default:
            markerSize = CGSize(width: 25, height: 25) // 기본 마커 크기
        }
        
        // 중간 노드를 제외한 모든 마커에 대해 크기를 조정합니다.
        mapView.annotations.forEach { annotation in
            if let annotationView = mapView.view(for: annotation) {
                if let customAnnotation = annotation as? CustomAnnotation {
                    if customAnnotation.reuseIdentifier != "middle" {
//                        annotationView.frame.size = markerSize
                    }
                }
            }
           
        }
    }


}

// UIImage extension to resize image
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize = widthRatio > heightRatio ?  CGSize(width: size.width * heightRatio, height: size.height * heightRatio) : CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func resizedAndScaledToFit(targetSize: CGSize) -> UIImage? {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
}

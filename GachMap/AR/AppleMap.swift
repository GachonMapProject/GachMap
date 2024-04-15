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
    @ObservedObject var coreLocation : CoreLocationEx
    let path : [Node]
    @Binding var isARViewVisible: Bool
    @State private var appleMap: AppleMap

    init(coreLocation: CoreLocationEx, path: [Node], isARViewVisible: Binding<Bool>) {
        self.coreLocation = coreLocation
        self.path = path
        self._isARViewVisible = isARViewVisible
        _appleMap = State(initialValue: AppleMap(coreLocation: coreLocation, path: path))
    }
    var body: some View {
        ZStack(alignment: .bottomTrailing){
            if isARViewVisible {
                    appleMap.frame(height: 300)
            }
            else{
                appleMap.ignoresSafeArea(.all)
            }
          
            VStack(spacing: 0){
                Button(action: {
                    isARViewVisible.toggle()
                },
                       label: {Text(isARViewVisible ? "2D" : "AR")})
                .frame(width: 45, height: 50)
                .foregroundColor(.gray)
                .bold()
                
                Divider().background(.gray) // 중앙선

                Button(action: {
                    // 버튼을 누를 때 현재 위치를 중심으로 지도의 중심을 설정하는 함수 호출
                    appleMap.setRegionToUserLocation()
                },
                       label: {Image(systemName: "location")})
                .frame(width: 45, height: 50)
                .foregroundColor(.gray)
                .bold()
                
            }
            .frame(width: 45, height: 100)
            .background(.white)
            .cornerRadius(15)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 20)) // bottomTrailing 마진 추가
        
        }
    }
}


struct AppleMap: UIViewRepresentable {
    var mapView = MKMapView()
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    let coreLocation : CoreLocationEx
    @State var isCameraFixed : Bool = true
    
    // coreLocation이 변경될 때마다 init 됨
    init(coreLocation: CoreLocationEx, path : [Node]) {
        self.coreLocation = coreLocation
        region = MKCoordinateRegion(
            center: coreLocation.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
            latitudinalMeters: 100,
            longitudinalMeters: 100
        )

        lineCoordinates =  path.map{CLLocationCoordinate2D(latitude: $0.location.coordinate.latitude, longitude: $0.location.coordinate.longitude)
        }
        print("init")
    }
    // 현재 위치를 기반으로 지도의 중심을 설정하는 함수
    func setRegionToUserLocation() {
        if let userLocation = coreLocation.location {
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 150, longitudinalMeters: 150)
            mapView.setRegion(region, animated: true)
        }
    }
    
  // Create the MKMapView using UIKit.
    func makeUIView(context: Context) -> MKMapView {
        mapView.delegate = context.coordinator
        mapView.region = region
        
        mapView.userTrackingMode  = .followWithHeading
      
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)

        // 출발지 표시 마커 추가
        if let destinationImage = UIImage(named: "Start3") {
            let resizedImage = destinationImage.resize(targetSize: CGSize(width: 100, height: 60))
            let destinationAnnotation = CustomAnnotation(customImage: resizedImage, coordinate: lineCoordinates.first!, reuseIdentifier: "start")
            mapView.addAnnotation(destinationAnnotation)
        }
        
        // 도착지 표시 마커 추가
        if let destinationImage = UIImage(systemName: "flag.fill") {
            let resizedImage = destinationImage.resize(targetSize: CGSize(width: 40, height: 40))
            let coloredResizedImage = resizedImage.withTintColor(.red)
            let destinationAnnotation = CustomAnnotation(customImage: coloredResizedImage, coordinate: lineCoordinates.last!, reuseIdentifier: "destination")
            mapView.addAnnotation(destinationAnnotation)
        }
        
//        mapView.showsUserLocation = true
        
        setRegionToUserLocation()
        return mapView
    }

  // We don't need to worry about this as the view will never be updated.
  func updateUIView(_ view: MKMapView, context: Context) {
      
      
//      view.setUserTrackingMode(.followWithHeading, animated: true)
      if isCameraFixed {
          
          print("updateUIView - isCameraFixed (true)")
          if let userLocation = coreLocation.location {
              let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
              view.setRegion(region, animated: true)
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
            annotationView.image = UIImage(named: "userLocationIcon")?.resize(targetSize: CGSize(width: 30, height: 30))
//            annotationView.frame.size = CGSize(width: 30, height: 30)
//            if let image = UIImage(systemName: "location.north.fill") {
//                let coloredImage = image.withTintColor(.red)
//                annotationView.image = coloredImage.resize(targetSize: CGSize(width: 40, height: 40))
//            }
            
            return annotationView
        }
        else if let customAnnotation = annotation as? CustomAnnotation {
                // CustomAnnotation 객체인 경우
                if customAnnotation.reuseIdentifier == "start" {
                    // 출발지 어노테이션일 때
                    if let startImage = UIImage(named: "Start3") {
                        let resizedImage = startImage.resize(targetSize: CGSize(width: 100, height: 60))
                        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "start")
                        annotationView.image = resizedImage
                        annotationView.frame.size = CGSize(width: 30, height: 30)
                        return annotationView
                    }
                } else if customAnnotation.reuseIdentifier == "destination" {
                    // 도착지 어노테이션일 때
                    if let destinationImage = UIImage(systemName: "flag.fill") {
                        let coloredImage = destinationImage.withTintColor(.red)
                        let resizedImage = coloredImage.resize(targetSize: CGSize(width: 40, height: 40))
                        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "destination")
                        annotationView.image = resizedImage
                        annotationView.frame.size = CGSize(width: 30, height: 30)
                        return annotationView
                    }
                }
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
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        
//        // 현재 지도의 확대/축소 수준을 추정합니다.
//        print("mapView.camera.altitude : \(mapView.camera.altitude)")
//        
//        // 마커의 새로운 크기를 계산합니다.
//        let markerSize: CGSize
//        switch mapView.camera.altitude {
//        case 0..<350:
//            markerSize = CGSize(width: 30, height: 30) // 확대 수준에 따라 마커 크기를 조정합니다.
//        case 350..<1000:
//            markerSize = CGSize(width: 25, height: 25) // 다른 확대 수준에 대한 마커 크기를 지정합니다.
//        default:
//            markerSize = CGSize(width: 20, height: 20) // 기본 마커 크기
//        }
//        
//        // 모든 마커에 대해 크기를 조정합니다.
//        mapView.annotations.forEach { annotation in
//            if let annotationView = mapView.view(for: annotation) {
//                annotationView.frame.size = markerSize
//            }
//        }
//    }


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
}

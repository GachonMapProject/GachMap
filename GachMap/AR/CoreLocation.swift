//
//  CoreLocationEx.swift
//  Location_Example
//
//  Created by 이수현 on 2024/01/28.
//

import SwiftUI
import CoreLocation

class CoreLocationEx: NSObject, ObservableObject, CLLocationManagerDelegate {

    @Published var location: CLLocation?
    @Published var heading: CLLocationDirection?

    var locationManager = CLLocationManager()   // locationManager 인스턴스를 생성하여 위치 관련 작업을 수행

    // 초기화 메서드에서 ‘setupLocationManager’ 메서드를 호출하여 locationManager의 설정 초기화
    override init() {
        super.init()
        self.setupLocationManager()
    }

    func setupLocationManager() {
        locationManager.delegate = self                                          // locationManager의 delegate를 현재 클래스로 설정
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation   // 위치 정확도를 kCLLocationAccuracyBest로 설정
        locationManager.requestWhenInUseAuthorization()                          // 위치 서비스를 사용하기 위한 권한 요청

        // 위치 서비스가 활성화 되어있으면 위치 업데이트 시작, 현재 위치 좌표 출력
        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On 상태")
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            print(locationManager.location?.coordinate as Any)
        } else {
            print("위치 서비스 Off 상태")
        }
    }

    // 위치 정보가 업데이트 될 때 호출되는 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
            DispatchQueue.main.async {
               self.location = newLocation
            }
        
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//
//        self.heading = newHeading.trueHeading   // 디바이스의 진북 기준 각도 (0도 ~ 359도)
////        print("진북 기준 각도: \(self.heading ?? 0)")
//          
//   }

    
    /*
     This method can cause UI unresponsiveness if invoked on the main thread. Instead, consider waiting for the `-locationManagerDidChangeAuthorization:` callback and checking `authorizationStatus` first.
     -> 비동기처리 하지 않으면 위와 같은 오류 발생
     
     locationManagerDidChangeAuthorization 메서드 내에서
     DispatchQueue.global().async 를 사용하면,
     checkUserDeviceLocationServiceAuthorization 메서드가 백그라운드 스레드에서 비동기적으로 실행되게 됨
     → 현재 메인 스레드가 차단되지 않고 다른 작업 수행 가능
     
     */
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.global().async {
            self.checkUserDeviceLocationServiceAuthorization()
        }
    }

    // 디바이스와 앱에 대한 위치 서비스 활성화 상태 확인 메서드
    func checkUserDeviceLocationServiceAuthorization() {
        
        // 3.1 디바이스 자체에 위치 서비스가 활성화 상태인지 확인
       guard CLLocationManager.locationServicesEnabled() else {
           // 시스템 설정으로 유도하는 커스텀 얼럿
           showRequestLocationServiceAlert()
           return
       }
           
           
       // 3.2 앱에 대한 권한 상태 확인
       let authorizationStatus: CLAuthorizationStatus
           
       // 앱의 권한 상태 가져오는 코드 (iOS 버전에 따라 분기처리)
       if #available(iOS 14.0, *) {
           authorizationStatus = locationManager.authorizationStatus
       } else {
           authorizationStatus = CLLocationManager.authorizationStatus()
       }
           
       // 권한 상태값에 따라 분기처리를 수행하는 메서드 실행
       checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    
    
    // 앱에 대한 위치 권한이 부여된 상태인지 확인하는 메서드
    func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus) {
        switch status {
            
            // 사용자가 권한에 대한 설정을 선택하지 않은 상태
            case .notDetermined:

               // 권한 요청을 보내기 전에 desiredAccuracy 설정 필요 (정확도 기준)
               locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
               
               // 권한 요청
               locationManager.requestWhenInUseAuthorization()
                   
            // 사용자가 명시적으로 권한을 거부했거나, 위치 서비스 활성화가 제한된 상태
            case .denied, .restricted:
               
               // 시스템 설정으로 유도하는 커스텀 얼럿
               showRequestLocationServiceAlert()
               
            // 앱을 사용중일 때, 위치 서비스를 이용할 수 있는 상태
            case .authorizedWhenInUse:
               
               // manager 인스턴스를 사용하여 사용자의 위치를 가져옴
               locationManager.startUpdatingLocation()
               
            default:
                print("Default")
       }
   }
       
       
       
       // 설정으로 이동하는 알림
       func showRequestLocationServiceAlert() {
           let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
           let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
               if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(appSetting)
               }
           }
           requestLocationServiceAlert.addAction(goSetting)
       }
}

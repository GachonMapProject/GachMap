//
//  ARCampusView.swift
//  GachMap
//
//  Created by 이수현 on 5/17/24.
//

import SwiftUI
import Alamofire
import CoreLocation

struct ARCampusView: View {
    @EnvironmentObject var coreLocation : CoreLocationEx
    @EnvironmentObject var nextNodeObject : NextNodeObject
    @Environment(\.dismiss) private var dismiss
    @State var ARInfo: [ARInfo]? = nil
    
    @State private var isARViewReady = false
    @State private var trueNorthAlertOn = false // 일정 정확도 이내일 때만 ARView 표시를 위한 상태 변수
    @State private var isEnd = false // 안내 종료 상태 변수
    @State private var selectedTrueNorth = false
    
    let intervalTime : Double = 7.0
    
    @State private var checkTime: Timer? // AR init 후 시간 체크
    @State private var checkSecondTime: Timer?
    @State var checkSecond = 0
    
    @State var showGPSAlertBool = false
    @State var showGPSAlert = false
    @State var showReloadAlert = false
    @State var showServerAlert = false
    @State var showTrueNorthAlert = false

    
    var body: some View {
        VStack {
//            if !trueNorthAlertOn {
//                if !selectedTrueNorth {
//                    ProgressView()
//                        .onAppear(){
//                            getARCampus()
//                        }
//                        .alert(isPresented: $showTrueNorthAlert) {
//                            Alert(
//                                title: Text("진북 설정"),
//                                message: Text("나침반을 진북으로 설정하면\n향상된 AR 서비스를 이용하실 수 있습니다."),
//                                primaryButton: .default(Text("확인")) {
//                                    trueNorthAlertOn = true
//                                },
//                                secondaryButton: .default(Text("설정으로 이동")) {
//                                    selectedTrueNorth = true
//                                    openSettings()
//                                }
//                            )
//                        }
//                }
//                else{
//                    Image("MuhanMiddle")
//                        .resizable()
//                        .frame(width: 200, height: 200)
//                        .scaledToFit()
//                        .padding(.bottom, 30)
//                    Button(action: {
//                        trueNorthAlertOn = true
//                    }, label: {
//                        Text("진북 설정 완료")
//                    })
//                    .frame(width: 200, height: 50)
//                    .background(.blue)
//                    .cornerRadius(15)
//                    .shadow(radius: 5, x: 2, y: 2)
//                    .foregroundColor(.white)
//                    .bold()
//                    .font(.system(size: 20))
//                }
//            } // end of if !trueNorthAlertOn
//            else{
                if !isARViewReady{
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(checkSecond % 2 == 0 ? .gray : .blue)
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 30)
                        .onAppear(){
                            getARCampus()
                            checkSecondTime = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
                                checkSecond += 1
                            }
                        }
                        .alert(isPresented: $showServerAlert) {
                            Alert(
                                title: Text("오류"),
                                message: Text("서버 연결에 실패했습니다."),
                                dismissButton: .default(Text("확인")) {
                                    dismiss()
                                }
                            )
                        }
                        .alert(isPresented: $showGPSAlert) {
                             Alert(
                                 title: Text("알림"),
                                 message: Text("GPS 신호가 불안정합니다. \n실내 혹은 높은 건물 주변은 \nGPS 신호가 불안정 할 수 있습니다."),
                                 primaryButton: .default(Text("재시도")) {
                                     showGPSAlertBool = false
                                     self.checkTime?.invalidate()
                                     self.checkTime = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: false) { _ in
                                         showGPSAlertBool = true
                                     }
                                 },
                                 secondaryButton: .default(Text("취소")) {
                                     self.checkSecondTime?.invalidate()
                                     self.checkTime?.invalidate()
                                     dismiss()
                                 }
                             )
                         }
                    ProgressView("GPS 신호를 찾고 있습니다.")
                        .onAppear {
                            // 타이머 시작
                            checkTime = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: false) { _ in
//                                GPSAlert()
                                showGPSAlertBool = true
                                showGPSAlert = true
                            }
                        }
                    
                } // end of if !isARViewReady
                else {
                    if ARInfo != nil {
                        ZStack(alignment: .topTrailing) {
                            ZStack {
                                ARCampusWrapperView(ARInfo: ARInfo ?? [])
                                    .edgesIgnoringSafeArea(.all)
                                    .onAppear(){
                                        checkSecondTime?.invalidate()
                                        checkTime?.invalidate()
                                    }
                                if !nextNodeObject.isARReady {
                                    ProgressAlertView(isARRoading: true)
                                }
                            }
                           
                            HStack {
                                Button(){
//                                    ReloadButtonAlert()
                                    showReloadAlert = true
                                    print("showReloadAlert : \(showReloadAlert)")
                                } label: {
                                    HStack{
                                        Image(systemName: "gobackward")
                                            .foregroundColor(.white)
                                        Text("AR 재로드")
                                            .foregroundStyle(.white)
                                    }
                                    .padding(8) // 내부 콘텐츠를 감싸는 패딩 추가
                                    .background(.blue)
                                    .cornerRadius(15) // 둥글게 만들기 위한 코너 반지름 설정
                                    
                                }
                                .alert(isPresented: $showReloadAlert) {
                                    Alert(
                                        title: Text("AR 재로드"),
                                        message: Text("AR을 재로드 하시겠습니까?"),
                                        primaryButton: .destructive(Text("확인")) {
                                            isARViewReady = false
                                        },
                                        secondaryButton: .cancel(Text("취소"))
                                    )
                                }
     
                                
                                Button(action: {
                                    dismiss()
                                }, label: {
                                    HStack {
                                        Image(systemName: "xmark.circle")
                                            .foregroundColor(.white)
                                        Text("AR 종료")
                                            .foregroundColor(.white)
                                    }
                                    .padding(8)
                                    .background(Color.blue)
                                    .cornerRadius(15) // 둥글게 만들기 위한 코너 반지름 설정
                                })
                            }
                            .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                        } // end of ZStack

                    } // end of if ARInfo != nil
                }
//            } // end of if !trueNorthAlertOn else
        } // end of VStack
        .onChange(of: coreLocation.location ?? CLLocation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), altitude: 0)) { location in
            if !isARViewReady && !showGPSAlertBool{
                print("checkAccuracy")
                checkLocationAccuracy()
            }
        }
    }
    
    
    // AR 건물 리스트 가져오기
    func getARCampus() {
        
        guard let location = coreLocation.location else{
            print("location x")
            return
        }
// http://ceprj.gachon.ac.kr:60002/map/ar?latitude=37.44535&longitude=127.12673&altitude=54
        
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/ar?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&altitude=\(location.altitude)") else {
            print("getARCampus - Invalid URL")
            return
        }
        
        // Alamofire를 사용하여 Get 요청 생성
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: ARImageResponse.self) { response in
                // 에러 처리
                switch response.result {
                case .success(let value):
                    // 성공적인 응답 처리
                    if let data = value.data {
                        print(data)
                        print("getARCampus() - AR 리스트 가져오기 성공")
                        showTrueNorthAlert = true
                        ARInfo = data
                        
                    } else {
                        print("nilData")
                        showServerAlert = true
//                        ServerAlert()
                    }
                    
                case .failure(let error):
                    // 에러 응답 처리
                    print("Error: \(error.localizedDescription)")
//                    ServerAlert()
                    showServerAlert = true
                }
            }
    }
//    
//    func ReloadButtonAlert(){
//        // 버튼을 눌렀을 때 경고 창 표시
//            let alert = UIAlertController(title: "AR 재로드", message: "AR을 재로드 하시겠습니까?", preferredStyle: .alert)
//            
//            // 확인 액션 추가
//            alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
//               isARViewReady = false
//            })
//            
//            // 취소 액션 추가
//            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
//            
//            // 경고 창을 현재 화면에 표시
//            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
//    
//    func ServerAlert(){
//        // 버튼을 눌렀을 때 경고 창 표시
//        let alert = UIAlertController(title: "오류", message: "서버 연결에 실패했습니다.", preferredStyle: .alert)
//            
//        // 확인 액션 추가
//        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
//                dismiss()
//            })
//
//        // 경고 창을 현재 화면에 표시
//        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
//    
//    // 진북 알림
//    func trueNorthAlert(){
//        // 버튼을 눌렀을 때 경고 창 표시
//        let alert = UIAlertController(title: "진북 설정", message: "나침반을 진북으로 설정하면\n향상된 AR 서비스를 이용하실 수 있습니다.", preferredStyle: .alert)
//        
//        // 확인 액션 추가
//        alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
//            trueNorthAlertOn = true
//        })
//        
//        // 이동 액션 추가
//        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
//            selectedTrueNorth = true
//            openSettings()
//        })
//            
//        // 경고 창을 현재 화면에 표시
//        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
//        
    func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    // GPS 알림
//    func GPSAlert() {
//        showGPSAlertBool = true
//        let alert = UIAlertController(title: "알림", message: "GPS 신호가 불안정합니다. \n실내 혹은 높은 건물 주변은 \nGPS 신호가 불안정 할 수 있습니다.", preferredStyle: .alert)
//        
//        alert.addAction(UIAlertAction(title: "재시도", style: .default) { _ in
//            // '재시도' 버튼을 누르면 타이머를 다시 시작하고 초기화를 시도합니다.
//            showGPSAlertBool = false
//            self.checkTime?.invalidate()
//            self.checkTime = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: false) { _ in
//                GPSAlert()
//            }
//        })
//        
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
//            // '취소' 버튼을 누르면 이전 화면으로 이동합니다.
//            self.checkSecondTime?.invalidate()
//            self.checkTime?.invalidate()
//            dismiss()
//
//            
//        })
//        
//        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
        
    func checkLocationAccuracy() {
        // Check location accuracy
        DispatchQueue.main.async {
            if let location = coreLocation.location {
                let horizontalAccuracy = location.horizontalAccuracy
                let verticalAccuracy = location.verticalAccuracy
                
                if horizontalAccuracy < LocationAccuracy.accuracy && verticalAccuracy < LocationAccuracy.accuracy {
                    isARViewReady = true
                }
            }
        }
    }
}

//#Preview {
//    ARCampusView()
//}

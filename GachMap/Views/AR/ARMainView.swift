//
//  ARView.swift
//  GachonMapProject
//
//  Created by 이수현 on 4/8/24.
//

import SwiftUI
import MapKit
import Alamofire


struct ARMainView: View {

//    @Binding var isAROn : Bool
    // 전역으로 CoreLocationEx 인스턴스 생성
    @EnvironmentObject var coreLocation : CoreLocationEx
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var nextNodeObject : NextNodeObject
    @EnvironmentObject var timer : MyTimer
    
    @State private var isARViewVisible = true // ARView의 on/off 상태 변수
    @State private var isEnd = false // 안내 종료 상태 변수
    @State private var isARViewReady = false    // 일정 정확도 이내일 때만 ARView 표시를 위한 상태 변수
    @State private var onlyMap = false
    @State private var trueNorthAlertOn = false
    @State private var checkTime: Timer? // AR init 후 시간 체크
    @State private var selectedTrueNorth = false

    @State var ARInfo: [ARInfo]? = nil
    
    
    let intervalTime : Double = 7.0
    
    @State private var checkSecondTime: Timer?
    @State var checkSecond = 0
    
    let checkRotation = CheckRotation()
    @State var rotationList: [Rotation]? = nil      // 중간 노드의 회전과 거리를 나타낸 배열
    
//    let timer = MyTimer()
//    let path = Path().ITtoGachon
    @Binding var isAROn : Bool // ChoosePathView로 돌아갈 때
    let path : [Node]
    let departures : Int
    let arrivals : Int
    @State var timeList = [TimeList]()

    @State var distance : Double?
//    @State var timeList = [Int]()
    
    @State var showTrueNorthAlert = true
    @State var showEndAlert = false
    @State var showReloadAlert = false
    @State var showServerAlert = false
    @State var showGPSAlert = false
    @State var showGPSAlertBool = false
    
    
    var body: some View {
//        if coreLocation.location != nil{
            VStack{
                if !trueNorthAlertOn {
                    if !selectedTrueNorth {
                        ProgressView()
                            .onAppear(){
                                getARCampus()
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
                            .alert(isPresented: $showTrueNorthAlert) {
                                Alert(
                                    title: Text("진북 설정"),
                                    message: Text("나침반을 진북으로 설정하면\n향상된 AR 서비스를 이용하실 수 있습니다."),
                                    primaryButton: .default(Text("확인")) {
                                        trueNorthAlertOn = true
                                    },
                                    secondaryButton: .default(Text("설정으로 이동")) {
                                        selectedTrueNorth = true
                                        openSettings()
                                    }
                                )
                            }
                    }
                    else{
                      Image("MuhanMiddle")
                          .resizable()
                          .frame(width: 200, height: 200)
                          .scaledToFit()
                          .padding(.bottom, 30)
                      Button(action: {
                          trueNorthAlertOn = true
                      }, label: {
                          Text("진북 설정 완료")
                      })
                      .frame(width: 200, height: 50)
                      .background(.blue)
                      .cornerRadius(15)
                      .shadow(radius: 5, x: 2, y: 2)
                      .foregroundColor(.white)
                      .bold()
                      .font(.system(size: 20))
                    }
                } // end of if !trueNorthAlertOn
                else{
                    if !isARViewReady {
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(checkSecond % 2 == 0 ? .gray : .blue)
                            .frame(width: 100, height: 100)
                            .padding(.bottom, 30)
                            .onAppear(){
                                checkSecondTime = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
                                    checkSecond += 1
                                    print(checkSecond)
                                }
                            }
                        ProgressView("GPS 신호를 찾고 있습니다.")
                            .onAppear {
                                // 타이머 시작
                                checkTime = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: false) { _ in
//                                    showGPSAlert()
                                    showGPSAlertBool = true
                                    showGPSAlert = true
                                }
                            }
                            .actionSheet(isPresented: $showGPSAlert) {
                                 ActionSheet(
                                     title: Text("알림"),
                                     message: Text("GPS 신호가 불안정합니다. \n실내 혹은 높은 건물 주변은 \nGPS 신호가 불안정 할 수 있습니다."),
                                     buttons: [
                                         .default(Text("재시도")) {
                                             showGPSAlertBool = false
                                             showGPSAlert = false
                                             self.checkTime?.invalidate()
                                             self.checkTime = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: false) { _ in
//                                                 showGPSAlert()
                                                 showGPSAlert = true
                                             }
                                         },
                                         .default(Text("지도만 이용")) {
                                             self.checkSecondTime?.invalidate()
                                             self.checkTime?.invalidate()
                                             isARViewReady = true
                                             isARViewVisible = false
                                             rotationList = checkRotation.checkRotation(currentLocation: coreLocation.location!, path: path)
                                             onlyMap = true
                                         },
                                         .cancel(Text("취소")) {
                                             self.checkSecondTime?.invalidate()
                                             self.checkTime?.invalidate()
                                             isAROn = false
                                         }
                                     ]
                                 )
                             }
                    }
                    else {
                        if !isEnd { // 안내 종료 상태변수
                            if !onlyMap{    // 지도만 이용 상태변수
                                ZStack(alignment: .topTrailing){
                                    VStack(spacing : 0){
                                        ZStack{
                                            ARCLViewControllerWrapper(path: path, rotationList : rotationList ?? [], ARInfo: ARInfo ?? [])
                                            if !nextNodeObject.isARReady {
                                                ProgressAlertView(isARRoading: true)
                                            }
                                        }
                                        AppleMapView(path: path, isARViewVisible: $isARViewVisible, rotationList: rotationList!, onlyMap: onlyMap, coreLocation: coreLocation)
                                    }.edgesIgnoringSafeArea(.all)
                                    
                                    if !isARViewVisible {
                                        AppleMapView(path: path, isARViewVisible: $isARViewVisible, rotationList: rotationList!, onlyMap: onlyMap, coreLocation: coreLocation)
                                    }
                                    
                                    HStack {
                                        if isARViewVisible{
                                            Button(){
//                                                ReloadButtonAlert()
                                                showReloadAlert = true
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
                                        }
                                        Button(){
//                                            EndButtonAlert()
                                            showEndAlert = true
                                        } label: {
                                            HStack{
                                                Image(systemName: "xmark.circle")
                                                    .foregroundColor(.white)
                                                Text("안내 종료")
                                                    .foregroundStyle(.white)
                                            }
                                            .padding(8) // 내부 콘텐츠를 감싸는 패딩 추가
                                            .background(.blue)
                                            .cornerRadius(15) // 둥글게 만들기 위한 코너 반지름 설정
                                            
                                        }
                                        .alert(isPresented: $showEndAlert) {
                                             Alert(
                                                 title: Text("안내 종료"),
                                                 message: Text("경로 안내를 종료하시겠습니까?"),
                                                 primaryButton: .destructive(Text("확인")) {
                                                     timer.stopTimer() // 안내 종료 누르면 타이머 stop
                                                     nextNodeObject.nextIndex = 0
                                                     isEnd = true      // 확인을 눌렀을 때의 처리: 다음 페이지로 이동
                                                 },
                                                 secondaryButton: .cancel(Text("취소"))
                                             )
                                         }
                                    }
                                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: isARViewVisible ? 10 : 55))
                                }
                                .onAppear(){
                                    checkSecondTime?.invalidate()
                                    checkTime?.invalidate()
                                }
                            } // end of if !onlyMap (지도만 이용)
                            else{
                                ZStack(alignment: .topTrailing){
                                    AppleMapView(path: path, isARViewVisible: $isARViewVisible, rotationList: rotationList!, onlyMap: onlyMap, coreLocation: coreLocation)
                                    
                                    Button(){
//                                        EndButtonAlert()
                                        showEndAlert = true
                                    } label: {
                                        HStack{
                                            Image(systemName: "xmark.circle")
                                                .foregroundColor(.white)
                                            Text("안내 종료")
                                                .foregroundStyle(.white)
                                        }
                                        .padding(8) // 내부 콘텐츠를 감싸는 패딩 추가
                                        .background(.blue)
                                        .cornerRadius(15) // 둥글게 만들기 위한 코너 반지름 설정
                                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                                    }
                                    .alert(isPresented: $showEndAlert) {
                                         Alert(
                                             title: Text("안내 종료"),
                                             message: Text("경로 안내를 종료하시겠습니까?"),
                                             primaryButton: .destructive(Text("확인")) {
                                                 timer.stopTimer() // 안내 종료 누르면 타이머 stop
                                                 nextNodeObject.nextIndex = 0
                                                 isEnd = true      // 확인을 눌렀을 때의 처리: 다음 페이지로 이동
                                             },
                                             secondaryButton: .cancel(Text("취소"))
                                         )
                                     }
                                }
                            }
                            
//                            Text(String(format: "남은 거리: %.2f", distance ?? 0.0))
//                            Text("다음 인덱스 : \(nextNodeObject.nextIndex)")
//                            Text("측정 시간 : \(timer.seconds)")
//                            Text("시간 리스트 : \(String(describing: timeList))")
                        } // end of if !isEnd
                        else{
                            // 안내 종료 버튼 누르면 실행됨 (만족도 조사 뷰로 변경해야 됨)
                            SatisfactionView(departures: departures, arrivals: arrivals, timeList: timeList)
                        }
                    }

                }
                
  
               
            
            }  // end of VStack
            .onChange(of: coreLocation.location ?? CLLocation(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), altitude: 0)) { location in
                if !isARViewReady && !showGPSAlertBool{
                    print("checkAccuracy")
                    checkLocationAccuracy()
                }
                else if isARViewReady && !isEnd{
                    // 사용자 현재 위치와 다음 노드까지의 거리를 구하는 함수
                    print("checkDistance")
                    checkDistance(location: location)
                }
            }
    }
    
    // GPS 알림
//    func showGPSAlert() {
//        showGPSAlertBool = true
//        let alert = UIAlertController(title: "알림", message: "GPS 신호가 불안정합니다. \n실내 혹은 높은 건물 주변은 \nGPS 신호가 불안정 할 수 있습니다.", preferredStyle: .actionSheet)
//        
//        alert.addAction(UIAlertAction(title: "재시도", style: .default) { _ in
//            // '재시도' 버튼을 누르면 타이머를 다시 시작하고 초기화를 시도합니다.
//            showGPSAlertBool = false
//            self.checkTime?.invalidate()
//            self.checkTime = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: false) { _ in
//                showGPSAlert()
//            }
//        })
//        
//        alert.addAction(UIAlertAction(title: "지도만 이용", style: .default){ _ in
//            self.checkSecondTime?.invalidate()
//            self.checkTime?.invalidate()
//            isARViewReady = true
//            isARViewVisible = false
//            rotationList = checkRotation.checkRotation(currentLocation: coreLocation.location!, path: path)
//            onlyMap = true
//        })
//                        
//        
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
//            // '취소' 버튼을 누르면 이전 화면으로 이동합니다.
//            self.checkSecondTime?.invalidate()
//            self.checkTime?.invalidate()
//            
////            self.isAROn = false  // 이전 화면으로 돌아감
////            dismiss()
//            isAROn = false
//            
//        })
//        
//        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
//    }
    
    
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

    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    
    
    // 사용자 위치가 바뀔 떄마다 호출 (다음 노드까지의 거리 계산)
    func checkDistance(location : CLLocation){
        let index = nextNodeObject.nextIndex
        print("index : \(index)")
        
        // 마지막 노드에 도착 이후부터는 실행 안 되게
        if index < path.count {
            let distance = location.distance(from: path[index].location)
            self.distance = distance
            if distance <= 5 {
                print("\(path[index].name) - 5m 이내 ")
                // timer 로직 추가
                if index == 0 {
                    timer.startTimer()  // 첫 노드 근처에 오면 타이머 시작
                    print("timer 시작")
                    nextNodeObject.increment()
                }else{
                    let time = timer.seconds
                    let list = TimeList(firstNodeId: path[index - 1].id, secondNodeId: path[index].id, time: time)
                    timeList.append(list)
                    // timer (노드-노드, 시간) 배열 생성 후 append 하고 만족도 페이지에 넘겨서 Request 요청해야 됨
                    print(path[index-1].name + "~" + path[index].name + "까지 : \(time)초")
                    timer.stopTimer()
                    timer.startTimer()
                    nextNodeObject.increment()
                }
                
                
                print("nextNodeObject.nextIndex : \(nextNodeObject.nextIndex)")
            } // end of (if distance <= 5 )
        }
        else{
            // 목적지에 도착하면 timer.stopTimer()
            showEndAlert = true
            timer.stopTimer()
        }
    }   // end of checkDistance()
    
    func checkLocationAccuracy() {
        // Check location accuracy
        DispatchQueue.main.async {
            if let location = coreLocation.location {
                let horizontalAccuracy = location.horizontalAccuracy
                let verticalAccuracy = location.verticalAccuracy
                
                if horizontalAccuracy < LocationAccuracy.accuracy && verticalAccuracy < LocationAccuracy.accuracy {
                    // 정확도 범위 안에 들면 해당 위치 기준으로 중간 노드의 회전 방향, 거리를 가져옴
                    rotationList = checkRotation.checkRotation(currentLocation: location, path: path)
                    isARViewReady = true
                }
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
                        ARInfo = data
                    } else {
                        print("nilData")
//                        ServerAlert()
                        showServerAlert = true
                    }
                    
                case .failure(let error):
                    // 에러 응답 처리
                    print("Error: \(error.localizedDescription)")
//                    ServerAlert()
                    showServerAlert = true
                }
            }
    }
}

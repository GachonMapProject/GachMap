//
//  ARReadyView.swift
//  GachMap
//
//  Created by 이수현 on 5/6/24.
//

import SwiftUI

struct ARReadyView: View {
    @ObservedObject var coreLocation : CoreLocationEx
    @State var trueNorthAlertOn : Bool = false
    @State var selectedNorthAlertOn : Bool = false
    @State private var selectedTrueNorth = false
    
    @Binding var isARViewReady : Bool  // 일정 정확도 이내일 때만 ARView 표시를 위한 상태 변수
    @Binding var isARReadyViewOn : Bool        // AR을 처음 띄우는가
    @State private var showGPSAlert = false // GPS 신호 알림
    
    @State private var checkTime: Timer? // AR init 후 시간 체크
    let intervalTime : Double = 7.0
    
    @State private var checkSecondTime: Timer?
    @State var checkSecond = 0
    
    var body: some View {
        VStack{
            if !trueNorthAlertOn {
                if !selectedTrueNorth {
                    ProgressView()
                        .onAppear(){
                            trueNorthAlert()
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
                                showGPSAlert = true
                            }
                        }
                        .alert(isPresented: $showGPSAlert) {
                        Alert(
                            title: Text("알림"),
                            message: Text("GPS 신호가 불안정합니다.\n \n실내 혹은 높은 건물 주변은 \nGPS 신호가 불안정 할 수 있습니다."),
                            primaryButton: .default(Text("재시도")) {
                                // '재시도' 버튼을 누르면 타이머를 다시 시작하고 초기화를 시도합니다.
                                showGPSAlert = false
                                checkTime?.invalidate()
                                checkTime = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: false) { _ in
                                    showGPSAlert = true
                                }
                            },
                            secondaryButton: .cancel(Text("취소")) {
                                // '취소' 버튼을 누르면 이전 화면으로 이동합니다.
                                showGPSAlert = false
                                checkSecondTime?.invalidate()
                                checkTime?.invalidate()
                                
                                isARReadyViewOn = false  // 이전 화면으로 돌아감
                                
                            }
                        )
                    }
                } // end of if !isARViewReady
                else {
                   
                }
            }
        } // end of VStack
        .onChange(of: coreLocation.location!) { location in
            checkLocationAccuracy()
        }
                
    } // end of body
    
    // 진북 알림
    func trueNorthAlert(){
        // 버튼을 눌렀을 때 경고 창 표시
        let alert = UIAlertController(title: "진북 설정", message: "나침반을 진북으로 설정하면\n향상된 AR 서비스를 이용하실 수 있습니다.", preferredStyle: .alert)
        
        // 확인 액션 추가
        alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
            trueNorthAlertOn = true
        })
        
        // 이동 액션 추가
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            selectedTrueNorth = true
            openSettings()
        })
            
        // 경고 창을 현재 화면에 표시
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // 설정으로 이동
    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
    
    // 위치 정확도 확인
    func checkLocationAccuracy() {
        // Check location accuracy
        DispatchQueue.main.async {
            if let location = coreLocation.location {
                let horizontalAccuracy = location.horizontalAccuracy
                let verticalAccuracy = location.verticalAccuracy
                
                if horizontalAccuracy < LocationAccuracy.accuracy && verticalAccuracy < LocationAccuracy.accuracy {
                    // 정확도 범위 안에 들면 해당 위치 기준으로 중간 노드의 회전 방향, 거리를 가져옴
//                    rotationList = checkRotation.checkRotation(currentLocation: location, path: path)
                    isARViewReady = true
                    isARReadyViewOn = false
                }
            }
        }
    }
}

//#Preview {
//    ARReadyView()
//}

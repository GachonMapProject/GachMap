//
//  ARView.swift
//  GachonMapProject
//
//  Created by 이수현 on 4/8/24.
//

import SwiftUI
import MapKit


struct ARMainView: View {

    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()
    @ObservedObject var nextNodeObject = NextNodeObject()
    @State private var isARViewVisible = true // ARView의 on/off 상태 변수
    @State private var isEnd = false // 안내 종료 상태 변수
    @State private var isARViewReady = false    // 일정 정확도 이내일 때만 ARView 표시를 위한 상태 변수
    


//    @State var isCameraFixed : Bool = true
    let path = Path().ITtoGachon
    
    
    var body: some View {
        if coreLocation.location != nil{
            VStack{
                if !isARViewReady {
                    ProgressView("Initializing AR...")
                    Text("수평 정확도 : \(coreLocation.location!.horizontalAccuracy)")
                    Text("수직 정확도 : \(coreLocation.location!.verticalAccuracy)")
                }
                else {
                    if !isEnd {
                        ZStack(alignment: .topTrailing){
                            VStack{
                                ARView(coreLocation: coreLocation, nextNodeObject: nextNodeObject, bestHorizontalAccuracy: coreLocation.location!.horizontalAccuracy, bestVerticalAccuracy: coreLocation.location!.verticalAccuracy, 
                                       location : coreLocation.location!, path: path)
                                
                                AppleMapView(coreLocation: coreLocation, path: path, isARViewVisible: $isARViewVisible)
                            }.edgesIgnoringSafeArea(.bottom)
                            
                            if !isARViewVisible {
                                AppleMapView(coreLocation: coreLocation, path: path, isARViewVisible: $isARViewVisible)
                            }
                            
                            Button(){
                                ButtonAlert()
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
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: isARViewVisible ? 10 : 55))

                        }
                    }
                    else{
                        // 안내 종료 버튼 누르면 실행됨 (만족도 조사 뷰로 변경해야 됨)
                        NewScreenView()
                    }
                }
            
            }  // end of VStack
            .onChange(of: coreLocation.location) { _ in
                if !isARViewReady {
                    checkLocationAccuracy()
                }
            }
        } // end of coreLocation.location != nil
        else {
            ProgressView("Waiting for location accuracy...")
        }
    }
    
    func ButtonAlert(){
        // 버튼을 눌렀을 때 경고 창 표시
            let alert = UIAlertController(title: "안내 종료", message: "경로 안내를 종료하시겠습니까?", preferredStyle: .alert)
            
            // 확인 액션 추가
            alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
                // 확인을 눌렀을 때의 처리: 다음 페이지로 이동
                isEnd = true
            })
            
            // 취소 액션 추가
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            // 경고 창을 현재 화면에 표시
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
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

// 임시 뷰
struct NewScreenView: View {
    var body: some View {
        Text("만족도 조사")
    }
}

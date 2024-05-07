//
//  ARView.swift
//  GachonMapProject
//
//  Created by 이수현 on 4/8/24.
//

import SwiftUI
import MapKit


struct ARMainView: View {

//    @Binding var isAROn : Bool
    // 전역으로 CoreLocationEx 인스턴스 생성
    @ObservedObject var coreLocation = CoreLocationEx()         // ObservedObject를 생성하는 것이 아닌 넘겨 받는 걸로 수정해야 됨 
    @ObservedObject var nextNodeObject = NextNodeObject()
    @State var isARViewVisible = false // ARView의 on/off 상태 변수
    @State var isEnd = false // 안내 종료 상태 변수
    @State var isARViewReady = false    // 일정 정확도 이내일 때만 ARView 표시를 위한 상태 변수
    @State var isARReadyViewOn = false  // AR을 처음 띄우는가


    let checkRotation = CheckRotation()
    @State var rotationList: [Rotation]? = nil      // 중간 노드의 회전과 거리를 나타낸 배열
    
    let timer = MyTimer()
    let path = Path().homeToAI
    
    var body: some View {
        if coreLocation.location != nil{
            VStack{
                if !isEnd {
                    if rotationList != nil {
                        ZStack(alignment: .topTrailing){
                            AppleMapView(coreLocation: coreLocation, path: path, isARViewVisible: $isARViewVisible, isARViewReady: $isARViewReady, isARReadyViewOn: $isARReadyViewOn, rotationList: rotationList!)
                                .zIndex(isARViewVisible ? 0 : 1) // 첫 번째 뷰
                            
                            if isARViewReady && isARViewVisible{
                                VStack{
                                    ARCLViewControllerWrapper(nextNodeObject: nextNodeObject, path: path, rotationList : rotationList ?? [])
                                    AppleMapView(coreLocation: coreLocation, path: path, isARViewVisible: $isARViewVisible, isARViewReady: $isARViewReady, isARReadyViewOn: $isARReadyViewOn, rotationList: rotationList!)
                                }
                                .edgesIgnoringSafeArea(.all)
                                .zIndex(isARViewVisible ? 1 : 0) // 첫 번째 뷰
                            }
                            HStack {
                                if !isARReadyViewOn {
                                    if isARViewVisible{
                                        Button(){
                                            ReloadButtonAlert()
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
                                    }
                                    Button(){
                                        EndButtonAlert()
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
                                }
                            }
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: isARViewVisible ? 10 : 55))
                            .zIndex(2)
                        }
                        .onAppear(){
    //                        checkSecondTime?.invalidate()
    //                        checkTime?.invalidate()
                        }
                    }
                }
                else{
                    // 안내 종료 버튼 누르면 실행됨 (만족도 조사 뷰로 변경해야 됨)
                    SatisfactionView()
                }
            }  // end of VStack
            .onChange(of: coreLocation.location!) { location in
                if !isARViewReady {
//                    checkLocationAccuracy()
                    if rotationList == nil {
                        rotationList = checkRotation.checkRotation(currentLocation: location, path: path)
                    }
                }
                else {
                    // 사용자 현재 위치와 다음 노드까지의 거리를 구하는 함수
                    checkDistance(location: location)
                }
            }
        } // end of coreLocation.location != nil
        else {
            ProgressView("Waiting for location accuracy...")
                .onAppear(){
                    if let location = coreLocation.location{
                        
                    }
                }
        }
    }
    
    func EndButtonAlert(){
        // 버튼을 눌렀을 때 경고 창 표시
            let alert = UIAlertController(title: "안내 종료", message: "경로 안내를 종료하시겠습니까?", preferredStyle: .alert)
            
            // 확인 액션 추가
            alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
                timer.stopTimer() // 안내 종료 누르면 타이머 stop
                isEnd = true      // 확인을 눌렀을 때의 처리: 다음 페이지로 이동
            })
            
            // 취소 액션 추가
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            // 경고 창을 현재 화면에 표시
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func ReloadButtonAlert(){
        // 버튼을 눌렀을 때 경고 창 표시
            let alert = UIAlertController(title: "AR 재로드", message: "AR을 재로드 하시겠습니까?", preferredStyle: .alert)
            
            // 확인 액션 추가
            alert.addAction(UIAlertAction(title: "확인", style: .destructive) { _ in
               isARViewReady = false
            })
            
            // 취소 액션 추가
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            // 경고 창을 현재 화면에 표시
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    // 사용자 위치가 바뀔 떄마다 호출 (다음 노드까지의 거리 계산)
    func checkDistance(location : CLLocation){
        let index = nextNodeObject.nextIndex
        
        // 마지막 노드에 도착 이후부터는 실행 안 되게
        if index != path.count {
            let distance = location.distance(from: path[index].location)
            if distance <= 2 {
                print("\(path[index].name) - 2m 이내 ")
                // timer 로직 추가
                if index == 0 {
                    timer.startTimer()  // 첫 노드 근처에 오면 타이머 시작
                    print("timer 시작")
                }else{
                    let time = timer.seconds
                    
                    // timer (노드-노드, 시간) 배열 생성 후 append 하고 만족도 페이지에 넘겨서 Request 요청해야 됨
                    print(path[index-1].name + "~" + path[index].name + "까지 : \(time)초")
                    timer.stopTimer()
                    timer.startTimer()
                }
                nextNodeObject.increment()
            } // end of (if distance <= 5 )
        }
        else{
            // 목적지에 도착하면 timer.stopTimer()
            timer.stopTimer()
        }
    }   // end of checkDistance()
    

}



//                                ARView(coreLocation: coreLocation, nextNodeObject: nextNodeObject, bestHorizontalAccuracy: coreLocation.location!.horizontalAccuracy, bestVerticalAccuracy: coreLocation.location!.verticalAccuracy, location : coreLocation.location!, path: path)



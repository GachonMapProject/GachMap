//
//  PathTimeTestView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI
import CoreLocation

struct PathTime : Identifiable {
    let id = UUID()
    let pathName : String
    let time : Int?
    let isLogin : Bool
    let line : [CLLocationCoordinate2D]
}

struct PathTimeTestView: View {
    @Binding var selectedPath : Int
    
    let path : [PathTime]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
//            ZStack(alignment:.center){
                LazyHStack{
                    ForEach(0..<2){ index in
                        Button(action: {
                            // 지도에 경로 표시 및 검색창의 텍스트 변경 (위치 포함)
                            selectedPath = index
                        }, label: {
                            PathTimeView(pathName: path[index].pathName, time:  path[index].time , isLogin: path[index].isLogin, num: index, selectedPath: $selectedPath)
                                .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.8)
                                }
                                .padding(.trailing, 7)
                                .onTapGesture {
                                    selectedPath = index
                                }
                        })
                        .disabled(path[index].time == nil)
                    }

                } // end of LazyStack
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                .scrollTargetLayout()
                
//            } // end of ZStack
            
        } // end of ScrollView
        .frame(height: UIScreen.main.bounds.height / 7)
        .scrollTargetBehavior(.viewAligned)

    }
}

//#Preview {
//    PathTimeTestView()
//}


//
//                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                        PathTimeView(pathName: "최적 경로", time: arr[0][1], isLogin: true, num: 0, selectedNum: $selectedNum)
//                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
//                                content
//                                    .opacity(phase.isIdentity ? 1.0 : 0.8)
//                            }
//                            .padding(.trailing, 10)
//                            .onTapGesture {
//                                selectedNum = 0
//                            }
//                    })
//                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                        PathTimeView(pathName: "무당이 경로", time: arr[1][1] == "0" ? nil : arr[1][1], isLogin: true, num: 1, selectedNum: $selectedNum)
//                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
//                                content
//                                    .opacity(phase.isIdentity ? 1.0 : 0.8)
//
//                            }
//                            .padding(.trailing, 10)
//                            .onTapGesture {
//                                selectedNum = 1
//                            }
//                    })
//                    .disabled(arr[1][1] == "0")
//
//                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
//                        PathTimeView(pathName: "최단 경로", time: "3", isLogin: true, num: 2, selectedNum: $selectedNum)
//                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
//                                content
//                                    .opacity(phase.isIdentity ? 1.0 : 0.8)
//                            }
//                            .onTapGesture {
//                                selectedNum = 2
//                            }
//                    })

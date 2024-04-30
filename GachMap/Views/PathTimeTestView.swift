//
//  PathTimeTestView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI

struct pathTime : Identifiable {
    let id = UUID()
    let pathName : String
    let time : String?
    let isLogin : Bool
}

struct PathTimeTestView: View {
    @State var selectedNum = 0
    let test = [pathTime(pathName: "최적 경로", time: "33", isLogin: true),
                pathTime(pathName: "무당이 경로", time: nil, isLogin: true),
                pathTime(pathName: "최단 경로", time: "3", isLogin: true)
            ]
    var body: some View {
        ScrollView(.horizontal){
            ZStack(){
                LazyHStack{
                    ForEach(0..<3){ index in
                        Button(action: {}, label: {
                            PathTimeView(pathName: test[index].pathName, time:  test[index].time , isLogin: true, num: index, selectedNum: $selectedNum)
                                .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1.0 : 0.8)
                                }
                                .padding(.trailing, 10)
                                .onTapGesture {
                                    selectedNum = index
                                }
                        })
                        .disabled(test[index].time == nil)
                    }

                } // end of LazyStack
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
                .scrollTargetLayout()
                
            } // end of ZStack
            
        } // end of ScrollView
        .scrollTargetBehavior(.viewAligned)
    }
}

#Preview {
    PathTimeTestView()
}


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

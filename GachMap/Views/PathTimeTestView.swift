//
//  PathTimeTestView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI

struct PathTimeTestView: View {
    @State var selectedNum = 0
    let arr = [["최적 경로", "33", "true"], ["무당이 경로", "0", "true"], ["최단 경로", "33", "true"]]
    var body: some View {
        ScrollView(.horizontal){
            ZStack(){
                LazyHStack{
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        PathTimeView(pathName: "최적 경로", time: arr[0][1], isLogin: true, num: 0, selectedNum: $selectedNum)
                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.8)
                            }
                            .padding(.trailing, 10)
                            .onTapGesture {
                                selectedNum = 0
                            }
                    })
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        PathTimeView(pathName: "무당이 경로", time: arr[1][1] == "0" ? nil : arr[1][1], isLogin: true, num: 1, selectedNum: $selectedNum)
                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.8)
                                    
                            }
                            .padding(.trailing, 10)
                            .onTapGesture {
                                selectedNum = 1
                            }
                    })
                    .disabled(arr[1][1] == "0")
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        PathTimeView(pathName: "최단 경로", time: "3", isLogin: true, num: 2, selectedNum: $selectedNum)
                            .scrollTransition(.animated, axis: .horizontal) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.8)
                            }
                            .onTapGesture {
                                selectedNum = 2
                            }
                    })

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

//
//  PathTimeTestView.swift
//  GachMap
//
//  Created by 이수현 on 4/30/24.
//

import SwiftUI

struct PathTimeTestView: View {
    @State var selectedNum = 0
    var body: some View {
        ScrollView(.horizontal){
            ZStack(){
                LazyHStack{
                    PathTimeView(pathName: "최적 경로", time: "33", isLogin: true, num: 0, selectedNum: $selectedNum)
                        .scrollTransition(.animated, axis: .horizontal) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.8)
                        }
                        .padding(.trailing, 10)
                        .onTapGesture {
                            selectedNum = 0
                        }
                    PathTimeView(pathName: "무당이 경로", time: nil, isLogin: true, num: 1, selectedNum: $selectedNum)
                        .scrollTransition(.animated, axis: .horizontal) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.8)
                                
                        }
                        .padding(.trailing, 10)
                        .onTapGesture {
                            selectedNum = 1
                        }
                    PathTimeView(pathName: "최단 경로", time: "3", isLogin: true, num: 2, selectedNum: $selectedNum)
                        .scrollTransition(.animated, axis: .horizontal) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1.0 : 0.8)
                        }
                        .onTapGesture {
                            selectedNum = 2
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

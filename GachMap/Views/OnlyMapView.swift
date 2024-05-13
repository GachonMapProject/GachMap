//
//  OnlyMapView.swift
//  GachMap
//
//  Created by 이수현 on 5/13/24.
//

import SwiftUI

struct OnlyMapView: View {
    let path : [Node]
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var coreLocation : CoreLocationEx
    @EnvironmentObject var globalViewModel: GlobalViewModel
    @State var endInfo = false
    
    var body: some View {
        ZStack(alignment : .topTrailing){
            AppleMap(path: path, coreLocation: coreLocation, isOnlyMapOn: true)
                .edgesIgnoringSafeArea(.all)
            
            Button(){
                endInfo = true

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
            .padding(.trailing, 20)
            .padding(.top, 10)
            .alert(isPresented: $endInfo){
                Alert(title: Text("경로 미리보기 종료"), message: Text("경로 미리보기를 종료하시겠습니까?"),  primaryButton: .default(Text("종료").bold(), action: {
                    globalViewModel.showSearchView = false
                }),
                  secondaryButton: .cancel(Text("취소")))
            }

        }
        
    }
}

//#Preview {
//    OnlyMapView()
//}

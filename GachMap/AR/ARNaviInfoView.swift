//
//  ARBalloonView.swift
//  GachMap
//
//  Created by 이수현 on 4/27/24.
//

import SwiftUI



struct ARNaviInfoView: View {
    
    let rotationDic = ["우회전" : "arrowshape.turn.up.right.circle.fill",
                       "좌회전" : "arrowshape.turn.up.left.circle.fill",
                       "직진" : "arrow.up.circle.fill"]
    
    @State var distance : Int = 0
    @State var rotation : String = "우회전"
    
    var body: some View {
        HStack(){
            Image(systemName: rotationDic[rotation] ?? "arrow.up.circle.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.blue)
                .scaledToFit()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 10))

            
            VStack{
                Text("\(rotation) 후")
                    .bold()
                Text("\(distance)m 이동")
                    .bold()
            }
            .font(.system(size: 24))
            .padding(.bottom, 20)

        }
        .frame(width: 220, height: 140)
        .background{
            Image(systemName: "bubble.middle.bottom.fill")
                .resizable()
                .foregroundColor(.white)
        }
        .cornerRadius(25)
        .shadow(radius: 7, x: 2, y: 2)
        .drawingGroup() // SwiftUI 뷰를 UIImage로 래스터화
    }
}

extension ARNaviInfoView {
    func asImage() -> UIImage {
        let hostView = UIHostingController(rootView: self)
        let size = hostView.view.intrinsicContentSize
        hostView.view.frame = CGRect(origin: .zero, size: size)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            hostView.view.drawHierarchy(in: hostView.view.bounds, afterScreenUpdates: true)
        }
    }
}


#Preview {
    ARNaviInfoView()
}

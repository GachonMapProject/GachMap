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
    
    @State var distance : Int = 100
    @State var rotation : String = "우회전"
    
    var body: some View {
        
        HStack(){
            Image(systemName: rotationDic[rotation] ?? "arrow.up.circle.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.blue)
                .scaledToFit()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 33, trailing: 10))

            
            VStack{
                Text("\(rotation) 후")
                    .bold()
                Text("\(distance)m 이동")
                    .bold()
            }
            .font(.system(size: 24))
            .padding(.bottom, 33)

        }
        .frame(width: 250, height: 100)
        
//        .background{
//            Image(systemName: "bubble.middle.bottom.fill")
//                .resizable()
//                .foregroundColor(.white)
//        }
//        .cornerRadius(25)
//        .shadow(radius: 7, x: 2, y: 2)
        .drawingGroup() // SwiftUI 뷰를 UIImage로 래스터화
    }
}

extension ARNaviInfoView {
    func asImage() -> UIImage {
        let hostView = UIHostingController(rootView: self)
        let size = CGSize(width: 250, height: 100) // 원래 View의 크기로 설정
        hostView.view.frame = CGRect(origin: .zero, size: size)
        
        // 모서리를 둥글게 처리하고 그림자 추가
        hostView.view.layer.cornerRadius = 20
        hostView.view.layer.shadowColor = UIColor.black.cgColor
        hostView.view.layer.shadowOpacity = 0.5
        hostView.view.layer.shadowOffset = CGSize(width: 0, height: 2)
        hostView.view.layer.shadowRadius = 4
        
//        // 백그라운드 이미지 추가
//        let backgroundImage = UIImageView(image: UIImage(systemName: "bubble.middle.bottom.fill"))
//        backgroundImage.frame = hostView.view.bounds
//        backgroundImage.contentMode = .scaleAspectFill
//        hostView.view.addSubview(backgroundImage)
//        hostView.view.sendSubviewToBack(backgroundImage)
        
        let renderer = UIGraphicsImageRenderer(bounds: hostView.view.bounds)
        return renderer.image { _ in
            hostView.view.drawHierarchy(in: hostView.view.bounds, afterScreenUpdates: true)
        }
    }
}


#Preview {
    ARNaviInfoView()
}

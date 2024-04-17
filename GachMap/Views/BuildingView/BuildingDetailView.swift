//
//  BuildingDetailView.swift
//  GachMap
//
//  Created by 이수현 on 4/17/24.
//

import SwiftUI
import MapKit


struct BuildingDetailView: View {
    @State var BuildingName = "가천관"
    @State var BuildingSummary = "가천대학교의 본관"
    @State var floor = ["1F", "2F", "3F", "4F", "5F", "6F", "7F"]
    @State var floorInfo = ["1층입니다.", "2층입니다.", "3층입니다.", "4층입니다.", "5층입니다.", "6층입니다.", "7층입니다."]
    @State var imageName = "festival"
    @State var region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4503713, longitude: 127.1299376), latitudinalMeters: 250, longitudinalMeters: 250))
    
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    Map(position: $region)
                        .frame(height: 300)
                        .allowsHitTesting(false)
//                        .interactionModes(.nonInteractive)
                    if let uiImage = UIImage(named: imageName) {
                        CircleImage(image: Image(uiImage: uiImage))
                            .offset(y: -130)
                            .padding(.bottom, -130)
                    } else {
                        Text("이미지를 찾을 수 없습니다.")
                            .foregroundColor(.red)
                    }
                                   
                    VStack(alignment : .leading){
                        Spacer()
                        Text(BuildingName)
                            .font(.system(size: 30))
                            .bold()
                        Text(BuildingSummary)
                            .font(.system(size: 17))
                            .foregroundColor(.gray)
                        Divider()
                        Text("층별 안내")
                            .font(.system(size: 23))
                            .bold()
                            .padding(.top, 10)
                        
                        ForEach((1...floor.count).reversed(), id: \.self){ floor in
                            VStack(alignment : .leading){
                                Text("\(floor)F")
                                    .font(.system(size: 17))
                                    .bold()
                                Text(floorInfo[floor - 1])
                            }
                            .padding(.top, 10)
                           
                        }

                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    
                    //
                }
            }
          
            
        }
        .navigationTitle(BuildingName)

    }
}


struct CircleImage: View {
    var image: Image


    var body: some View {
        image
            .resizable()
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
                    
            }
            .shadow(radius: 7)
            .frame(width: 220, height: 220)
    }
}


#Preview {
    BuildingDetailView()
}

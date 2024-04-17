//
//  BuildingDetailView.swift
//  GachMap
//
//  Created by 이수현 on 4/17/24.
//

import SwiftUI
import Alamofire
import MapKit


struct BuildingDetailView: View {
    @State var buildingName = "가천관"
    @State var buildingSummary = "가천대학교의 본관"
    @State var floor = ["1F", "2F", "3F", "4F", "5F", "6F", "7F"]
    @State var floorInfo = ["1층입니다.", "2층입니다.", "3층입니다.", "4층입니다.", "5층입니다.", "6층입니다.", "7층입니다."]
    @State var imageName = "festival"
    @State var region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4503713, longitude: 127.1299376), latitudinalMeters: 250, longitudinalMeters: 250))
    
    @State var getSuccess = false   // API 연결 완료 되면 true로 설정
//    @State var buildingName : String?
//    @State var buildingSummary : String?
//    @State var floor : [String?]
//    @State var floorInfo : [String?]
//    @State var imageName = "festival"
//    @State var region : MapCameraPosition?
    
    let buildingCode : Int
    @State var buildingDetailData : BuildingDetailData?
    
    init(buildingCode : Int){
        self.buildingCode = buildingCode
    }
    
    var body: some View {
        
        // API를 통해 데이터 가져오기 전 Progress() 띄우고 가져오면 진짜 뷰 띄우기
        if !getSuccess {
            ProgressView()
                .onAppear(){
                    getBuildingDetail(buildingCode: buildingCode)
                }
        }
     
        else {
            NavigationStack {
                ScrollView{
                    VStack{
                        Map(position: $region)
                            .frame(height: 300)
                            .allowsHitTesting(false)
                        
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
                            Text(buildingName)
                                .font(.system(size: 30))
                                .bold()
                            Text(buildingSummary)
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
            .navigationTitle(buildingName)
    //        .navigationTitle("\(buildingCode)")
            .onAppear(){
               
            }
        }
            
        
        

    }
    
    // 건물 세부 정보 가져오는 API
    func getBuildingDetail(buildingCode : Int){
        
        // 이건 아직 서버 연결이 안 돼서 직접 적어놓은 거임
        // 서버 연결되면 지우면 됨
        buildingDetailData = BuildingDetailData(placeName: "AI공학관", placeSummary: "기술의 진보 그 집합체", placeLongitude: 34.15253, placeLatitude: 157.12524, floorInfo: [FloorInfo(floor: "1F", floorInfo: "학생회실")])
        buildingName = buildingDetailData!.placeName
        buildingSummary = buildingDetailData!.placeSummary
        floor = buildingDetailData!.floorInfo.map{$0.floor}
        floorInfo = buildingDetailData!.floorInfo.map{$0.floorInfo}
        // image
        region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: buildingDetailData!.placeLatitude, longitude: buildingDetailData!.placeLongitude), latitudinalMeters: 250, longitudinalMeters: 250))
        
        getSuccess = true
        
        
        guard let url = URL(string: "https://ceprj.gachon.ac.kr/60002/src/map/building-floor/\(buildingCode)")
        else {
            print("Invalid URL")
            return
        }
            
        // Alamofire를 사용하여 Get 요청 생성
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: BuildingDetailResponse.self) { response in
                // 에러 처리
                switch response.result {
                    case .success(let value):
                        // 성공적인 응답 처리
                        let data = value.data
                        print(data)
                        print("getBuildingDetail() - 건물 세부 정보 가져오기 성공")
                    
                        buildingDetailData = data
                        buildingName = data.placeName
                        buildingSummary = data.placeSummary
                        floor = data.floorInfo.map{$0.floor}
                        floorInfo = data.floorInfo.map{$0.floorInfo}
                        // image
                        region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: data.placeLatitude, longitude: data.placeLongitude), latitudinalMeters: 250, longitudinalMeters: 250))
                    
                        getSuccess = true

                    case .failure(let error):
                        // 에러 응답 처리
                        print("Error: \(error.localizedDescription)")
                } // end of switch
        } // end of AF.request
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


//#Preview {
//    BuildingDetailView(buildingCode: 2)
//}

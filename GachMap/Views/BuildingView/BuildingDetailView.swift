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
    @State var buildingFloor = ["1F", "2F", "3F", "4F", "5F", "6F", "7F"]
    @State var buildingFloorInfo = ["1층입니다.", "2층입니다.", "3층입니다.", "4층입니다.", "5층입니다.", "6층입니다.", "7층입니다."]
    @State var mainImagePath = "festival"
    @State var region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.4503713, longitude: 127.1299376), latitudinalMeters: 250, longitudinalMeters: 250))
    @State var buildingFloorInfoDict = [String: [String]]()
    
    @State var apiConnection = false   // API 연결 완료 되면 true로 설정
    @State var serverAlert = false  // 서버 통신 실패 알림
    
    @State var sortedKeys : [Dictionary<String, [String]>.Keys.Element] = []
    
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
        if !apiConnection {
            ProgressView()
                .onAppear(){
                    getBuildingDetail(buildingCode: buildingCode)
                }
                .alert("알림", isPresented: $serverAlert) {
                    Button("확인") {}
                } message: {
                    Text("서버 통신에 실패했습니다.")
                }
        } // end of if
        
        else {
            ScrollView{
                VStack{
                    Map(position: $region)
                        .frame(height: 300)
                        .allowsHitTesting(false)
                    
//                        if let uiImage = UIImage(resource: mainImagePath) {
//                            CircleImage(image: Image(uiImage: uiImage))
//                        AsyncImage(url: mainImagePath){
                    AsyncImage(url: URL(string: mainImagePath)!) { phase in
                        switch phase {
                        case .success(let image):
                            CircleImage(image: image)
                                .offset(y: -130)
                                .padding(.bottom, -130)
                        default:
                            // 실패했을 때 보여줄 뷰 또는 처리할 내용
                            ProgressView()
                        }
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
                        
                        ForEach(sortedKeys, id: \.self) { floor in
                            VStack(alignment: .leading) {
                                Text(floor)
                                    .font(.system(size: 17))
                                    .bold()
                                Text(buildingFloorInfoDict[floor]?.joined(separator: ", ") ?? "")
                            }
                            .padding(.top, 10)
                        }
                    }
                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                }
            } // end of ScrollView
            .navigationTitle(buildingName)
            .navigationBarTitleDisplayMode(.large)
        } // end of else
    
    }   // end of body
    
    // 건물 세부 정보 가져오는 API
    func getBuildingDetail(buildingCode : Int){
        
        guard let url = URL(string: "https://8eac-58-121-110-235.ngrok-free.app/map/building-floor/\(buildingCode)")
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
                        guard let data = value.data else { return } // 알림 설정
                        print(data)
                        print("getBuildingDetail() - 건물 세부 정보 가져오기 성공")
                    
                        buildingDetailData = data
                        buildingName = data.placeName
                        buildingSummary = data.placeSummary
                        for floor in data.buildingFloors {
                            if var floors = buildingFloorInfoDict[floor.buildingFloor] {
                                // 이미 해당 층수에 대한 정보가 있는 경우
                                if !floors.contains(floor.buildingFloorInfo) {
                                    floors.append(floor.buildingFloorInfo)
                                }
                                buildingFloorInfoDict[floor.buildingFloor] = floors
                            } else {
                                // 해당 층수에 대한 정보가 없는 경우
                                buildingFloorInfoDict[floor.buildingFloor] = [floor.buildingFloorInfo]
                            }
                        }
                    
                    // B로 시작하지 않는 키들을 정렬
                    let nonBKeys = buildingFloorInfoDict.keys.filter { !$0.starts(with: "B") }.sorted(by: >)

                    // B로 시작하는 키들을 정렬
                    let bKeys = buildingFloorInfoDict.keys.filter { $0.starts(with: "B") }.sorted()
                    
                    // 두 배열을 합침
                    sortedKeys = nonBKeys + bKeys

                    
                    
                        mainImagePath = data.mainImagePath
                        region = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: data.placeLatitude, longitude: data.placeLongitude), latitudinalMeters: 250, longitudinalMeters: 250))
                    
                        apiConnection = true

                    case .failure(let error):
                        // 에러 응답 처리
                        print("Error: \(error.localizedDescription)")
                        serverAlert = true
                    
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
            .aspectRatio(contentMode: .fit)
    }
}


#Preview {
    BuildingDetailView(buildingCode: 2)
}

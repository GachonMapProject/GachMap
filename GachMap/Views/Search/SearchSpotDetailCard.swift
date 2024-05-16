//
//  SearchSpotDetailView.swift
//  GachMap
//
//  Created by 원웅주 on 5/6/24.
//

import SwiftUI

struct SearchSpotDetailCard: View {
    var placeId : Int
    var placeName: String
    var placeSummary: String
    var mainImagePath: String?
    
    @State private var isStartMoved: Bool = false
    @State private var isEndMoved: Bool = false
    @State var showBuildingDetail = false   // 마커 선택 시 건물 상세 보기
    
    var inCategory : Bool
    var isBuilding : Bool
    
    var body: some View {
        VStack {
            HStack {
                if let imagePath = mainImagePath, let url = URL(string: imagePath) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 75, height: 75)
                            .cornerRadius(10)
                            .clipped()
                        default:
                            // 로딩 중이나 실패 시 기본 이미지 또는 플레이스홀더
                            Image("gachonMark") // 여기에 기본 이미지 이름을 입력
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 60)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    // mainImagePath가 nil일 경우
                    Image("gachonMark") // 로컬 이미지 이름 입력
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60)
                        .cornerRadius(10)
                }
                
//                AsyncImage(url: URL(string: mainImagePath ?? "gachonMark")) { image in
//                    image.resizable()
//                        .frame(width: 70, height: 70)
//                        .scaledToFit()
//                        //.aspectRatio(contentMode: .fill)
//                        .cornerRadius(10)
//                        //.clipped()
//                    } placeholder: {
//                        ProgressView()
//                } // end of AsyncImgae
                
//                Image(mainImagePath ?? "gachonMark") // mainImagePath로 수정
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 70, height: 70)
//                    .cornerRadius(10)
//                    .clipped()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(placeName)
                        .font(.system(size: 20, weight: .bold))
                    Text(placeSummary)
                        .font(.system(size: 15))
                    Spacer()
                }
                .frame(height: 70)
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
            
            HStack {
                HStack {
                    if inCategory {
                        if isBuilding{  // 카테고리 마커가 BUILDING인 경우만, 다른 카테고리 시 버튼 x
                            Button(action: {
//                                if let placeId = placeId {
//                                    showBuildingDetail = true
//                                }
                                showBuildingDetail = true
                            }, label: {
                                Text("상세 정보 보기")
                                    .font(.system(size: 15, weight: .bold))
                            })
                            .frame(width: 130, height: 33)
                            .foregroundColor(.white)
                            .background(Capsule()
                                .fill(.gachonBlue))
                        }
                    }
                    else {  // 검색으로 들어온 정보 카드 뷰
                        Button(action: {
                            isStartMoved = true
                        }, label: {
                            Text("출발지로 설정")
                                .font(.system(size: 15, weight: .bold))
                        })
                        .frame(width: 130, height: 33)
                        .foregroundColor(.white)
                        .background(Capsule()
                            .fill(.gachonBlue))
                    }
                }
                .frame(width: (UIScreen.main.bounds.width - 30) / 2, alignment: .trailing)
                .padding(.trailing, 10)
                
                HStack {
                    if (placeName != "기본 위치") {
                        Button(action: {
                            isEndMoved = true
                        }, label: {
                            Text("도착지로 설정")
                                .font(.system(size: 15, weight: .bold))
                        })
                        .frame(width: 130, height: 33)
                        .foregroundColor(.white)
                        .background(Capsule()
                            .fill(.gachonBlue))
                    }
                }
                .frame(width: (UIScreen.main.bounds.width - 30) / 2, alignment: .leading)
                .padding(.leading, 10)
            }
            .padding(.top, 8)
            
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 13)
                .fill(Color(UIColor.systemGray6))
                .shadow(radius: 10)
        )
        
        NavigationLink("", isActive: $isStartMoved) {
            SearchSecondView(getStartSearchText: placeName, getEndSearchText: "", getStartPlaceId : placeId, getEndPlaceId: -1)
                .navigationBarBackButtonHidden()
        }
        
        NavigationLink("", isActive: $isEndMoved) {
            SearchSecondView(getStartSearchText: "현재 위치", getEndSearchText: placeName, getStartPlaceId: -1, getEndPlaceId: placeId)
                .navigationBarBackButtonHidden()
        }
        
        NavigationLink("", isActive: $showBuildingDetail) {
            BuildingDetailView(buildingCode: placeId ?? -1)
//                .navigationBarBackButtonHidden()
        }
        
    }
}

struct SearchSpotDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        SearchSpotDetailCard(placeId: 6, placeName: "전달받은 장소명", placeSummary: "전달받은 요약명", inCategory: true, isBuilding: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

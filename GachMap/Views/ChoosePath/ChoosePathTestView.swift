//
//  ChoosePathTestView.swift
//  GachMap
//
//  Created by 이수현 on 5/11/24.
//

import SwiftUI
import Alamofire

struct ChoosePathTestView: View {
    let departure = 6
    let arrival = 20
    @State var paths : [PathData]? = nil
    var body: some View {
        if paths == nil {
            ProgressView()
                .onAppear(){
                    getPath(departure: departure, arrival: arrival)
                }
        }
        else{
            ChoosePathView(paths : paths!)
        }
       
    }
    
    // 키워드 검색 결과 가져오기
    func getPath(departure : Int, arrival : Int) {
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/route?departure=\(departure)&arrival=\(arrival)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: PathResponse.self) { response in
                print("Response: \(response)")
                switch response.result {
                case .success(let value):
                    print(value)
                    if(value.success == true) {
                        print("경로 가져오기 성공")
                        paths = value.data

                    } else {
                        print("경로 가져오기 실패")

                    }
                    
                case .failure(let error):
                    // 서버 연결 실패할 때도 검색 결과 없음 표시
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

#Preview {
    ChoosePathTestView()
}

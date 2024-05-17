//
//  ARCampusView.swift
//  GachMap
//
//  Created by 이수현 on 5/17/24.
//

import SwiftUI
import Alamofire

struct ARCampusView: View {
    @Environment(\.dismiss) private var dismiss
    @State var ARInfo : [ARInfo] = []

    @State var serverAlert = false
    
    var body: some View {
        if !ARInfo.isEmpty {
            ProgressView()
                .onAppear(){
                    getARCampus()
                }
                .alert(isPresented: $serverAlert){
                    Alert(title: Text("오류"), message: Text("서버와 연결을 실패했습니다."), dismissButton: .default(Text("확인"), action: {
                        dismiss()
                    }))
                }
        }
        else {
            
        }
       
    }
    
    // AR 건물 리스트 가져오기
    func getARCampus() {
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/ar")
        else {
            print("getARCampus - Invalid URL")
            return
        }
            
        // Alamofire를 사용하여 Get 요청 생성
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: ARImageResponse.self) { response in
                // 에러 처리
                switch response.result {
                    case .success(let value):
                        // 성공적인 응답 처리
                    if let data = value.data {
                        print(data)
                        print("getARCampus() - AR 리스트 가져오기 성공")
                        
                        ARInfo = data
                    }
                    else {
                        serverAlert = true
                        print("nilData")
                        
                    }
                            
                        
                    case .failure(let error):
                        // 에러 응답 처리
                        print("Error: \(error.localizedDescription)")
                        serverAlert = true
                } // end of switch
        } // end of AF.request
    }
}

#Preview {
    ARCampusView()
}

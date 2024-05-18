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
    @State var ARInfo: [ARInfo]? = nil
    
    var body: some View {
        Group {
            if ARInfo == nil {
                ProgressView()
                    .onAppear {
                        getARCampus()
                    }
            } else {
                ZStack(alignment: .topTrailing) {
                    ARCampusWrapperView(ARInfo: ARInfo ?? [])
                        .edgesIgnoringSafeArea(.all)
                    
                    Button(action: {
                        dismiss()
                    }, label: {
                        HStack {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.white)
                            Text("둘러보기 종료")
                                .foregroundColor(.white)
                        }
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(15) // 둥글게 만들기 위한 코너 반지름 설정
                    })
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                }
            }
        }
    }
    
    // AR 건물 리스트 가져오기
    func getARCampus() {
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/ar") else {
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
                    } else {
                        print("nilData")
                        ServerAlert()
                    }
                    
                case .failure(let error):
                    // 에러 응답 처리
                    print("Error: \(error.localizedDescription)")
                    ServerAlert()
                }
            }
    }
    
    func ServerAlert(){
        // 버튼을 눌렀을 때 경고 창 표시
        let alert = UIAlertController(title: "오류", message: "서버 연결에 실패했습니다.", preferredStyle: .alert)
            
        // 확인 액션 추가
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                dismiss()
            })

        // 경고 창을 현재 화면에 표시
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

#Preview {
    ARCampusView()
}

//
//  UsageListView.swift
//  GachMap
//
//  Created by 원웅주 on 5/3/24.
//

import SwiftUI
import Alamofire

class UsageListViewModel: ObservableObject {
    @Published var usages: [RouteHistoryData] = []
    
    init() {
        getHistoryList()
    }
    
    // LoginInfo에 저장된 userCode 가져오기
    func getUserCodeFromUserDefaults() -> String? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData),
           let userCode = loginInfo.userCode {
            return "\(userCode)"
        }
        return nil
    }
    
    // 문의 내역 리스트 가져오기
    private func getHistoryList() {
        guard let userCode = getUserCodeFromUserDefaults(),
              let url = URL(string: "http://ceprj.gachon.ac.kr:60002/history/list/\(userCode)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: RouteHistoryResponse.self) { response in
                print("Response: \(response)")
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    if(value.success == true) {
                        print("1:1 문의 리스트 가져오기 성공")
                        self.usages = value.data
                        
                        print("Data fetched: \(self.usages)")
                    } else {
                        print("1:1 문의 리스트 가져오기 실패")
                    }
                    
                case .failure(let error):
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
}

struct UsageListView: View {
    
    @StateObject private var viewModel = UsageListViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(viewModel.usages, id: \.historyId) { usages in
                    UsageListCell(usages: usages)
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, 10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("이용 내역")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(Color.gray)
                                    .opacity(0.7)
                                    .frame(width: 30, height: 30)
                            )
                    })
                    .padding(.trailing, 8)
                }
            } // end of .toolbar
        } // end of NavigationView
    } // end of body
} // end of View struct

#Preview {
    UsageListView()
}

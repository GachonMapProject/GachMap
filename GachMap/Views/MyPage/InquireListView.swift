//
//  InquireListView.swift
//  GachMap
//
//  Created by 원웅주 on 4/30/24.
//

import SwiftUI
import Alamofire

// apiconnection

class InquireListViewModel: ObservableObject {
    @Published var inquiries: [InquireListData] = []
    
    @State var showErrorAlert: Bool = false
    @State var alertMessage: String = ""
    
    init() {
        getInquireList()
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
    private func getInquireList() {
        guard let userCode = getUserCodeFromUserDefaults(),
              let url = URL(string: "http://ceprj.gachon.ac.kr:60002/inquiry/list/\(userCode)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: InquireListResponse.self) { response in
                print("Response: \(response)")
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    if(value.success == true) {
                        print("1:1 문의 리스트 가져오기 성공")
                        self.inquiries = value.data
                        
                        print("Data fetched: \(self.inquiries)")
                    } else {
                        print("1:1 문의 리스트 가져오기 실패")
                        
                        self.showErrorAlert = true
                        self.alertMessage = "정보를 불러오는데 실패했습니다.\n다시 시도해주세요."
                    }
                    
                case .failure(let error):
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                    
                    self.showErrorAlert = true
                    self.alertMessage = "서버 연결에 실패했습니다."
                }
            }
    }
}

struct InquireListView: View {
    
    @StateObject private var viewModel = InquireListViewModel()
    @Binding var showInquireListView: Bool
    
    var body: some View {
        NavigationView {
            HStack {
                if viewModel.inquiries.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("문의내역 없음")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        ForEach(viewModel.inquiries, id: \.inquiryId) { inquiry in
                            InquireListCell(inquiry: inquiry)
                        }
                    }
                }
            } // end of HStack
            .padding(.top, 15)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("문의내역 조회")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInquireListView = false
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
//            .naigationBarTitle("문의내역 조회", displayMode: .inline)
        } // end of NavigationView
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("오류"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("확인")))
        }
        
    } // end of body
    
    
    
} // end of View struct

#Preview {
    InquireListView(showInquireListView: Binding.constant(true))
}

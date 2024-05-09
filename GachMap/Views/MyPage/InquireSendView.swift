//
//  InquireSendView.swift
//  GachMap
//
//  Created by 원웅주 on 4/30/24.
//

import SwiftUI
import Alamofire

enum ActiveInquireAlert {
    case success, fail
}

struct InquireSendView: View {
    // Environment 추가하기 (바인딩 없애고)
    
    @Binding var showInquireSendView: Bool
    
    let category = ["지점 문의", "경로 문의", "AI 소요시간 문의", "AR 문의", "행사 문의", "장소 문의", "기타 문의"]
    
    @State private var loginInfo: LoginInfo? = nil
    
    @State private var showEscapeAlert: Bool = false
    @State private var selectedCategory: String = ""
    @State private var inquireTitle: String = ""
    @State private var inquireDetail: String = ""
    
    @State private var showAlert: Bool = false
    @State private var activeInquireAlert: ActiveInquireAlert = .success
    @State private var alertMessage: String = ""
    
    // LoginInfo에 저장된 정보 가져오기
    private func getLoginInfo() -> LoginInfo? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
            return loginInfo
        } else {
            print("Login Info not found in UserDefaults")
            return nil
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("문의 항목")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
     
                        Picker("문의 항목", selection: $selectedCategory) {
                            ForEach(category, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.automatic)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("제목")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        TextField("제목을 입력해주세요", text: $inquireTitle)
                            .padding(.leading)
                            .multilineTextAlignment(.leading)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.top, 10)
                    
                    VStack {
                        HStack {
                            Text("내용")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        TextEditor(text: $inquireDetail)
    //                        .overlay(alignment: .topLeading) {
    //                            Text("문의 내용을 입력해주세요")
    //                                .foregroundStyle(inquireDetail.isEmpty ? .gray : .clear)
    //                        }
                            .frame(height: 300, alignment: .top)
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .padding(.trailing)
                            .padding(.top, 10)
                            .scrollContentBackground(.hidden)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.top, 10)
                    .padding(.bottom)
                } // end of ScrollView
                
                Button(action: {
                    loginInfo = getLoginInfo()
                    
                    let userId = loginInfo?.userCode ?? 0
                    
                    func selectedInquiryCategory(selectedCategory: String) -> String {
                        switch selectedCategory {
                        case "지점 문의":
                            return "Node"
                        case "경로 문의":
                            return "Route"
                        case "AI 소요시간 문의":
                            return "AITime"
                        case "AR 문의":
                            return "AR"
                        case "행사 문의":
                            return "Event"
                        case "장소 문의":
                            return "Place"
                        case "기타 문의":
                            return "Etc"
                        default:
                            return ""
                        }
                    }
                    
                    let param = InquireSendRequest(userId: userId, inquiryTitle: inquireTitle, inquiryContent: inquireDetail, inquiryCategory: selectedInquiryCategory(selectedCategory: selectedCategory))
                    
                    print("param: \(param)")
                    
                    inquireSend(parameter: param)
                    
                }, label: {
                    Text("전달")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color(.white))
                        .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedCategory.isEmpty || inquireTitle.isEmpty || inquireDetail.isEmpty ? Color(UIColor.systemGray4) : Color.gachonBlue)
                                //.shadow(radius: 5, x: 2, y: 2)
                        )
                })
                .disabled(selectedCategory.isEmpty || inquireTitle.isEmpty || inquireDetail.isEmpty)
                .padding(.bottom)
                .alert(isPresented: $showAlert) {
                    switch activeInquireAlert {
                    case .success:
                        return Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인"), action: { showInquireSendView = false }))
                        
                    case .fail:
                        return Alert(title: Text("오류"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
                    }
                }
                
            } // end of 전체 VStack
            .frame(width: UIScreen.main.bounds.width - 30)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("1:1 문의하기")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showEscapeAlert = true
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
                    .alert(isPresented: $showEscapeAlert) {
                        Alert(title: Text("경고"), message: Text("마이 페이지로 이동하시겠습니까?\n입력한 모든 정보가 초기화됩니다."), primaryButton: .default(Text("확인"), action: { showInquireSendView = false }), secondaryButton: .cancel(Text("취소"))
                        )
                    } // end of X Button
                }
                
            } // end of .toolbar
            
        } // end of NavigationView
        
    } // end of body
    
    // 문의사항 POST 함수
    private func inquireSend(parameter: InquireSendRequest) {
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/inquiry")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: InquireSendResponse.self) { response in
                // 서버 연결 여부
                switch response.result {
                case .success(let value):
                    print(value)
                    if(value.success == true) {
                        print("1:1 문의 전송 성공")
                        
                        alertMessage = "문의 사항이 저장되었습니다."
                        showAlert = true
                        activeInquireAlert = .success
                        
                    } else {
                        print("1:1 문의 전송 실패")
                        
                        alertMessage = "알 수 없는 오류가 발생했습니다.\n다시 시도해 주세요."
                        showAlert = true
                        activeInquireAlert = .fail
                    }
                    
                case .failure(let error):
                    alertMessage = "서버 연결에 실패했습니다."
                    showAlert = true
                    activeInquireAlert = .fail
                    
                    print("Error: \(error.localizedDescription)")
                }
            }
    } // end of isPasswordValid()
    
} // end of View struct

#Preview {
    InquireSendView(showInquireSendView: Binding.constant(true))
}

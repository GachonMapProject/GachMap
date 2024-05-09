//
//  WithdrawView.swift
//  GachMap
//
//  Created by 원웅주 on 4/29/24.
//

import SwiftUI
import Alamofire

enum ActiveExitAlert {
    case exit, withdraw
}

struct WithdrawView: View {
    
    @Binding var showWithdrawView: Bool
    
    @State private var showExitAlert: Bool = false
    @State private var exitAlertMessage: String = ""
    @State private var activeExitAlert: ActiveExitAlert = .exit
    
    @State private var isWithdraw: Bool = false
    
    // LoginInfo에 저장된 userCode 가져오기
    func getUserCodeFromUserDefaults() -> String? {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo"),
           let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData),
           let userCode = loginInfo.userCode {
            return "\(userCode)"
        }
        return nil
    }
    
    var body: some View {
        NavigationStack {
            
            VStack {
                Image("MuhanSad")
                    .padding(.top, 50)
                
                VStack(spacing: 3) {
                    Text("회원 탈퇴 시 지금까지 수집된")
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                    HStack(spacing: 0) {
                        Text("개인 소요시간 데이터는 ")
                            .font(.system(size: 17))
                            .foregroundColor(.black)
                        Text("삭제")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.black)
                        Text("되며,")
                            .font(.system(size: 17))
                            .foregroundColor(.black)
                    }
                    HStack(spacing: 0) {
                        Text("더 이상 ")
                            .font(.system(size: 17))
                            .foregroundColor(.black)
                        Text("개인화된 서비스를 제공받을 수 없습니다.")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.black)
                    }
                }
                .padding(.top, 30)
                
                Text("그래도 탈퇴하시겠습니까?")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                Spacer()
                
                Button(action: {
                    showWithdrawView = false
                }, label: {
                        Text("아니오, 회원을 유지하겠습니다.")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(.white))
                            .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.gachonBlue)
                                    .shadow(radius: 5, x: 2, y: 2)
                            )
                            .padding(.bottom, 10)
                }) // end of 아니오 버튼
                
                Button(action: {
                    showExitAlert = true
                    activeExitAlert = .exit
                }, label: {
                    Text("네, 탈퇴하겠습니다.")
                        .foregroundColor(.gachonBlue)
                })
                .alert(isPresented: $showExitAlert) {
                    switch activeExitAlert {
                    case .exit:
                        return Alert(title: Text("탈퇴하시겠습니까?"), message: Text("회원 탈퇴 시 현재까지 제공되던\n개인 맞춤 소요시간 데이터가 삭제됩니다."), primaryButton: .default(Text("예"), action: { deleteUserRequest() }) , secondaryButton: .cancel(Text("아니오")))
                    case .withdraw:
                        return Alert(title: Text("알림"), message: Text(exitAlertMessage), dismissButton: .default(Text("확인"), action: { UserDefaults.standard.removeObject(forKey: "loginInfo"); isWithdraw = true }))
                    }
                }
                
                NavigationLink("", isActive: $isWithdraw) {
                    PrimaryView()
                        .navigationBarBackButtonHidden(true)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("회원 탈퇴하기")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.black)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showWithdrawView = false
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
            
        } // end of NavigationStack

    } // end of body

    // deleteUserRequest() 함수
    func deleteUserRequest() {
        // API 요청을 보낼 URL 생성
        guard let userCode = getUserCodeFromUserDefaults(),
              let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/\(userCode)")
        else {
            print("Invalid URL")
            return
        }

        let parameter: [String: String] = ["userCode": userCode]
            
        // Alamofire를 사용하여 DELETE 요청 생성
        AF.request(url, method: .delete, parameters: parameter, headers: nil)
            .validate()
            .responseDecodable(of: DeleteUserResponse.self) { response in
            // 서버 연결 여부
            switch response.result {
                case .success(let value):
                    print(value)
                   // 회원 탈퇴 성공 유무
                    if (value.success == true) {
                        print("회원 탈퇴 성공")
                        print("value.success: \(value.success)")
                        print("value.messgae: \(value.message)")
                        
                        // getUserCodeFromUserDefaults()
                        
                        exitAlertMessage = "회원 탈퇴에 성공했습니다.\n다시 만날 날을 기다리고 있을게요!"
                        showExitAlert = true
                        activeExitAlert = .withdraw
                        
                    } else {
                        print("회원 탈퇴 실패")
                        print("value.success: \(value.success)")
                        print("value.messgae: \(value.message)")

                        exitAlertMessage = "회원 탈퇴에 실패했습니다.\n다시 시도해주세요."
                        showExitAlert = true
                        activeExitAlert = .withdraw
                    }
                
                case .failure(let error):
                    // 에러 응답 처리
                    print("url: \(url)")
                    exitAlertMessage = "서버 연결에 실패했습니다."
                    showExitAlert = true
                    activeExitAlert = .withdraw
                    print("Error: \(error.localizedDescription)")
            } // end of switch
        } // end of AF.request
    } // end of postData()
    
} // end of View struct

#Preview {
    WithdrawView(showWithdrawView: Binding.constant(true))
}

//
//  ProfileTabView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI
import Alamofire

struct ProfileTabView: View {
    
    // @Binding var isLogin: Bool
    
    @State private var showModifyView: Bool = false
    @State private var showWithdrawView: Bool = false
    @State private var showInquireSendView: Bool = false
    @State private var showInquireListView: Bool = false
    @State private var showServiceTermsModal: Bool = false
    @State private var showPrivacyTermsModal: Bool = false
    
    @State private var loginInfo: LoginInfo? = nil
    @State private var isLogout: Bool = false
    @State private var isPasswordCheckMove: Bool = false
    @State private var isLoginMove: Bool = false
 
    @State private var showLogoutAlert: Bool = false
    
    //@State private var loginInfo: LoginInfo? = nil
    @State private var userInfo: UserInquiryResponse?
    @State private var isLoading: Bool = false
    
    // LoginInfo에 저장된 정보 불러오기
    private func getLoginInfo() {
        if let savedData = UserDefaults.standard.data(forKey: "loginInfo") {
            if let loginInfo = try? JSONDecoder().decode(LoginInfo.self, from: savedData) {
                // userCode가 저장되어 있다면 출력
                if let userCode = loginInfo.userCode {
                    print("userCode: \(userCode)")
                } else {
                    print("userCode: Not set")
                }
                
                // guestCode가 저장되어 있다면 출력
                if let guestCode = loginInfo.guestCode {
                    print("guestCode: \(guestCode)")
                } else {
                    print("guestCode: Not set")
                }
            }
        } else {
            print("Login Info not found in UserDefaults")
        }
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
    
    // 서버에 저장된 사용자 정보 가져오기
//    private func getUserInfoInquiry() {
//        isLoading = true
//        
//        loginInfo = getLoginInfo()
//            
//        guard let userCode = loginInfo?.userCode else {
//            print("userCode is nil")
//            return
//        }
//        
//        if let userCode = loginInfo?.userCode {
//            self.userId = String(userCode)
//        } else {
//            print("userCode is nil")
//            return
//        }
//        
//        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/\(userId)")
//        else {
//            print("Invalid URL")
//            return
//        }
//        
//        AF.request(url, method: .get, parameters: nil, headers: nil)
//            .validate()
//            .responseDecodable(of: UserInquiryResponse.self) { response in
//                isLoading = false
//                
//                switch response.result {
//                case .success(let value):
//                    if (value.success == true) {
//                        print("회원 정보 요청 성공")
//                        self.userInfo = value
//                        
//                        self.username = value.data.username ?? ""
//                        self.userNickname = value.data.userNickname ?? ""
//                        self.userBirth = value.data.userBirth ?? 0
//                        self.selectedGender = value.data.userGender ?? ""
//                        self.userHeight = value.data.userHeight ?? 0
//                        self.userWeight = value.data.userWeight ?? 0
//                        let walkSpeed = value.data.userSpeed == "FAST" ? "빠름" : value.data.userSpeed == "SLOW" ? "느림" : "보통"
//                        self.selectedWalkSpeed = walkSpeed
//                        
//                    } else {
//                        print("회원 정보 요청 실패")
//                        // showErrorAlert = true
//                    }
//                    
//                case .failure(let error):
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//    } // end of getUserInfoInquiry()
    
    var body: some View {
        NavigationView {
            VStack {
                let userCode = getUserCodeFromUserDefaults()
                
                /// 나중에 !=로 바꾸기!! 꼭!!!!!
                if (userCode == nil) {
                    VStack { // 전체 내용 VStack
                        
                        // 상단 파란 박스 부분 VStack
                        VStack {
                            Image("MyPageTitle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width - 50, alignment: .leading)
                                .frame(height: 35)
                                //.padding(.top, 30)
                            // 닉네임, ID, 로그아웃 버튼 영역
                            HStack {
                                VStack(spacing: 5) {
                                    HStack {
                                        Text("닉네임")
                                            .font(.system(size: 30, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("아이디")
                                            .font(.system(size: 15))
                                            .foregroundColor(.gray)
                                        
                                        Spacer()
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    showLogoutAlert = true
                                }, label: {
                                    Text("로그아웃")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.black)
                                        .frame(width: 80, height: 35)
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(.white))
                                })
                                .alert(isPresented: $showLogoutAlert) {
                                    Alert(title: Text("알림"), message: Text("로그아웃 하시겠습니까?"), primaryButton: .default(Text("예"), action: {
                                        UserDefaults.standard.removeObject(forKey: "loginInfo"); isLogout = true
                                    }), secondaryButton: .cancel(Text("아니오")))
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .padding(.top)
                            // end of 닉네임, ID, 로그아웃 버튼
                            
                            HStack {
                                VStack(spacing: 10) {
                                    Image(systemName: "figure.walk")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gachonBlue)
                                    Text("이용 내역")
                                        .font(.system(size: 15, weight: .bold))
                                }
                                .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white))
                                
                                Spacer()
                                
                                VStack(spacing: 10) {
                                    Image(systemName: "megaphone.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gachonBlue)
                                    Text("공지사항")
                                        .font(.system(size: 15, weight: .bold))
                                }
                                .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white))
                                
                                Spacer()
                                
                                VStack(spacing: 10) {
                                    Image(systemName: "questionmark.bubble.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gachonBlue)
                                    Text("FAQ")
                                        .font(.system(size: 15, weight: .bold))
                                }
                                .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: 80)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white))
                            }
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .padding(.top, 20)
                            // end of 이용 내역, 공지사항, 이벤트 버튼
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.gachonBlue2,. gachonBlue]), startPoint: .top, endPoint: .bottom)
                        )
                        // 상단 파란 박스 부분 끝
                        
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 30) {
                                Button(action: {
                                    showModifyView = true
                                }, label: {
                                    HStack {
                                        Text("내 정보 수정")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .fullScreenCover(isPresented: $showModifyView) {
                                        PasswordCheckView(showModifyView: $showModifyView)
                                    }
                                })
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                                
                                Button(action: {
                                    showInquireSendView = true
                                }, label: {
                                    HStack {
                                        Text("1:1 문의")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .fullScreenCover(isPresented: $showInquireSendView) {
                                        InquireSendView(showInquireSendView: $showInquireSendView)
                                    }
                                })
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                                
                                Button(action: {
                                    showInquireListView = true
                                }, label: {
                                    HStack {
                                        Text("문의내역 조회")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .fullScreenCover(isPresented: $showInquireListView) {
                                        InquireListView(showInquireListView: $showInquireListView)
                                    }
                                })
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                            }
                            .frame(width: UIScreen.main.bounds.width - 50, height: 170)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white))
                            .padding(.top)
                            // end of 내 정보 수정, 1:1 문의, 문의 내역 조회 버튼
                            
                            VStack(spacing: 30) {
                                Button(action: {
                                    showServiceTermsModal = true
                                }, label: {
                                    HStack {
                                        Text("서비스 이용 약관")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .fullScreenCover(isPresented: $showServiceTermsModal) {
                                        ServiceTermsView()
                                    }
                                })
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                                
                                Button(action: {
                                    showPrivacyTermsModal = true
                                }, label: {
                                    HStack {
                                        Text("개인정보 이용 약관")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .fullScreenCover(isPresented: $showPrivacyTermsModal) {
                                        PrivacyTermsView()
                                    }
                                })
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                                
                                Button(action: {
                                    
                                }, label: {
                                    HStack {
                                        Text("오픈소스 라이선스")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
    //                                .fullScreenCover(isPresented: $showPrivacyTermsModal) {
    //                                    PrivacyTermsView()
    //                                }
                                })
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                            }
                            .frame(width: UIScreen.main.bounds.width - 50, height: 170)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white))
                            .padding(.top)
                            
                            // 회원탈퇴 버튼
                            HStack {
                                Button(action: {
                                    showWithdrawView = true
                                }, label: {
                                    HStack {
                                        Text("회원 탈퇴하기")
                                            .font(.system(size: 17, weight: .bold))
                                            .foregroundColor(.black)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                    .fullScreenCover(isPresented: $showWithdrawView) {
                                        WithdrawView(showWithdrawView: $showWithdrawView)
                                    }
                                })
                                .padding(.leading, 25)
                                .padding(.trailing, 25)
                            }
                            .frame(width: UIScreen.main.bounds.width - 50, height: 55)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white))
                            .padding(.top)
                            .padding(.bottom)
                            // end of 회원탈퇴 버튼
                        } // end of ScrollView
   
                    } // 전체 내용 VStack
                    
                    NavigationLink("", isActive: $isLogout) {
                        PrimaryView()
                            .navigationBarBackButtonHidden(true)
                    }

                } else {
                    // 게스트
                    VStack {
                        VStack(alignment: .leading) {
                            Text("게스트로\n이용중이시군요!")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 50)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        
                        Image("MuhanEarth")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            //.frame(height: UIScreen.main.bounds.height * 0.5)
                        
                        Spacer()
                        
                        Button(action: {
                            UserDefaults.standard.removeObject(forKey: "loginInfo")
                            
                            isLoginMove = true
                        }, label: {
                            HStack {
                                Text("로그인")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(.white))
                            }
                            .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(.gachonGreen)
                                    .shadow(radius: 5, x: 2, y: 2)
                            )
                            .padding(.bottom, 20)
                        })
                        .fullScreenCover(isPresented: $isLoginMove) {
                            PrimaryView()
                                .navigationBarBackButtonHidden()
                        }
                    } // 전체 VStack
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

//                    NavigationLink("", isActive: $isLoginMove) {
//                        PrimaryView()
//                            .navigationBarBackButtonHidden(true)
//                    }
                    
                } // end of else
            } // end of 전체 내용 VStack (회원, 게스트 포함)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray6))
            //.navigationBarTitle("마이 페이지", displayMode: .large)
            .navigationBarBackButtonHidden(true)
   
        } // end of NavigationView
        
    } // end of body
    
} // end of View strucet

#Preview {
    ProfileTabView()
}

//
//  ProfileTabView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 3/11/24.
//

import SwiftUI
import Alamofire

struct ProfileTabView: View {
    @State private var showNoticeWeb = false
    @State private var showFaqWeb = false
    private let noticeUrl = "https://gachgaja.notion.site/5e5222698b854281892b3e5559e4e1a3"
    private let faqUrl = "https://gachgaja.notion.site/FAQ-5dda2bff6e2a49faa3575cb2e5d237dc"
    
    // @Binding var isLogin: Bool
    var tabBarHeight = UITabBarController().tabBar.frame.size.height
    
    @State private var showModifyView: Bool = false
    @State private var showWithdrawView: Bool = false
    @State private var showInquireSendView: Bool = false
    @State private var showInquireListView: Bool = false
    @State private var showServiceTermsModal: Bool = false
    @State private var showPrivacyTermsModal: Bool = false
    @State private var showUsageListView: Bool = false
    
    @State private var loginInfo: LoginInfo? = nil
    @State private var isLogout: Bool = false
    @State private var isPasswordCheckMove: Bool = false
    @State private var isLoginMove: Bool = false
 
    @State private var showLogoutAlert: Bool = false
    @State private var showErrorAlert: Bool = false
    
    //@State private var loginInfo: LoginInfo? = nil
    @State private var userInfo: UserInquiryResponse?
    @State private var isLoading: Bool = false
    
    @State private var username = ""
    @State private var userNickname = ""
    
    func openURL(urlString: String) {
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url)
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
    private func getUserInfoInquiry() {
        isLoading = true
        
        guard let userCode = getUserCodeFromUserDefaults(),
              let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/\(userCode)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: UserInquiryResponse.self) { response in
                isLoading = false
                
                switch response.result {
                case .success(let value):
                    if (value.success == true) {
                        print("회원 정보 요청 성공")
                        self.userInfo = value
                        
                        self.username = value.data.username
                        self.userNickname = value.data.userNickname
                        
                    } else {
                        print("회원 정보 요청 실패")
                        showErrorAlert = true
                    }
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    showErrorAlert = true
                }
            }
    } // end of getUserInfoInquiry()
    
    var body: some View {
//        let userCode = getUserCodeFromUserDefaults()
//        
//        if (userCode != nil) {
//            // 회원 뷰
//            NavigationView {
//                
//            }
//        } else {
//            // 게스트 뷰
//            NavigationView {
//                
//            }
//        }
        
        NavigationView {
            VStack {
                let userCode = getUserCodeFromUserDefaults()
                
                /// 나중에 !=로 바꾸기!! 꼭!!!!!
                if (userCode != nil) {
                    VStack { // 전체 내용 VStack
                        // 회원 뷰
                        // 상단 파란 박스 부분 VStack
                        VStack {
                            Image("MyPageTitle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: UIScreen.main.bounds.width - 50, alignment: .leading)
                                .frame(height: 32)
                                .padding(.top, 70)
                            // 닉네임, ID, 로그아웃 버튼 영역
                            HStack {
                                VStack(spacing: 5) {
                                    HStack {
                                        Text(userNickname)
                                            .font(.system(size: 30, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text(username)
                                            .font(.system(size: 15))
                                            .foregroundColor(Color(UIColor.systemGray4))
                                        
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
                                Button(action: {
                                    showUsageListView = true
                                }, label: {
                                    VStack(spacing: 10) {
                                        Image(systemName: "figure.walk")
                                            .font(.system(size: 20))
                                            .foregroundColor(.gachonBlue)
                                        Text("이용 내역")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: 75)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.white))
                                    .fullScreenCover(isPresented: $showUsageListView) {
                                        UsageListView()
                                            .foregroundColor(.black)
                                            .presentationBackground(.thinMaterial)
                                    }
                                })
                                
                                Spacer()
                                
                                Button(action: {
                                    showNoticeWeb = true
                                }, label: {
                                    VStack(spacing: 10) {
                                        Image(systemName: "megaphone.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.gachonBlue)
                                        Text("공지사항")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: 75)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.white))
                                })
                                .sheet(isPresented: $showNoticeWeb) {
                                    if let url = URL(string: noticeUrl) {
                                        SafariView(url: url)
                                            .edgesIgnoringSafeArea(.all)
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    showFaqWeb = true
                                }, label: {
                                    VStack(spacing: 10) {
                                        Image(systemName: "questionmark.bubble.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(.gachonBlue)
                                        Text("FAQ")
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(.black)
                                    }
                                    .frame(width: (UIScreen.main.bounds.width - 70) / 3, height: 75)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.white))
                                })
                                .sheet(isPresented: $showFaqWeb) {
                                    if let url = URL(string: faqUrl) {
                                        SafariView(url: url)
                                            .edgesIgnoringSafeArea(.all)
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .padding(.top, 20)
                            .padding(.bottom, 25)
                            // end of 이용 내역, 공지사항, 이벤트 버튼
                        }
                        .frame(maxWidth: .infinity)
                        //.frame(height: 330)
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
                            .padding(.bottom, 45)
                            // end of 회원탈퇴 버튼
                        } // end of ScrollView
                        .padding(.bottom, tabBarHeight)
                        .alert(isPresented: $showErrorAlert) {
                            Alert(title: Text("오류"), message: Text("서버 연결에 실패했습니다."), dismissButton: .default(Text("확인")))
                        }

                        //.ignoresSafeArea()
   
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
                    .padding(.top, 50)
                    .padding(.bottom, 90)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

//                    NavigationLink("", isActive: $isLoginMove) {
//                        PrimaryView()
//                            .navigationBarBackButtonHidden(true)
//                    }
                    
                } // end of else
                    
            } // end of 전체 내용 VStack (회원, 게스트 포함)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray6))
            .navigationBarBackButtonHidden()
               
        } // end of NavigationView
        .onAppear {
            getUserInfoInquiry()
        }
        
    } // end of body
    
} // end of View strucet

#Preview {
    ProfileTabView()
}

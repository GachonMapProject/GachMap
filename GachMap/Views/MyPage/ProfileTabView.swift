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
    
    @State private var loginInfo: LoginInfo? = nil
    @State private var isLogout: Bool = false
    @State private var isPasswordCheckMove: Bool = false
    @State private var isLoginMove: Bool = false
 
    @State private var showLogoutAlert: Bool = false
    
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
    
    var body: some View {
        NavigationView {
            VStack {
                let userCode = getUserCodeFromUserDefaults()
                
                /// 나중에 !=로 바꾸기!! 꼭!!!!!
                if (userCode == nil) {
                    VStack {
                        VStack {
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
                        .frame(height: 230)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.gachonBlue2,. gachonBlue]), startPoint: .top, endPoint: .bottom)
                        )
                        
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
                        
                        Spacer()
                        
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
                        .frame(width: UIScreen.main.bounds.width - 50, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.white))
                        // end of 회원탈퇴 버튼
                        
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
                    } // 전체 VStack
                    .padding(.leading, 20)
                    .padding(.trailing, 20)

                    NavigationLink("", isActive: $isLoginMove) {
                        PrimaryView()
                            .navigationBarBackButtonHidden(true)
                    }
                    
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

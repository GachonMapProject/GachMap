//
//  ProfileModifyView.swift
//  GachMap
//
//  Created by 원웅주 on 4/18/24.
//

import SwiftUI
import Alamofire
import CryptoKit
import Combine

enum ActiveInfoModifyAlert {
    case ok, error
}

struct ProfileModifyView: View {
    
    @State private var showEscapeAlert: Bool = false
    @Binding var showModifyView: Bool
    
    let gender = ["남", "여"]
    let speed = ["빠름", "보통", "느림"]
    
    @State private var loginInfo: LoginInfo? = nil
    @State private var showExitAlert: Bool = false
    
    @State private var userInfo: UserInquiryResponse?
    @State private var isLoading: Bool = false
    
    // 받아온 유저 정보 적용
    @State private var selectedGender = ""
    @State private var selectedWalkSpeed = ""
    
    @State private var username = ""
    @State private var userNickname = ""
    @State private var userBirth = 0
    @State private var userGender = ""
    @State private var userHeight = 0
    @State private var userWeight = 0
    @State private var walkSpeed = ""
    
    @State private var isSpecialCharacterIncluded: Bool = false     // 특수문자 사용
    @State private var isAlphabeticCharacterIncluded: Bool = false  // 영어 사용
    @State private var isNumericCharacterIncluded: Bool = false     // 숫자 사용
    @State private var isPasswordCount: Bool = false                // 8~20자리 만족
    
    @State private var userId = ""
    @State private var modifyPassword = ""
    @State private var reModifyPassword = ""
    @State private var hashedModifyPassword: String? = ""
    
    @State private var alertMessage: String = ""
    @State private var showEndAlert: Bool = false
    @State private var activeInfoModifyAlert: ActiveInfoModifyAlert = .ok
    @State private var isEnd: Bool = false
    @State private var showErrorAlert: Bool = false
    
    private var isValidReModifyPassword: Bool {
        return modifyPassword == reModifyPassword
    }
    
    // 특수문자, 영어, 숫자 사용했으면 true
    private var isValidPassword: Bool {
        return isSpecialCharacterIncluded && isAlphabeticCharacterIncluded && isNumericCharacterIncluded && isPasswordCount
    }
    
    // 비밀번호 기준 통과면 "특수문자 사용" -> 우리는 버튼 활성화 정도로 하면 될듯 + 안내
    private var passwordStrengthText: String {
        if isValidPassword {
            return "Strong Password"
        } else {
            return "Password should contain at least one special character, one alphabetic character, and one numeric character."
        }
    }
    
    // 통과 여부에 따른 배경색
    private var passwordStrengthColor: Color {
        return isValidPassword ? .green : .red
    }
    
    // 통과 여부에 따른 글자색
    private var passwordStrengthForegroundColor: Color {
        return isValidPassword ? .white : .black
    }
    
    // 하단 버튼 활성화용 함수
    func isButtonEnabled() -> Bool {
        return !userNickname.isEmpty &&
        userBirth != 0 &&
        !selectedGender.isEmpty &&
        userHeight != 0 &&
        userWeight != 0 &&
        !selectedWalkSpeed.isEmpty &&
        isValidReModifyPassword
    }
    
    // SHA-256 해시 생성 함수
    func sha256(_ string: String) -> String {
        if let stringData = string.data(using: .utf8) {
            let hash = SHA256.hash(data: stringData)
            return hash.compactMap { String(format: "%02x", $0) }.joined()
        }
        return ""
    }
    
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
    
    // 서버에 저장된 사용자 정보 가져오기
    private func getUserInfoInquiry() {
        isLoading = true
        
        loginInfo = getLoginInfo()
            
        guard let userCode = loginInfo?.userCode else {
            print("userCode is nil")
            return
        }
        
        if let userCode = loginInfo?.userCode {
            self.userId = String(userCode)
        } else {
            print("userCode is nil")
            return
        }
        
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/\(userId)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get, parameters: nil, headers: nil)
            .validate()
            .responseDecodable(of: UserInquiryResponse.self) { response in
                isLoading = false
                
                switch response.result {
                case .success(let value):
                    if (value.success == true) {
                        print("회원 정보 요청 성공")
                        self.userInfo = value
                        
                        self.username = value.data.username ?? ""
                        self.userNickname = value.data.userNickname ?? ""
                        self.userBirth = value.data.userBirth ?? 0
                        self.selectedGender = value.data.userGender ?? ""
                        self.userHeight = value.data.userHeight ?? 0
                        self.userWeight = value.data.userWeight ?? 0
                        let walkSpeed = value.data.userSpeed == "FAST" ? "빠름" : value.data.userSpeed == "SLOW" ? "느림" : "보통"
                        self.selectedWalkSpeed = walkSpeed
                        
                    } else {
                        print("회원 정보 요청 실패")
                            showErrorAlert = true
                    }
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
    } // end of getUserInfoInquiry()
    
    var body: some View {
        NavigationStack {
            let userInfo = userInfo
            VStack {
                ScrollView {
                    // 첫 번째 줄
                    VStack {
                        HStack {
                            Text("아이디")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
    //                        Text("필수")
    //                            .font(.system(size: 13, weight: .bold))
    //                            .foregroundColor(.red)
                            Spacer()
                        }
                        
                        TextField("", text: $username)
                            .disabled(true)
                            .multilineTextAlignment(.leading)
                            .textContentType(.username)
                            .padding(.leading)
                            .foregroundColor(.gray)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
//                            .onAppear {
//                                username = userInfo?.data.username ?? ""
//                            }
                    }
                    .padding(.top, 10)
                    // end of 첫 번째 줄
                    
                    // 두 번째 줄
                    VStack {
                        HStack {
                            Text("비밀번호 변경")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.bottom, 1)
                        
                        Text("8~20자리의 영문, 숫자, 특수문자 필수 입력")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        SecureField("변경할 비밀번호 입력", text: $modifyPassword)
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .autocapitalization(.none) // 대문자 설정 지우기
                            .disableAutocorrection(true) // 자동 수정 해제
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                            .onChange(of: modifyPassword, perform: { value in
                                self.isPasswordCount = modifyPassword.count >= 8
                                
                                if modifyPassword.count > 20 {
                                    modifyPassword = String(modifyPassword.prefix(20))
                                }
                            })
                        
                        VStack(alignment: .leading) {
                            HStack {
                                // 비밀번호 길이에 따른 Image뷰 변경
                                if isPasswordCount {
                                    checkMark()
                                } else {
                                    xMark()
                                }
                                Text("최소 8자, 최대 20자")
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            Spacer()
                            HStack {
                                // 영문 입력 여부에 따른 Image뷰 변경
                                if isAlphabeticCharacterIncluded {
                                    checkMark()
                                } else {
                                    xMark()
                                }
                                Text("영문 입력")
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            HStack {
                                // 숫자 입력 여부에 따른 Image뷰 변경
                                if isNumericCharacterIncluded {
                                    checkMark()
                                } else {
                                    xMark()
                                }
                                Text("숫자 입력")
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            HStack {
                                // 특수문자 입력 여부에 따른 Image뷰 변경
                                if isSpecialCharacterIncluded {
                                    checkMark()
                                } else {
                                    xMark()
                                }
                                Text("특수문자 입력")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        .onReceive(Just(modifyPassword)) { newPass in
                            // 특수문자 사용했으면 isSpecialCharacterIncluded = true
                            self.isSpecialCharacterIncluded = newPass.rangeOfCharacter(from: .specialCharacters) != nil
                            
                            // 영어 사용했으면 isAlphabeticCharacterIncluded = true
                            self.isAlphabeticCharacterIncluded = newPass.rangeOfCharacter(from: .letters) != nil
                            
                            // 숫자 사용했으면 isNumericCharacterIncluded = true
                            self.isNumericCharacterIncluded = newPass.rangeOfCharacter(from: .decimalDigits) != nil
                        }
                    
                        SecureField("변경할 비밀번호 재입력", text: $reModifyPassword)
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                            .autocapitalization(.none) // 대문자 설정 지우기
                            .disableAutocorrection(true) // 자동 수정 해제
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                            .onChange(of: reModifyPassword, perform: { value in
                                if reModifyPassword.count > 20 {
                                    reModifyPassword = String(reModifyPassword.prefix(20))
                                }
                                
                                hashedModifyPassword = sha256(value)
                            })
                        
                        HStack {
                            if (modifyPassword == reModifyPassword && isPasswordCount) {
                                checkMark()
                            } else {
                                xMark()
                            }
                            Text("비밀번호 일치")
                                .foregroundColor(.black)
                            Spacer()
                        }
                        .padding(.top, 5)
                    }
                    .padding(.top, 10)
                    // end of 두 번째 줄
                    
                    // 세 번째 줄
                    VStack {
                        HStack {
                            Text("닉네임")
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                        .padding(.bottom, 1)
                        
                        Text("10자 이내")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
//                        let userInfo = userInfo
                        
                        TextField("", text: $userNickname)
                            .padding(.leading)
                            .multilineTextAlignment(.leading)
                            .textContentType(.username)
                            .autocapitalization(.none) // 대문자 설정 지우기
                            .disableAutocorrection(true) // 자동 수정 해제
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                            .onChange(of: userNickname, perform: { value in
                                // 10자 이내로 제한
                                if userNickname.count > 10 {
                                    userNickname = String(userNickname.prefix(12))
                                }
                            })
//                            .onAppear {
//                                userNickname = userInfo?.data.userNickname ?? ""
//                            }
                        
//                        if let userInfo = userInfo {
//                            TextField("", text: $userNickname)
//                                .padding(.leading)
//                                .frame(height: 45)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 10)
//                                    .fill(Color(.systemGray6))
//                                )
//                                .onChange(of: userNickname, perform: { value in
//                                    // 10자 이내로 제한
//                                    if userNickname.count > 10 {
//                                        userNickname = String(userNickname.prefix(12))
//                                    }
//                                })
//                                .onAppear {
//                                    userNickname = userInfo.data.userNickname
//                                }
//
//                        }
                    }
                    .padding(.top, 10)
                    // end of 세 번째 줄
                    
                    // 네 번째 줄
                    HStack(spacing: 5) {
                        // 출생년도
                        VStack {
                            HStack {
                                Text("출생년도")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                            }
                            
                            Picker("출생년도", selection: $userBirth) {
                                ForEach((1900...2024).reversed(), id: \.self) {
                                    Text("\(String($0))년")
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
                        
                        Spacer()
                        
                        // 성별
                        VStack {
                            HStack {
                                Text("성별")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                            }
                            
                            Picker("성별", selection: $selectedGender) {
                                ForEach(gender, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(height: 45)
                        }

                    }
                    .padding(.top, 10)
                    // end of 네 번째 줄
                    
                    // 다섯 번째 줄
                    HStack(spacing: 5) {
                        // 키
                        VStack {
                            HStack {
                                Text("키")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                            }
                            
                            Picker("키", selection: $userHeight) {
                                ForEach(120..<250, id: \.self) { height in
                                    Text("\(height)cm")
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
                        
                        Spacer()
                        
                        // 몸무게
                        VStack {
                            HStack {
                                Text("몸무게")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                            }
                            
                            Picker("몸무게", selection: $userWeight) {
                                ForEach(30..<150, id: \.self) { weight in
                                    Text("\(weight)kg")
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
                    }
                    .padding(.top, 10)
                    // end of 다섯 번째 줄
                    
                    // 여섯 번째 줄
                    VStack {
                        HStack {
                            Text("걸음 속도")
                                .foregroundColor(.black)
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                        
                        Picker("걸음 속도", selection: $selectedWalkSpeed) {
                            ForEach(speed, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(height: 30)
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    // end of 여섯 번째 줄
                    
                } // end of ScrollView
                
                Button(action: {
                    guard let hashPassword = hashedModifyPassword else {return}
                    let pw = reModifyPassword == "" ? nil : hashPassword
                    
                    let selectedSpeed = selectedWalkSpeed == "빠름" ? "FAST" : selectedWalkSpeed == "보통" ? "NORMAL" : "SLOW"
            
                    let param = UserInfoModifyRequest(password: pw, userNickname: userNickname, userSpeed: selectedSpeed, userGender: selectedGender, userBirth: userBirth, userHeight: userHeight, userWeight: userWeight)
                    
                    print("param: \(param)")
                    
                    postUserInfoModifyData(parameter: param)
                    
                }, label: {
                    Text("같이 가기")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(.white))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(isButtonEnabled() ? Color.gachonBlue : Color(UIColor.systemGray4))
                                .shadow(radius: 5, x: 2, y: 2)
                        )
                        .padding(.bottom, 20)
                        //.padding(.top, 10)
                })
                .disabled(!isButtonEnabled())
                .alert(isPresented: $showEndAlert) {
                    switch activeInfoModifyAlert {
                    case .ok:
                        return Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인"), action: { showModifyView = false }))
                        
                    case .error:
                        return Alert(title: Text("오류"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
                    }
                }

            } // end of Entire VStack
            .padding(.leading)
            .padding(.trailing)
            .navigationBarBackButtonHidden()
            .onTapGesture { self.endTextEditing() }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("개인정보 수정")
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
                        Alert(title: Text("경고"), message: Text("마이 페이지로 이동하시겠습니까?\n입력한 모든 정보가 초기화됩니다."), primaryButton: .default(Text("확인"), action: { showModifyView = false }), secondaryButton: .cancel(Text("취소"))
                        )
                    } // end of X Button
                }
                
            } // end of .toolbar
            
        } // end of NavigationStack
        .onAppear {
            getUserInfoInquiry()
        }
    } // end of body
        
    
    // postUserInfoModifyData 함수
    private func postUserInfoModifyData(parameter : UserInfoModifyRequest) {
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/\(userId)")
        else {
            print("Invalid URL")
            return
        }
            
        // Alamofire를 사용하여 POST 요청 생성
        AF.request(url, method: .patch, parameters: parameter, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserInfoModifyResponse.self) { response in
            // 서버 연결 여부
            switch response.result {
                case .success(let value):
                    print(url)
                    print(value)
                   // 개인정보 수정 내용 전달 성공 유무
                    if (value.success == true) {
                        print("개인정보 수정 성공")
                        print("value.success: \(value.success)")
                        
                        alertMessage = "개인정보 수정에 성공했습니다."
                        showEndAlert = true
                        activeInfoModifyAlert = .ok
                        
                    } else {
                        print("개인정보 수정 실패")
                        print("value.success: \(value.success)")

                        alertMessage = "개인정보 수정에 실패했습니다.\n다시 시도해주세요."
                        showEndAlert = true
                        activeInfoModifyAlert = .error
                    }
                
                case .failure(let error):
                    // 에러 응답 처리
                if let statusCode = response.response?.statusCode {
                                print("HTTP Status Code: \(statusCode)")
                            }
                
                    alertMessage = "서버 연결에 실패했습니다."
                    showEndAlert = true
                    activeInfoModifyAlert = .error
                    print(url)
                    print("Error: \(error.localizedDescription)")
            } // end of switch
        } // end of AF.request
    } // end of postUserInfoModifyData()
    
} // end of View

//#Preview {
//    ProfileTabView()
//}

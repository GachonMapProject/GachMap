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

struct ProfileModifyView: View {
    
    @State private var showModifyAlert: Bool = false
    
    let gender = ["남성", "여성"]
    let speed = ["빠름", "보통", "느림"]
    let dept = ["컴퓨터공학과", "소프트웨어학과"]
    
    // 받아온 유저 정보 적용
    @State private var selectedGender = ""
    @State private var selectedWalkSpeed = ""
    @State private var selectedDepartment = ""
    
    @State private var userNickname = "ㅇㅇ"
    @State private var userBirth = 0
    @State private var userGender = ""
    @State private var userHeight = 0
    @State private var userWeight = 0
    @State private var walkSpeed = ""
    @State private var userDepartment = ""
    
    @State private var isSpecialCharacterIncluded: Bool = false     // 특수문자 사용
    @State private var isAlphabeticCharacterIncluded: Bool = false  // 영어 사용
    @State private var isNumericCharacterIncluded: Bool = false     // 숫자 사용
    @State private var isPasswordCount: Bool = false                // 8~20자리 만족
    
    @State private var userId = "MyId"
    @State private var modifyPassword = ""
    @State private var reModifyPassword = ""
    @State private var hashedModifyPassword = ""
    
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
        !selectedWalkSpeed.isEmpty
    }
    
    // SHA-256 해시 생성 함수
    func sha256(_ string: String) -> String {
        if let stringData = string.data(using: .utf8) {
            let hash = SHA256.hash(data: stringData)
            return hash.compactMap { String(format: "%02x", $0) }.joined()
        }
        return ""
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    // 첫 번째 줄
                    VStack {
                        HStack {
                            Text("아이디")
                                .font(.system(size: 20, weight: .bold))
    //                        Text("필수")
    //                            .font(.system(size: 13, weight: .bold))
    //                            .foregroundColor(.red)
                            Spacer()
                        }
                        
                        TextField("", text: $userId)
                            .disabled(true)
                            .padding(.leading)
                            .foregroundColor(.gray)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    // end of 첫 번째 줄
                    
                    // 두 번째 줄
                    VStack {
                        HStack {
                            Text("비밀번호 변경")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                        }
                        .padding(.bottom, 1)
                        
                        Text("8~20자리의 영문, 숫자, 특수문자 필수 입력")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        SecureField("변경할 비밀번호 입력", text: $modifyPassword)
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
                                .font(.system(size: 18, weight: .bold))
                            Spacer()
                        }
                        .padding(.bottom, 1)
                        
                        Text("10자 이내")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        TextField("", text: $userNickname)
                            .padding(.leading)
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
                    }
                    .padding(.top, 10)
                    // end of 세 번째 줄
                    
                    // 네 번째 줄
                    HStack(spacing: 5) {
                        // 출생년도
                        VStack {
                            HStack {
                                Text("출생년도")
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
                    showModifyAlert = true
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
            } // end of Entire VStack
            .padding(.leading)
            .padding(.trailing)
            
            .navigationBarTitle("내 정보 수정", displayMode: .inline)
        } // end of NavigationStack
        
    } // end of body
} // end of View

#Preview {
    ProfileModifyView()
}

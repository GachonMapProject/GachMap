//
//  SignUpView.swift
//  GachMap
//
//  Created by 원웅주 on 4/17/24.
//

import SwiftUI
import Combine

enum ActiveAlert {
    case valid, invalid
}

struct SignUpView: View {
    
    @State private var showEscapeAlert: Bool = false
    @State private var isLoginViewActive: Bool = false

    @State private var userId = ""
    @State private var password = ""
    @State private var rePassword = ""
    @State private var isFull: Bool = false
    @State private var isActive: Bool = false // 뷰 이동 용
    
    @State private var isIdValid: Bool = false
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .valid
    
    @State private var isSpecialCharacterIncluded: Bool = false     // 특수문자 사용
    @State private var isAlphabeticCharacterIncluded: Bool = false  // 영어 사용
    @State private var isNumericCharacterIncluded: Bool = false     // 숫자 사용
    @State private var isPasswordCount: Bool = false                // 8~20자리 만족
    
    private var isValidRePassword: Bool {
        return password == rePassword
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
        return isIdValid && isValidPassword && isValidRePassword
    }
    
    var body: some View {
        NavigationStack {
            // 상단 이미지, 프로그레스 바
            VStack {
                Image("gach1000")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.13)
                    //.padding(.top, 15)
                
                HStack {
                    Rectangle()
                        .fill(.gachonBlue)
                        .frame(height: 3)
                    Rectangle()
                        .fill(Color(.systemGray4))
                        .frame(height: 3)
                }
                .padding(.top, 20)
            }
            .padding(.leading)
            .padding(.trailing)
            // end of 상단 이미지, 프로그레스 바
            
            // 내용 입력 부분
            VStack {
                ScrollView {
                    // 첫 번째 줄
                    VStack {
                        HStack {
                            Text("아이디")
                                .font(.system(size: 18, weight: .bold))
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        HStack {
                            TextField("6~12자리의 영문, 숫자", text: $userId)
                                .disabled(isIdValid)
                                .padding(.leading)
                                .textContentType(.username)
                                .keyboardType(.asciiCapable)
                                .autocapitalization(.none) // 대문자 설정 지우기
                                .disableAutocorrection(true) // 자동 수정 해제
                                .frame(height: 45)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                                )
                                .onChange(of: userId, perform: { value in
                                    // 1. 6~12자
                                    if userId.count > 12 {
                                        userId = String(userId.prefix(12))
                                    }
                                    
                                    // 2. 영문과 숫자만 사용 가능
                                    userId = String(userId.filter {$0.isLetter || $0.isNumber})
                                    
                                })
                            
                            Button(action: {
                                self.showAlert = true
                                
                                // 중복이 아닐 경우
                                // self.activeAlert = .valid
                                
                                // 중복인 경우
                                // self.activeAlert = .invalid
                            }, label: {
                                Text("중복 확인")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color.white)
                                    .frame(width: 80, height: 45)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(userId.count < 6 || isIdValid ? Color(UIColor.systemGray4) : Color.gachonBlue)
                                    )
                            })
                            .disabled(userId.count < 6 || isIdValid)
                            .alert(isPresented: $showAlert) {
                                switch activeAlert {
                                    // 중복 X (사용 가능)
                                case .valid:
                                    return Alert(title: Text("알림"), message: Text("사용 가능한 아이디입니다.\n사용하시겠습니까?"), primaryButton: .default(Text("사용"), action: {
                                        isIdValid = true
                                    }), secondaryButton: .cancel(Text("취소"), action: {
                                        isIdValid = false
                                    }))
                                    
                                    // 중복 O (사용 불가능)
                                case .invalid:
                                    return Alert(title: Text("경고"), message: Text("중복된 아이디입니다.\n다른 아이디를 입력해주세요."), dismissButton: .default(Text("확인")))
                                }
  
                            }

                        }
                    }
                    .padding(.top, 20)
                    // end of 첫 번째 줄
                    
                    // 두 번째 줄
                    VStack {
                        HStack {
                            Text("비밀번호")
                                .font(.system(size: 18, weight: .bold))
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        Text("8~20자리의 영문, 숫자, 특수문자 필수 입력")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 1)
                        
                        VStack {
                            SecureField("비밀번호 입력", text: $password)
                                .padding(.leading)
                                .autocapitalization(.none) // 대문자 설정 지우기
                                .disableAutocorrection(true) // 자동 수정 해제
                                .frame(height: 45)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                                )
                                .onChange(of: password, perform: { value in
                                    self.isPasswordCount = password.count >= 8
                                    
                                    if password.count > 20 {
                                        password = String(password.prefix(20))
                                    }
                                })
                            
//                            Text(passwordStrengthText)
//                                .padding()
//                                .foregroundColor(passwordStrengthForegroundColor)
//                                .background(passwordStrengthColor)
//                                .cornerRadius(10)
//                                .padding()
                            
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
                        }
                        .onReceive(Just(password)) { newPass in
                            // 특수문자 사용했으면 isSpecialCharacterIncluded = true
                            self.isSpecialCharacterIncluded = newPass.rangeOfCharacter(from: .specialCharacters) != nil
                            
                            // 영어 사용했으면 isAlphabeticCharacterIncluded = true
                            self.isAlphabeticCharacterIncluded = newPass.rangeOfCharacter(from: .letters) != nil
                            
                            // 숫자 사용했으면 isNumericCharacterIncluded = true
                            self.isNumericCharacterIncluded = newPass.rangeOfCharacter(from: .decimalDigits) != nil
                        }
                        
                        SecureField("비밀번호 재입력", text: $rePassword)
                            .padding(.leading)
                            .autocapitalization(.none) // 대문자 설정 지우기
                            .disableAutocorrection(true) // 자동 수정 해제
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                            .onChange(of: rePassword, perform: { value in
                                if rePassword.count > 20 {
                                    rePassword = String(rePassword.prefix(20))
                                }
                            })
                        HStack {
                            if (password == rePassword && isPasswordCount) {
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
                    // end of 두번째 줄
                    
                } // end of ScrollView
            } // end of 내용 입력 부분 VStack
            .padding(.leading)
            .padding(.trailing)
            // end of 내용 입력 부분
            
            // 하단 버튼 Stack
            HStack {
                Button(action: {
                    print(self.userId + self.password + self.rePassword)
                    
                    if userId != "" && password != "" && rePassword != "" {
                        isFull.toggle()
                    }
                    // 다음 뷰로 ID, PW 바인딩
                    
                    isActive = true
                    
                }, label: {
                    Text("다음")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(isButtonEnabled() ? Color.gachonBlue : Color(UIColor.systemGray4))
                                .shadow(radius: 5, x: 2, y: 2)
                            )
                        .padding(.bottom, 20)
                        .padding(.top, 15)
                })
                .disabled(!isButtonEnabled())
                
                NavigationLink(destination: InfoInputView(), isActive: $isActive) {
                    EmptyView()
                }
            }
            .background(Color.white.opacity(0.0))
            .padding(.leading)
            .padding(.trailing)
            // end of 하단 버튼 Stack
            .toolbar {
                Button(action: {
                    showEscapeAlert = true
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(Color.gray)
                                .opacity(0.7)
                                .frame(width: 35, height: 35)
                        )
                })
                .alert(isPresented: $showEscapeAlert) {
                    Alert(title: Text("경고"), message: Text("로그인 화면으로 이동하시겠습니까?\n입력한 모든 정보가 초기화됩니다."), primaryButton: .default(Text("확인"), action: { isLoginViewActive = true}), secondaryButton: .cancel(Text("취소"))
                          )
                }
                
                NavigationLink(destination: LoginView(), isActive: $isLoginViewActive) {
                    EmptyView()
                }
            }
        }
        .onTapGesture { self.endTextEditing() }
        .navigationBarBackButtonHidden()
        
    } // end of body
} // end of View

struct xMark : View {
    var body: some View {
        Image(systemName: "xmark.circle.fill")
            .foregroundColor(.red)
    }
}

struct checkMark : View {
    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
    }
}

#Preview {
    SignUpView()
}

// 특수문자 키
extension CharacterSet {
    static var specialCharacters: CharacterSet {
        return CharacterSet(charactersIn: "!@#$%^&*()-_=+[{]}|;:'\",<.>/?")
    }
}


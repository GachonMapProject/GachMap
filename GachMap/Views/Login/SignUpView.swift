//
//  SignUpView.swift
//  GachMap
//
//  Created by 원웅주 on 4/17/24.
//

import SwiftUI
import Combine
import CryptoKit

enum ActiveAlert {
    case valid, invalid
}

struct SignUpView: View {
    
    @State private var showEscapeAlert: Bool = false
    @State private var isLoginViewActive: Bool = false

    @State private var userId = ""
    @State private var password = ""
    @State private var rePassword = ""
    @State private var hashedPassword = ""
    @State private var isFull: Bool = false
    @State private var isActive: Bool = false // 뷰 이동 용
    
    @State private var isIdValid: Bool = false
    @State private var showAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .valid
    
    @State private var showServiceTermsModal: Bool = false
    @State private var showPrivacyTermsModal: Bool = false
    @State private var isOnAll: Bool = false
    @State private var isOn1: Bool = false
    @State private var isOn2: Bool = false
    @State private var isOn3: Bool = false
    
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
        return isIdValid && isValidPassword && isValidRePassword && isOnAll
    }
    
    // SHA-256 해시 생성 함수
    func sha256(_ string: String) -> String {
        if let stringData = string.data(using: .utf8) {
            let hash = SHA256.hash(data: stringData)
            return hash.compactMap { String(format: "%02x", $0) }.joined()
        }
        return ""
    }
    
//    func updateIsOnAll() {
//        isOnAll = isOn1 && isOn2
//    }
    
    var body: some View {
        NavigationStack {
            // 상단 이미지, 프로그레스 바
            VStack {
                Image("gach1200")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.08)
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
                ScrollView(.vertical, showsIndicators: false) {
                    // 첫 번째 줄
                    VStack {
                        HStack {
                            Text("아이디")
                                .font(.system(size: 20, weight: .bold))
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
                                self.activeAlert = .valid
                                
                                // 중복인 경우
                                //self.activeAlert = .invalid
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
                                .font(.system(size: 20, weight: .bold))
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding(.bottom, 1)
                        
                        Text("8~20자리의 영문, 숫자, 특수문자 필수 입력")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
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
                                
                                hashedPassword = sha256(value)
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
                    
                    // 세 번째 줄 (약관 동의)
                    VStack {
                        HStack {
                            Text("약관 동의")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Toggle("", isOn: $isOnAll)
                                .toggleStyle(CheckboxToggleStyle(style: .circle))
                                .foregroundColor(.blue)
                            
                            Text("전체 약관에 동의합니다.")
                                .bold()
                            
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Toggle("", isOn: $isOn1)
                                .toggleStyle(CheckboxToggleStyle(style: .circle))
                                .foregroundColor(.blue)
                            
                            Text("서비스 이용 약관 (필수)")
                                //.font(.system(size: 15))
                            
                            Spacer()
                            
                            Button(action: {
                                self.showServiceTermsModal = true
                            }, label: {
                                Text("보기")
                                    .foregroundColor(.gray)
                                    .sheet(isPresented: $showServiceTermsModal) {
                                        ServiceTermsView()
                                            //.presentationBackground(.thinMaterial)
                                    }
                            })
                        }
                        
                        Spacer()
                        
                        HStack {
                            Toggle("", isOn: $isOn2)
                                .toggleStyle(CheckboxToggleStyle(style: .circle))
                                .foregroundColor(.blue)
                            
                            Text("개인정보 수집 및 이용 동의 (필수)")
                                //.font(.system(size: 15))
                            
                            Spacer()
                            
                            Button(action: {
                                self.showPrivacyTermsModal = true
                            }, label: {
                                Text("보기")
                                    .foregroundColor(.gray)
                                    .sheet(isPresented: $showPrivacyTermsModal) {
                                        PrivacyTermsView()
                                            //.presentationBackground(.thinMaterial)
                                    }
                            })
                        }
                        
                        
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .onChange(of: isOnAll) { newValue in
                        if newValue {
                            isOn1 = true
                            isOn2 = true
                        } else if !newValue {
                            isOn1 = false
                            isOn2 = false
                        }
                    }
                    .onChange(of: isOn1) { newValue in
                        if newValue && isOn2 {
                            isOnAll = true
                        } else if !newValue || !isOn2 {
                            isOnAll = false
                        }
                    }
                    .onChange(of: isOn2) { newValue in
                        if newValue && isOn1 {
                            isOnAll = true
                        } else if !newValue || !isOn1 {
                            isOnAll = false
                        }
                    }

                } // end of ScrollView
            } // end of 내용 입력 부분 VStack
            .padding(.leading)
            .padding(.trailing)
            // end of 내용 입력 부분
            
            // 하단 버튼 Stack
            HStack {
                Button(action: {
                    print("ID: \(self.userId)")
                    print("PW: \(self.password)")
                    print("재입력 PW: \(self.rePassword)")
                    print("hashedPW: \(self.hashedPassword)")
                    
                    if userId != "" && password != "" && rePassword != "" {
                        isFull.toggle()
                    }
                    
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
                
                NavigationLink(destination: InfoInputView(userId: $userId, hashedPassword: $hashedPassword), isActive: $isActive) {
                    EmptyView()
                }
            }
            .background(Color.clear)
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
                .padding(.trailing, 8)
                .alert(isPresented: $showEscapeAlert) {
                    Alert(title: Text("경고"), message: Text("로그인 화면으로 이동하시겠습니까?\n입력한 모든 정보가 초기화됩니다."), primaryButton: .default(Text("확인"), action: { isLoginViewActive = true}), secondaryButton: .cancel(Text("취소"))
                          )
                }
            }
            
            NavigationLink(destination: LoginView(), isActive: $isLoginViewActive) {
                EmptyView()
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


//
//  InfoInputView.swift
//  GachMap
//
//  Created by 원웅주 on 4/17/24.
//

import SwiftUI
import Alamofire

enum ActiveInfoInputAlert {
    case ok, error
}

struct InfoInputView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var username: String
    @Binding var hashedPassword: String
    
    let gender = ["남", "여"]
    let speed = ["FAST", "NORMAL", "SLOW"]
    
    @State private var selectedGender = ""
    @State private var selectedWalkSpeed = ""
    
    @State private var userNickname = ""
    @State private var userBirth = 0
    @State private var userGender = ""
    @State private var userHeight = 0
    @State private var userWeight = 0
    @State private var walkSpeed = ""
    
    @State private var showEndAlert: Bool = false
    @State private var isEnd: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var activeInfoInputAlert: ActiveInfoInputAlert = .ok
    
    @State private var showEscapeAlert: Bool = false
    @State private var isLoginViewActive = false
    
    @State private var isOnAll = false
    @State private var isOn1 = false
    @State private var isOn2 = false
    
    // 하단 버튼 활성화용 함수
    func isButtonEnabled() -> Bool {
        return !userNickname.isEmpty &&
        userBirth != 0 &&
        !selectedGender.isEmpty &&
        userHeight != 0 &&
        userWeight != 0 &&
        !selectedWalkSpeed.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            // 상단 이미지, 프로그레스 바
            VStack {
                Image("gach1200")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.08)
                    .padding(.top, 15)
                
                HStack {
                    Rectangle()
                        .fill(.gachonBlue)
                        .frame(height: 3)
                    Rectangle()
                        .fill(.gachonBlue)
                        .frame(height: 3)
                }
                .padding(.top, 20)
            }
            .padding(.leading)
            .padding(.trailing)
            // end of 상단 이미지, 프로그레스 바
            
            VStack {
                ScrollView {
                    // 첫 번째 줄
                    VStack {
                        HStack {
                            Text("닉네임")
                                .font(.system(size: 18, weight: .bold))
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        TextField("10자 이내", text: $userNickname)
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
                    .padding(.top, 20)
                    
                    // 두 번째 줄
                    HStack(spacing: 5) {
                        // 출생년도
                        VStack {
                            HStack {
                                Text("출생년도")
                                    .font(.system(size: 18, weight: .bold))
                                Text("필수")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.red)
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
                                Text("필수")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.red)
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
                    
                    // 세 번째 줄
                    HStack(spacing: 5) {
                        // 키
                        VStack {
                            HStack {
                                Text("키")
                                    .font(.system(size: 18, weight: .bold))
                                Text("필수")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.red)
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
                                Text("필수")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.red)
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
                    
                    // 네 번째 줄
                    VStack {
                        HStack {
                            Text("걸음 속도")
                                .font(.system(size: 18, weight: .bold))
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
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
                }

            }
            .padding(.leading)
            .padding(.trailing)
            
            // 하단 버튼 Stack
            HStack {
                // 이전 뷰 이동
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("이전")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.gachonBlue))
                                .shadow(radius: 5, x: 2, y: 2)
                        )
                        .padding(.bottom, 20)
                        .padding(.top, 15)
                })
                // end of 이전 뷰 이동
                
                // 같이 가기 Button
                Button(action: {
                    print("ID: \(self.username)")
                    print("hasedPW: \(self.hashedPassword)")
                    print("닉네임: \(self.userNickname)")
                    print("출생년도: \(self.userBirth)")
                    print("성별: \(self.selectedGender)")
                    print("키: \(self.userHeight)")
                    print("몸무게: \(self.userWeight)")
                    print("선택 속도: \(self.selectedWalkSpeed)")
                    
                    // UserInfoRequest 객체 생성
                    let param = UserInfoRequest(username: username, password: hashedPassword, userNickname: userNickname, userSpeed: selectedWalkSpeed, userGender: selectedGender, userBirth: userBirth, userHeight: userHeight, userWeight: userWeight)
                    
                    postUserInfoData(parameter: param)
                    
                }, label: {
                    HStack {
                        Text("같이 가기")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(.white))
                    }
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
                .alert(isPresented: $showEndAlert) {
                    switch activeInfoInputAlert {
                    case .ok:
                        return Alert(title: Text("알림"), message: Text(alertMessage),
                                     dismissButton: .default(Text("확인"), action: { isEnd = true }))
                        
                    case .error:
                        return Alert(title: Text("오류"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
                    }
                    
                }
                // end of 같이 가기 Button
                
                NavigationLink(destination: LoginView(), isActive: $isEnd) {
                    EmptyView()
                }
            }
            .padding(.leading)
            .padding(.trailing)
            // end of 하단 버튼 HStack
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("회원가입")
                        .font(.system(size: 23, weight: .bold))
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
                        Alert(title: Text("경고"), message: Text("로그인 화면으로 이동하시겠습니까?\n입력한 모든 정보가 초기화됩니다."), primaryButton: .default(Text("확인"), action: { isLoginViewActive = true}), secondaryButton: .cancel(Text("취소"))
                        )
                    } // end of X Button
                }
                
            } // end of .toolbar
            
            NavigationLink(destination: LoginView(), isActive: $isLoginViewActive) {
                EmptyView()
            }
            
        } // end of NavigationStack
        
        .navigationBarBackButtonHidden()

    } // end of body
    
    // postUserInfoData 함수
    private func postUserInfoData(parameter : UserInfoRequest) {
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/user/signup")
        else {
            print("Invalid URL")
            return
        }
            
        // Alamofire를 사용하여 POST 요청 생성
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: UserInfoResponse.self) { response in
            // 서버 연결 여부
            switch response.result {
                case .success(let value):
                    print(value)
                   // 회원가입 및 정보 전달 성공 유무
                    if (value.success == true) {
                        print("회원가입 및 정보 전달 성공")
                        print("value.success: \(value.success)")
                        
                        if let userCode = value.data.userId as? Int64 {
                            let loginInfo = LoginInfo(userCode: userCode, guestCode: nil)
                            if let encoded = try? JSONEncoder().encode(loginInfo) {
                                UserDefaults.standard.set(encoded, forKey: "loginInfo")
                            }
                            print("userId 저장 성공, userId: \(userCode)")
                        }
                        
                        alertMessage = value.message
                        showEndAlert = true
                        activeInfoInputAlert = .ok
                        
                    } else {
                        print("회원가입 및 정보 전달 실패")
                        print("value.success: \(value.success)")

                        alertMessage = value.message ?? "알 수 없는 오류가 발생했습니다."
                        showEndAlert = true
                        activeInfoInputAlert = .error
                    }
                
                case .failure(let error):
                    // 에러 응답 처리
                if let statusCode = response.response?.statusCode {
                                print("HTTP Status Code: \(statusCode)")
                            }
                
                    alertMessage = "서버 연결에 실패했습니다."
                    showEndAlert = true
                    activeInfoInputAlert = .error
                    print("Error: \(error.localizedDescription)")
            } // end of switch
        } // end of AF.request
    } // end of postUserInfoData()
    
} // end of View

#Preview {
    InfoInputView(username: Binding.constant("전달받은 ID"), hashedPassword: Binding.constant("전달받은 암호화된 비밀번호"))
}

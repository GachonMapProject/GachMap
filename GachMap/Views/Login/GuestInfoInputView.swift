//
//  UserInfoInputView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 4/5/24.
//

import SwiftUI
import Alamofire

enum ActiveGuestInfoInputAlert {
    case ok, error
}

struct GuestInfoInputView: View {
    
    let gender = ["남", "여"]
    let speed = ["빠름", "보통", "느림"]
    
    @State private var selectedGender = ""
    @State private var selectedWalkSpeed = ""
    
    @State private var userBirth = 2000
    @State private var userGender = ""
    @State private var userHeight = 180
    @State private var userWeight = 70
    @State private var walkSpeed = ""
    
    @Binding var showGuestInfoInputView: Bool

    @State private var showEndAlert: Bool = false
    @State private var isEnd: Bool = false
    @State private var showEscapeAlert: Bool = false
    @State private var isLoginViewActive: Bool = false
    @State private var alertMessage: String = ""
    @State private var activeGuestInfoInputAlert: ActiveGuestInfoInputAlert = .ok
    
    @State private var isActive: Bool = false
    
    @State private var showServiceTermsModal: Bool = false
    @State private var showPrivacyTermsModal: Bool = false
    @State private var isOnAll: Bool = false
    @State private var isOn1: Bool = false
    @State private var isOn2: Bool = false
    @State private var isOn3: Bool = false
    
    // 하단 버튼 활성화용 함수
    func isButtonEnabled() -> Bool {
        return userBirth != 0 &&
        userHeight != 0 &&
        userWeight != 0 &&
        !selectedGender.isEmpty &&
        !selectedWalkSpeed.isEmpty &&
        isOnAll
    }
    
    var body: some View {
        NavigationStack {
            // 상단 이미지
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
                }
                .padding(.top, 20)
            }
            .padding(.leading)
            .padding(.trailing)
            // end of 상단 이미지
            
            VStack {
                ScrollView {
                    // 첫 번째 줄
                    VStack {
                        // 출생년도
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
                                    .frame(maxWidth: .infinity, alignment: .center)
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
                    
                    // 두 번째 줄
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
                    
                    // 세 번째 줄
                    VStack {
                        HStack {
                            Text("성별")
                                .font(.system(size: 18, weight: .bold))
                            Text("필수")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.red)
                            Spacer()
                        }
                        
                        Picker("걸음 속도", selection: $selectedGender) {
                            ForEach(gender, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(height: 30)
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
                    
                    // 약관 동의
                    VStack {
                        HStack {
                            Text("약관 동의")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                        }
                        
                        Spacer()
                        
                        // 토글 1 (전체 동의)
                        HStack {
                            Toggle("", isOn: $isOn1)
                                .toggleStyle(CheckboxToggleStyle(style: .circle))
                                .foregroundColor(.blue)
                            
                            Text("전체 약관에 동의합니다.")
                                .bold()
                            
                            Spacer()
                        }
                        // end of 토글 1
                        
                        Spacer()
                        
                        // 토글 2 (서비스 이용 약관 동의)
                        HStack {
                            Toggle("", isOn: $isOn2)
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
                        // end of 토글 2
                        
                        Spacer()
                        
                        // 토글 3 (개인정보 이용 동의)
                        HStack {
                            Toggle("", isOn: $isOn3)
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
                        // end of 토글 3
                        
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .onChange(of: isOn1) { newValue in
                        if newValue {
                            isOnAll = true
                            isOn2 = true
                            isOn3 = true
                        } else if !newValue && isOn2 && isOn3 {
                            isOn2 = false
                            isOn3 = false
                            isOnAll = false
                        } else if !newValue && isOn2 {
                            isOn3 = false
                            isOnAll = false
                        } else if !newValue && isOn3 {
                            isOn2 = false
                            isOnAll = false
                        }
                    }
                    .onChange(of: isOn2) { newValue in
                        if newValue && isOn3 {
                            isOn1 = true
                            isOnAll = true
                        } else if !newValue {
                            isOn1 = false
                            isOnAll = false
                        }
                    }
                    .onChange(of: isOn3) { newValue in
                        if newValue && isOn2 {
                            isOn1 = true
                            isOnAll = true
                        } else if !newValue {
                            isOn1 = false
                            isOnAll = false
                        }
                    }
                    
                } // end of ScrollView
            } // end of 내용 입력 VStack
            .padding(.leading)
            .padding(.trailing)
            
            VStack {
                // 같이 가기 Button
                Button(action: {
                    let selectedSpeed = selectedWalkSpeed == "빠름" ? "FAST" : selectedWalkSpeed == "보통" ? "NORMAL" : "SLOW"
                    
                    let param = GuestInfoRequest(guestSpeed: selectedSpeed, gusetGender: selectedGender, guestBirth: userBirth, guestHeight: userHeight, guestWeight: userWeight)
                    print("param : \(param)")
                    
                    postGuestInfoData(parameter: param)
                    
                }, label: {
                    HStack {
                        Text("같이 가기")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(.white))
                    }
                    .frame(width: UIScreen.main.bounds.width - 25, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(isButtonEnabled() ? Color.gachonBlue : Color(UIColor.systemGray4))
                            .shadow(radius: 5, x: 2, y: 2)
                    )
                    .padding(.bottom, 20)
                })
                .disabled(!isButtonEnabled())
                .alert(isPresented: $showEndAlert) {
                    switch activeGuestInfoInputAlert {
                    case .ok:
                        return Alert(title: Text("알림"), message: Text(alertMessage),
                                     dismissButton: .default(Text("확인"), action: { isEnd = true }))
                        
                    case .error:
                        return Alert(title: Text("오류"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
                    }
                    
                }
                // end of 같이 가기 Button
                
                NavigationLink("", isActive: $isEnd) {
                    PrimaryView()
                        .navigationBarBackButtonHidden(true)
                }
            } // end of VStack (버튼용)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("비회원으로 이용하기")
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
                        Alert(title: Text("경고"), message: Text("로그인 화면으로 이동하시겠습니까?\n입력한 모든 정보가 초기화됩니다."), primaryButton: .default(Text("확인"), action: { showGuestInfoInputView = false }), secondaryButton: .cancel(Text("취소"))
                        )
                    } // end of X Button
                }
                
            } // end of .toolbar
            
//            NavigationLink(destination: LoginView(), isActive: $isLoginViewActive) {
//                EmptyView()
//            }
            
        } // end of NavigationStack
        .navigationBarBackButtonHidden(true)
    } // end of body
    
    // postGuestInfoData 함수
    private func postGuestInfoData(parameter: GuestInfoRequest) {
        guard let url = URL(string: "https://8eac-58-121-110-235.ngrok-free.app/user/guest")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: GuestInfoResponse.self) { response in
                // 서버 연결 여부
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    if(value.success == true) {
                        print("비회원 정보 전달 성공")
                        
                        if let guestCode = value.data.guestId as? Int64 {
                            let loginInfo = LoginInfo(userCode: nil, guestCode: guestCode)
                            if let encoded = try? JSONEncoder().encode(loginInfo) {
                                UserDefaults.standard.set(encoded, forKey: "loginInfo")
                            }
                            print("guestId 저장 성공, guestId: \(guestCode)")
                        }
                        
                        alertMessage = "비회원 정보 저장에 성공했습니다.\nAI 서비스를 이용하시려면 로그인을 해주세요."
                        showEndAlert = true
                        activeGuestInfoInputAlert = .ok
                        
                    } else {
                        print("비회원 정보 전달 실패")
                        
                        alertMessage = "정보 저장에 실패했습니다.\n다시 시도해주세요."
                        showEndAlert = true
                        activeGuestInfoInputAlert = .error
                    }
                    
                case .failure(let error):
                    print("서버 연결 실패")
                    alertMessage = "서버 연결에 실패했습니다."
                    showEndAlert = true
                    activeGuestInfoInputAlert = .error
                    
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
} // end of View

    #Preview {
        GuestInfoInputView(showGuestInfoInputView: Binding.constant(true))
    }

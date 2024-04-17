//
//  UserInfoInputView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 4/5/24.
//

import SwiftUI



struct CheckboxToggleStyle: ToggleStyle {
  @Environment(\.isEnabled) var isEnabled
  let style: Style // custom param

  func makeBody(configuration: Configuration) -> some View {
    Button(action: {
      configuration.isOn.toggle() // toggle the state binding
    }, label: {
      HStack {
        Image(systemName: configuration.isOn ? "checkmark.\(style.sfSymbolName).fill" : style.sfSymbolName)
          .imageScale(.large)
        configuration.label
      }
    })
    .buttonStyle(PlainButtonStyle()) // remove any implicit styling from the button
    .disabled(!isEnabled)
  }

  enum Style {
    case square, circle

    var sfSymbolName: String {
      switch self {
      case .square:
        return "square"
      case .circle:
        return "circle"
      }
    }
  }
}

struct UserInfoInputView: View {
    
    let gender = ["남성", "여성"]
    let speed = ["빠름", "보통", "느림"]
    let dept = ["컴퓨터공학과", "소프트웨어학과", "전자공학과", "전기공학과", "스마트보안학과"] // 서버에서 받아오기
    
    @State private var selectedGender = ""
    @State private var selectedWalkSpeed = "보통"
    @State private var selectedDepartment = ""
    
    @State private var userNickname = ""
    @State private var userBirth = 2024
    @State private var userGender = ""
    @State private var userHeight = 170
    @State private var userWeight = 65
    @State private var walkSpeed = ""
    @State private var userDepartment = ""
    
    @State private var allAgree = false
    @State private var isOn1 = false
    @State private var isOn2 = false
    @State private var isOn3 = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack { // 입력 필드용 VStack
                    
                    Image("gach1000")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width - 25)
                        .padding(.top, 35)
                    
                    // 첫번째 줄 시작 (닉네임)
                    VStack {
                        HStack {
                            Text("닉네임")
                                .font(.system(size: 18, weight: .bold))
                                //.id(index)
                                //.padding(.leading)
                            Spacer()
                        }
                        
                        HStack {
                            TextField("10자 이내", text: $userNickname)
                                .padding(.leading)
                        }
                        .frame(height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                        )
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                    Spacer()
                    
                    // 두번째 줄 시작 (출생년도, 성별)
                    HStack(spacing: 5) {
                        VStack {
                            HStack {
                                Text("출생년도")
                                    .font(.system(size: 18, weight: .bold))
                                    //.padding(.leading)
                                Spacer()
                            }
                            
                            // 출생년도 내림차순으로 정렬, 컴마빼는 방법 찾아보기
                            Picker("출생년도", selection: $userBirth) {
                                ForEach(1900..<2025, id: \.self) { year in
                                    Text("\(year)년")
                                        .tag(userBirth)
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
                        .padding(.leading)
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                Text("성별")
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                            }
                            
                            Picker("성별을 선택하세요.", selection: $selectedGender) {
                                ForEach(gender, id: \.self) {
                                    Text($0)
                                }
                            }
                            .pickerStyle(.segmented)
                            .frame(height: 45)
                        }
                        .padding(.trailing)
                        
                    }
                    
                    Spacer()
                    
                    // 세번째 줄 시작 (키, 몸무게)
                    HStack(spacing: 5) {
                        VStack {
                            HStack {
                                Text("키")
                                    .font(.system(size: 18, weight: .bold))
                                    //.padding(.leading)
                                Spacer()
                            }
                            
                            Picker("키", selection: $userHeight) {
                                ForEach(120..<250, id: \.self) { height in
                                    Text("\(height)cm")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                        }
                        .padding(.leading)
                        
                        Spacer()
                        
                        VStack {
                            HStack {
                                Text("몸무게")
                                    .font(.system(size: 18, weight: .bold))
                                    //.padding(.leading)
                                Spacer()
                            }
                            
                            Picker("몸무게", selection: $userWeight) {
                                ForEach(30..<150, id: \.self) { weight in
                                    Text("\(weight)kg")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )

                        }
                        .padding(.trailing)
                        
                    }
                    
                    Spacer()
                    
                    // 네번째 줄 시작 (걸음 속도)
                    VStack {
                        HStack {
                            Text("걸음 속도")
                                .font(.system(size: 18, weight: .bold))
                                //.padding(.leading)
                            Spacer()
                        }

                        Picker("걸음 속도를 선택하세요.", selection: $selectedWalkSpeed) {
                            ForEach(speed, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(height: 30)
                    }
                    .padding(.leading)
                    .padding(.trailing)
                    
                    Spacer()
                    
                    // 다섯번째 줄 시작 (학과)
                    VStack {
                        HStack {
                            Text("학과")
                                .font(.system(size: 18, weight: .bold))
                                //.padding(.leading)
                            Spacer()
                        }
                        
                        HStack {
                            Picker("학과를 선택하세요.", selection: $selectedDepartment) {
                                ForEach(dept, id: \.self) {
                                    Text($0)
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
                    } // 다섯번째 줄 끝 (학과)
                    .padding(.leading)
                    .padding(.trailing)
                    
                    Spacer()
                    
                    HStack {
                        Toggle("", isOn: $isOn1)
                            .toggleStyle(CheckboxToggleStyle(style: .circle))
                            .foregroundColor(.blue)
                        
                        Text("전체 약관에 동의합니다.")
                            .font(.system(size: 15, weight: .bold))
                        
                        Spacer()
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    HStack {
                        Toggle("", isOn: $isOn2)
                            .toggleStyle(CheckboxToggleStyle(style: .circle))
                            .foregroundColor(.blue)
                        
                        Text("서비스 이용 약관 (필수)")
                            .font(.system(size: 15))
                        
                        Spacer()
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    HStack {
                        Toggle("", isOn: $isOn3)
                            .toggleStyle(CheckboxToggleStyle(style: .circle))
                            .foregroundColor(.blue)
                        
                        Text("개인정보 수집 및 이용 동의 (필수)")
                            .font(.system(size: 15))
                        
                        Spacer()
                    }
                    .padding(.leading)
                    
                    // Spacer()
                    
                } // end of Input Fields VStack
                // .onTapGesture { self.endTextEditing() }
            } // end of ScrollView
            
            VStack {
                //Spacer()
                
                // 같이 가기 Button
                Button(action: {
                    
                }, label: {
                    HStack {
                        Text("같이 가기")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(.white))
                    }
                    .frame(width: UIScreen.main.bounds.width - 25, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            //.fill(Color(.systemBlue))
                            .shadow(radius: 5, x: 2, y: 2)
                    )
                    .padding(.bottom, 20)
                    .padding(.top, 15)
                })
                // .disabled(username.isEmpty || password.isEmpty)
                // end of 같이 가기 Button
            }
        } // end of Entire VStack
        
    } // end of body
    
} // end of View

#Preview {
    UserInfoInputView()
}

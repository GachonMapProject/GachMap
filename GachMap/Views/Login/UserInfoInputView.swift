//
//  UserInfoInputView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 4/5/24.
//

import SwiftUI

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}

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
    let dept = ["컴퓨터공학과", "소프트웨어학과", "전자공학과", "전기공학과", "스마트보안학과"]
    
    @State private var selectedGender = ""
    @State private var selectedWalkSpeed = ""
    @State private var selectedDepartment = ""
    
    @State private var userNickname = ""
    @State private var userBirth = ""
    @State private var userGender = ""
    @State private var userHeight = ""
    @State private var userWeight = ""
    @State private var walkSpeed = ""
    @State private var userDepartment = ""
    
    @State private var allAgree = false
    @State private var isOn1 = false
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    VStack { // 입력 필드용 VStack
                        HStack { // 메인 이미지 시작
                            Image("gach1000")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .padding(.leading)
                                .padding(.trailing)
                        }
                        .padding(.top)
                        // end of main Image
                        
                        VStack { // 첫번째 줄 시작 (닉네임
                            HStack {
                                Text("닉네임")
                                    .font(.system(size: 18, weight: .bold))
                                    //.id(index)
                                    //.padding(.leading)
                                Spacer()
                            }
                            
                            HStack {
                                TextField("10자 이내", text: $userNickname)
//                                    .onTapGesture {
//                                        withAnimation {
//                                            proxy.scrollTo(index, anchor: .top)
//                                        }
//                                    }
                                    .padding(.leading)
                            }
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                        } // 첫번째 줄 끝 (닉네임)
                        .padding(.leading)
                        .padding(.trailing)
                        
                        Spacer()
                        
                        HStack(spacing: 5) { // 두번째 줄 시작 (출생년도, 성별)
                            VStack {
                                HStack {
                                    Text("출생년도")
                                        .font(.system(size: 18, weight: .bold))
                                        //.padding(.leading)
                                    Spacer()
                                }
                                
                                HStack {
                                    TextField("", text: $userBirth)
                                        .padding(.leading)
                                }
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
                                        //.padding(.leading)
                                    Spacer()
                                }
                                
                                HStack {
                                    Picker("성별을 선택하세요.", selection: $selectedGender) {
                                        ForEach(gender, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }
                                .frame(height: 45)
            //                    .background(
            //                        RoundedRectangle(cornerRadius: 10)
            //                            .fill(Color(.systemGray6))
            //                    )
                            }
                            .padding(.trailing)
                            
                        } // 두번째 줄 끝 (출생년도, 성별)
                        
                        Spacer()
                        
                        HStack(spacing: 5) { // 세번째 줄 시작 (키, 몸무게)
                            VStack {
                                HStack {
                                    Text("키")
                                        .font(.system(size: 18, weight: .bold))
                                        //.padding(.leading)
                                    Spacer()
                                }
                                
                                HStack {
                                    TextField("", text: $userHeight)
                                        .padding(.leading)
                                }
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
                                
                                HStack {
                                    TextField("", text: $userWeight)
                                        .padding(.leading)
                                }
                                .frame(height: 45)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                )

                            }
                            .padding(.trailing)
                            
                        } // 세번째 줄 끝 (키, 몸무게)
                        
                        Spacer()
                        
                        VStack { // 네번째 줄 시작 (걸음 속도)
                            HStack {
                                Text("걸음 속도")
                                    .font(.system(size: 18, weight: .bold))
                                    //.padding(.leading)
                                Spacer()
                            }
                            
                            HStack {
                                Picker("걸음 속도를 선택하세요.", selection: $selectedWalkSpeed) {
                                    ForEach(speed, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            .frame(height: 30)
                            
                        } // 네번째 줄 끝 (걸음 속도)
                        .padding(.leading)
                        .padding(.trailing)
                        
                        Spacer()
                        
                        VStack { // 다섯번째 줄 시작 (학과)
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
                        
                        VStack {
                            HStack {
                                Toggle("", isOn: $isOn1)
                                    .toggleStyle(CheckboxToggleStyle(style: .circle))
                                    .foregroundColor(.blue)
                                
                                Text("전체 약관에 동의합니다.")
                                    .font(.system(size: 18, weight: .bold))
                                
                                Spacer()
                            }
                            .padding(.leading)
                        }
                        
                        // Spacer()
                        
                    } // end of 전체 내용 VStack
                    
                } // end of ScrollView
            } // end of ScrollViewReader
            
            Spacer()
            
            VStack {
                Spacer()
                
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
                })
                // .disabled(username.isEmpty || password.isEmpty)
                // end of 같이 가기 Button
            }
            
            

        } // end of ZStack (전체 화면 + 버튼 하단 배치용)
        
    } // end of body
} // end of View

#Preview {
    UserInfoInputView()
}

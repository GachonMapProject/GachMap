//
//  InfoInputView.swift
//  GachMap
//
//  Created by 원웅주 on 4/17/24.
//

import SwiftUI

struct InfoInputView: View {
    
    let gender = ["남성", "여성"]
    let speed = ["빠름", "보통", "느림"]
    let dept = ["컴퓨터공학과", "소프트웨어학과"]
    
    @State private var selectedGender = ""
    @State private var selectedWalkSpeed = ""
    @State private var selectedDepartment = ""
    
    @State private var userNickname = ""
    @State private var userBirth = 0
    @State private var userGender = ""
    @State private var userHeight = 0
    @State private var userWeight = 0
    @State private var walkSpeed = ""
    @State private var userDepartment = ""
    
    @State private var isOnAll = false
    @State private var isOn1 = false
    @State private var isOn2 = false
    
    var body: some View {
        VStack {
            Image("gach1000")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: UIScreen.main.bounds.height * 0.15)
                .padding(.top, 35)
            
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
        
        VStack {
            ScrollView {
                // 첫 번째 줄
                VStack {
                    HStack {
                        Text("닉네임")
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Text("필수")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.red)
                    }
                    
                    TextField("10자 이내", text: $userNickname)
                        .padding(.leading)
                        .frame(height: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                        )
                }
                .padding(.top, 20)
                
                // 두 번째 줄
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
                        
                        Picker("성별", selection: $userGender) {
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
                
                // 네 번째 줄
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
                
//                // 다섯 번째 줄
//                VStack {
//                    HStack {
//                        Text("학과")
//                            .font(.system(size: 18, weight: .bold))
//                        Spacer()
//                    }
//
//                    Picker("학과", selection: $selectedDepartment) {
//                        ForEach(dept, id: \.self) {
//                            Text($0)
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 45)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                        .fill(Color(.systemGray6))
//                    )
//                }
//                .padding(.top, 10)
            }

        // .onTapGesture { self.endTextEditing() }
        }
        .padding(.leading)
        .padding(.trailing)
        
        // 하단 버튼 Stack
        HStack {
            // 이전 뷰 Button
            Button(action: {
                
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
            // end of 이전 뷰 버튼
            
            // 같이 가기 Button
            Button(action: {
                
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
                        .fill(Color(.gachonBlue))
                        .shadow(radius: 5, x: 2, y: 2)
                )
                .padding(.bottom, 20)
                .padding(.top, 15)
            })
            // .disabled(userNickname.isEmpty || userBirth.words.isEmpty || userGender.isEmpty || userHeight.words.isEmpty || userWeight.words.isEmpty || walkSpeed.isEmpty)
            // end of 같이 가기 Button
        }
        .padding(.leading)
        .padding(.trailing)
        // end of 하단 버튼 HStack

    } // end of body
} // end of View

#Preview {
    InfoInputView()
}

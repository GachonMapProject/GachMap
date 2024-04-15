//
//  UserInfoInputView.swift
//  FreeGachonMap
//
//  Created by 원웅주 on 4/5/24.
//

import SwiftUI

struct GuestInfoInputView: View {
    
    let gender = ["남성", "여성"]
    let speed = ["빠름", "보통", "느림"]
    
    @State private var selectedGender = ""
    @State private var selectedWalkSpeed = ""
    
    @State private var userBirth = ""
    @State private var userGender = ""
    @State private var userHeight = ""
    @State private var userWeight = ""
    @State private var walkSpeed = ""
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        Image("gach1000")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.leading)
                            .padding(.trailing)
                    }
                    .padding(.top)
                    // end of main Image
                    
                    VStack { // 첫번째 줄 시작 (출생년도)
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
                    } // 첫번째 줄 끝 (출생년도)
                    .padding(.leading)
                    .padding(.trailing)
                    
                    Spacer()
                    
                    HStack(spacing: 5) { // 두번째 줄 시작 (키, 몸무게)
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
                        
                    } // 두번째 줄 끝 (키, 몸무게)
                    
                    Spacer()
                    
                    VStack { // 세번째 줄 시작 (성별)
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
                        .frame(height: 30)
                        
                    } // 세번째 줄 끝 (성별)
                    .padding(.leading)
                    .padding(.trailing)
                    
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
                    
                    
                } // end of VStack (본문 입력 필드용)
                
                // Spacer()
                
            } // end of ScrollView
            
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
                
            } // end of VStack (버튼용)
                
        } // end of ZStack
            
    } // end of body
} // end of View

    #Preview {
        GuestInfoInputView()
    }

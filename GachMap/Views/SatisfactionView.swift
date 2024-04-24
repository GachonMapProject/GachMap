//
//  SatisfactionView.swift
//  GachMap
//
//  Created by 이수현 on 4/23/24.
//

import SwiftUI

struct SatisfactionView: View {
    var width = UIScreen.main.bounds.width
    @State var pathSelect = -1
    @State var timeSelect = -1
    @State var submit = false
    
    var body: some View {
        VStack{
            Spacer()
            VStack(alignment : .leading){
                HStack(spacing : 0){
                    Text("추천 경로")
                        .bold()
                    Text("에 대해")
                    Spacer()
                }
                HStack(spacing : 0){
                    Text("만족")
                        .bold()
                    Text("하셨나요?")
                    Spacer()
                }
            } // end of VStack
            .font(.system(size: 32))
            .padding(.bottom, 30)
            
            Text("경로 만족도 평가는 개인별 소요시간 및 경로 예측도 향상에 큰 도움이 됩니다.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .frame(width: width * 0.7)
                .padding(.bottom, 30)
            
            SatisfactionButtonView(name: "경로 평가", select: $pathSelect)
                .padding(.bottom, 30)
            
            SatisfactionButtonView(name: "소요시간 정확도", select: $timeSelect)
            Spacer()
            
            Button(action: {
                // 데이터 서버에 전달하는 함수 필요
                submit = true
            }, label: {
                Text("확인")
                    .frame(width: width * 0.7, height: 50)
                    .foregroundColor(.white)
            })
            .background(timeSelect == -1 || pathSelect == -1 ? Color.gray.opacity(0.3) : Color.blue)
            .multilineTextAlignment(.center)
            .cornerRadius(15)
            .shadow(radius: 5, x: 2, y: 2)
            .font(.system(size: 20))
            .disabled(timeSelect == -1 || pathSelect == -1)
            .padding(.bottom, 30)
            
            
        } // end of VStack
        .frame(width: width * 0.9)
        .alert(isPresented: $submit) {
            Alert(title: Text("만족도 조사"), message: Text("소중한 의견 감사드립니다."),
                  dismissButton: .default(Text("확인")))
        }
      
            

        
        
    }
}


struct SatisfactionButtonView: View {
    
    var name : String
    let selectedGradient = LinearGradient(
        gradient: Gradient(colors: [
            Color(red: 1.0, green: 0.0, blue: 1.0).opacity(1.0),
            Color(red: 0.5686, green: 0.0863, blue: 0.9765).opacity(1.0),
            Color(red: 0.1922, green: 0.6000, blue: 1.0).opacity(1.0)
        ]),
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )
    let gradient = LinearGradient(colors: [Color(red: 0.937, green: 0.941, blue: 0.965)],startPoint: .bottom, endPoint: .top)
    
    @Binding var select : Int
    
    var body: some View {
        VStack{
            Text(name)
                .font(.system(size: 24))
                .bold()
                .padding(.bottom, 10)
            HStack(spacing : 20){
                Button(action: {
                    self.select = 1
                }, label: {
                    Text("😖")
                        .font(.system(size: 40))
                })
                .background{
                    Circle()
                        .fill(
                            select == 1 ? selectedGradient : gradient
                            
                        )
                        .frame(width: 60, height: 60)
                }
                
                Button(action: {
                    select = 2
                }, label: {
                    Text("😒")
                        .font(.system(size: 40))
                })
                .background{
                    Circle()
                        .fill(
                            select == 2 ? selectedGradient : gradient
                        )
                        .frame(width: 60, height: 60)
                }
                
                Button(action: {
                    select = 3
                }, label: {
                    Text("😐")
                        .font(.system(size: 40))
                })
                .background{
                    Circle()
                        .fill(
                            select == 3 ? selectedGradient : gradient
                        )
                        .frame(width: 60, height: 60)
                }
                
                Button(action: {
                    select = 4
                }, label: {
                    Text("🙂")
                        .font(.system(size: 40))
                })
                .background{
                    Circle()
                        .fill(
                            select == 4 ? selectedGradient : gradient
                        )
                        .frame(width: 60, height: 60)
                }
                
                Button(action: {
                    select = 5
                }, label: {
                    Text("😍")
                        .font(.system(size: 40))
                })
                .background{
                    Circle()
                        .fill(
                            select == 5 ? selectedGradient : gradient
                        )
                        .frame(width: 60, height: 60)
                }
                
                
            }
        }
    }
}

#Preview {
    SatisfactionView()
}

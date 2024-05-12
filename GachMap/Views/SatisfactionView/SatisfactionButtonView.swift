//
//  SatisfactionButtonView.swift
//  GachMap
//
//  Created by 이수현 on 5/12/24.
//

import SwiftUI

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


//#Preview {
//    SatisfactionButtonView()
//}

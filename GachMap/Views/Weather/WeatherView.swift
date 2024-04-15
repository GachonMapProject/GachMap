//
//  WeatherView.swift
//  GachMap
//
//  Created by 이수현 on 4/15/24.
//

import SwiftUI

struct WeatherView: View {
    @State var temp = 0
    @State var sky = "맑음"
    @State var image = "☀️"
    @State var time = "00"
    @State var AMPM = "오전"
    
    
    var body: some View {
        HStack{
            VStack{
                VStack(alignment: .leading){
                    Text("🌡️ 날씨")
                        .font(.system(size: 20))
                        .bold()
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                    Spacer()
                    VStack{
                        Text(image)
                            .font(.system(size: 80))
                            .padding(.bottom, 10)
                        HStack{
                            Text("\(temp)°")
                                .font(.system(size: 25))
                            Text(sky)
                                .font(.system(size: 25))
                        }
                        .bold()
                    }
                    .frame(width: 137)
                    Spacer()
                    Text("📍 복정동 \n  \(AMPM) \(time)시 기준")
                        .lineSpacing(5)
                        .font(.system(size: 15))
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
                        
                        
//                    Text("\(time)시 기준")

                    
                }
               
            }
            .frame(width: 137, height: 258)
            
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.blue)
                .shadow(radius: 7, x: 2, y: 2)
                .frame(width: 137, height: 258)

        }
        .onAppear(){
            WeatherData().WeatherDataRequest { newWeather in
                if let newWeather = newWeather {
                    print("weather: \(newWeather)")
                }
            }

        }
    }
}

#Preview {
    WeatherView()
}

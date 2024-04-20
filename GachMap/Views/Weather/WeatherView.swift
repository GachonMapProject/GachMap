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
    let sky_image = ["맑음" : "☀️", "구름 많음" : "🌥️", "흐림" : "☁️", "비" : "☔️", "비/눈" : "🌨️", "눈" : "❄️"]
    let weatherData = WeatherData()
    
    var body: some View {
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
                            .font(.system(size: sky == "구름 많음" ? 22 : 25))
                        Text(sky)
                            .font(.system(size: sky == "구름 많음" ? 22 : 25))
                    }
                    .bold()
                }
                .frame(width: 137)
                Spacer()
                Text("📍 복정동 \n  \(AMPM) \(time)시 기준")
                    .lineSpacing(5)
                    .font(.system(size: 15))
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 0))
            }
           
        }
        .frame(width: 137, height: 258)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 7, x: 2, y: 2) // 그림자를 적용할 부모 뷰에 그림자 추가
        .onAppear(){
            weatherData.WeatherDataRequest { newWeather in
                if let newWeather = newWeather {
                    print("weather: \(newWeather)")
                    self.temp = Int(newWeather.temp)
                    if newWeather.precipitationForm == "없음" {
                        self.sky = newWeather.sky
                        self.image = sky_image[newWeather.sky] ?? "☀️"
                    }
                    else {
                        self.sky = newWeather.precipitationForm
                        self.image = sky_image[newWeather.precipitationForm] ?? "☀️"
                    }
                    
                    
                }
                let time = Int(String(weatherData.baseTime.dropLast(2))) ?? 0
                if time < 12 {
                    self.AMPM = "오전"
                    self.time = String(time)
                    
                }
                else if time == 12{
                    self.AMPM = "오후"
                    self.time = String(time)
                    
                }
                else {
                    self.time = String(time - 12)
                    self.AMPM = "오후"
                }

               
            }

        }
    }
}

#Preview {
    WeatherView()
}

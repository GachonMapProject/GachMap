import Alamofire
import SwiftUI

class WeatherData {
    
    let key = "Q1UlVchU%2BjoTRx0JMz1%2F9P4x%2BVVo5o%2FpfmTSLmb3ubV9Kk%2FtFcpTI7J%2Fy4bfoXpra17LrAVL5nMR%2Br6UVv8VNg%3D%3D"
    let date = Date()
    let dateFormatter = DateFormatter()
    
    var baseDate: String {
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: date)
    }
    
    var baseTime: String {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        // 분 단위로 45분 미만이면 이전 시간 데이터 사용
        let roundedHour: Int
        if minute < 45 {
            roundedHour = hour - 1
        } else {
            roundedHour = hour
        }
        
        // 조정된 시간을 문자열로 변환하여 반환
        return String(format: "%02d30", roundedHour)
    }

    var latXlngY = convertGRID_GPS(mode: 0, lat_X: 37.455086, lng_Y: 127.133315)
    
    var requestURL : String {
        "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?serviceKey=\(key)&pageNo=1&numOfRows=60&base_date=\(baseDate)&base_time=\(baseTime)&nx=\(latXlngY.x)&ny=\(latXlngY.y)"
    }
    
    func WeatherDataRequest(completion: @escaping (Weather?) -> Void){
        // API 요청을 보낼 URL 생성
        guard let url = URL(string: requestURL) else {
            print("Invalid URL")
            return
        }
        print(url)
        
        AF.request(url, method: .get).responseString {response in
            // 에러 처리
            switch response.result {
                case .success(let value):
                    // 성공적인 응답 처리
                    print("성공")
                    print("value : \(value)")
                    let data = value.data(using: .utf8)
                    let parser = XMLParser(data: data!)
                    var temp = 0.0   // 온도
                    var sky = ""            // 하늘 상태
                    var precipitationForm = ""   // 강수 형태
                    var precipitation = 0.0     // 강수량
                
                    let delegate = MyXMLParserDelegate(completion: { items in
                        for (key, value) in items {
                            if key == "T1H" {
                                if let doubleValue = Double(value) {
                                    temp = doubleValue
                                }
                            } else if key == "SKY" {
                                switch value {
                                    case "1" : sky = "맑음"
                                    case "3" : sky = "구름 많음"
                                    case "4" : sky = "흐림"
                                    default : sky = "맑음"
                                }
                            
                            } else if key == "PTY" {
                                switch value {
                                    case "0" : precipitationForm = "없음"
                                    case "1", "4" : precipitationForm = "비"
                                    case "2", "5" : precipitationForm = "비/눈"
                                    case "3", "6" : precipitationForm = "눈"
                                    default : precipitationForm = "없음"
                                }
                            }  else if key == "RN1" {
                                let newValue = String(value.dropLast(3))
                                print(newValue) // 출력: "1"
                                if let doubleValue = Double(newValue) {
                                    precipitation = doubleValue
                                }
                            }
                        }
                    })
                    parser.delegate = delegate
                    parser.parse()
                let weather = Weather(temp: temp, sky: sky, precipitationForm: precipitationForm, precipitation: precipitation)
                   completion(weather)
    
            
            case .failure(let error):
                // 에러 응답 처리
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

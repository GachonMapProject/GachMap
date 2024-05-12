//
//  ChoosePathTestView.swift
//  GachMap
//
//  Created by 이수현 on 5/11/24.
//

import SwiftUI
import Alamofire
import CoreLocation

struct ChoosePathTestView: View {
    let departure = 6
    let arrival = 20
    @State var paths : [PathData]? = nil
    @State var startLocation = "현재위치"
    @State var endLocation = "반도체대학"
    let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: 37.4514039, longitude: 127.1295702), altitude: 58, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    
    var body: some View {
        if paths == nil {
            HStack{
                VStack{
                    Text(startLocation)
                    Text(endLocation)
                }
                Button(action: {
                    if startLocation == "현재위치" {
                        getUserLocationPath(location : location, arrival: arrival)
                    }
                    else{
                        getPath(departure: departure, arrival: arrival)
                    }
                    
                }, label: {
                    Text("길찾기")
                })
            }
        }
        else{
            ChoosePathView(paths : paths!)
        }
       
    }
    
    // 현재위치 x
    func getPath(departure : Int, arrival : Int) {
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/route?departure=\(departure)&arrival=\(arrival)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: PathResponse.self) { response in
//                print("Response: \(response)")
                print("URL : \(url)")
                switch response.result {
                case .success(let value):
                    if(value.success == true) {
                        print("지정 위치 경로 가져오기 성공")
                        paths = value.data
                        print(paths)

                    } else {
                        print("지정 위치 경로 가져오기 실패")

                    }
                    
                case .failure(let error):
                    // 서버 연결 실패할 때도 검색 결과 없음 표시
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
    // 현재위치 o
    func getUserLocationPath(location : CLLocation, arrival : Int) {
//    http://ceprj.gachon.ac.kr:60002/map/route-now/{placeId}?latitude=37.44535&longitude=127.12673&altitude=54
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/map/route-now/\(arrival)?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&altitude=\(location.altitude)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: PathResponse.self) { response in
//                print("Response: \(response)")
                print("URL : \(url)")
                switch response.result {
                case .success(let value):
//                    print(value)
                    if(value.success == true) {
                        print("현재위치 - 경로 가져오기 성공")
                        paths = value.data

                    } else {
                        print("현재위치 - 경로 가져오기 실패")

                    }
                    
                case .failure(let error):
                    // 서버 연결 실패할 때도 검색 결과 없음 표시
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }

}

#Preview {
    ChoosePathTestView()
}

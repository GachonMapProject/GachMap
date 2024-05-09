//
//  InquireDetailView.swift
//  GachMap
//
//  Created by 원웅주 on 4/30/24.
//

import SwiftUI
import Alamofire

//class InquireDetailViewModel: ObservableObject {
//    @Published var inquiryDetail: [InquireDetailData]
//    var inquiryId: Int
//    
//    init(inquiryId: Int) {
//            self.inquiryId = inquiryId
//            getInquireDetail()  // 조회 함수를 여기서 호출
//        }
//    
//    // 문의 상세 정보 가져오기
//    private func getInquireDetail() {
//        guard let url = URL(string: "https://8eac-58-121-110-235.ngrok-free.app/inquiry/list/\(inquiryId)")
//        else {
//            print("Invalid URL")
//            return
//        }
//        
//        AF.request(url, method: .get)
//            .validate()
//            .responseDecodable(of: InquireDetailResponse.self) { response in
//                print("Response: \(response)")
//                switch response.result {
//                case .success(let value):
//                    print(value)
//                    
//                    if(value.success == true) {
//                        print("1:1 문의 상세 정보 가져오기 성공")
//                        self.inquiryDetail = value.data
//                        
//                        print("Data fetched: \(String(describing: self.inquiryDetail))")
//                    } else {
//                        print("1:1 문의 상세 정보 가져오기 실패")
//                    }
//                    
//                case .failure(let error):
//                    print("서버 연결 실패")
//                    print(url)
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
//    }
//}

struct InquireDetailView: View {
    @Environment(\.dismiss) private var dismiss

    var inquiryId: Int
       
    @State private var inquireCategory: String = ""
    @State private var inquireStatus: Bool = false
    @State private var inquireDate: String = ""
    @State private var inquireTitle: String = ""
    @State private var inquireDetail: String = ""
    @State private var answerDetail: String = ""
    
    // 문의 상세 정보 가져오기
    private func getInquireDetail() {
        guard let url = URL(string: "http://ceprj.gachon.ac.kr:60002/inquiry/\(inquiryId)")
        else {
            print("Invalid URL")
            return
        }
        
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: InquireDetailResponse.self) { response in
                print("Response: \(response)")
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    if(value.success == true) {
                        print("1:1 문의 상세 정보 가져오기 성공")
                        
                        inquireCategory = value.data.inquiryCategory
                        inquireStatus = value.data.inquiryProgress
                        inquireDate = value.data.createDt
                        inquireTitle = value.data.inquiryTitle
                        inquireDetail = value.data.inquiryContent
                        answerDetail = value.data.inquiryAnswer ?? ""
                        
                    } else {
                        print("1:1 문의 상세 정보 가져오기 실패")
                    }
                    
                case .failure(let error):
                    print("서버 연결 실패")
                    print(url)
                    print("Error: \(error.localizedDescription)")
                }
            }
    }
    
    func selectedInquiryCategory(category: String) -> String {
        switch category {
        case "Node":
            return "지점 문의"
        case "Route":
            return "경로 문의"
        case "AITime":
            return "AI 소요시간"
        case "AR":
            return "AR 문의"
        case "Event":
            return "행사 문의"
        case "Place":
            return "장소 문의"
        case "Etc":
            return "기타 문의"
        default:
            return ""
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("문의 항목")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            HStack {
                                Text(selectedInquiryCategory(category: inquireCategory))
                                    .padding(.leading)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("문의 상태")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            HStack {
                                Text(inquireStatus ? "답변 완료" : "답변 대기중")
                                    .padding(.leading)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                            
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("작성일")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextField("", text: $inquireDate)
                            .padding(.leading)
                            .multilineTextAlignment(.leading)
                            .disabled(true)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("문의 제목")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextField("", text: $inquireTitle)
                            .padding(.leading)
                            .multilineTextAlignment(.leading)
                            .disabled(true)
                            .frame(height: 45)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.top, 10)
                    
                    VStack {
                        HStack {
                            Text("문의 내용")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                            Spacer()
                        }
                        
                        TextField("", text: $inquireDetail, axis: .vertical)
                            .padding(.leading)
                            .padding(.top)
                            .padding(.bottom)
                            .multilineTextAlignment(.leading)
                            .disabled(true)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                            )
                    }
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    if (answerDetail != "") {
                        VStack {
                            HStack {
                                Text("답변 내용")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            
                            TextField("", text: $answerDetail, axis: .vertical)
                                .padding(.leading)
                                .padding(.top)
                                .padding(.bottom)
                                .multilineTextAlignment(.leading)
                                .disabled(true)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                                )
                        }
                        .padding(.bottom)
                    }
                } // end of ScrollView
                
            } // 전체 VStack 끝
            .frame(width: UIScreen.main.bounds.width - 30)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                    })
                    
                    
                }
                ToolbarItem(placement: .principal) {
                    Text("문의 상세")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
            } // end of .toolbar
            .navigationBarBackButtonHidden()
        } // end of NavigationView
        .onAppear {
            getInquireDetail()
        }
    } // end of body
        
} // end of View struct

#Preview {
    InquireDetailView(inquiryId: 20)
}

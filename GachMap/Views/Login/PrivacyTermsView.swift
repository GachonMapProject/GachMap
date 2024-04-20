//
//  PrivacyTermsView.swift
//  GachMap
//
//  Created by 원웅주 on 4/18/24.
//

import SwiftUI

struct PrivacyTermsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var longText = 
    """
    1. 개인정보의 수집 목적
    1.1 회사는 서비스 제공을 위해 필요한 최소한의 개인정보만을 수집합니다.
    1.2 회사는 아래와 같은 목적을 위해 개인정보를 수집하고 있습니다.

    - 서비스 제공 및 운영
    - 고객 문의 및 응대
    - 새로운 서비스 개발 및 마케팅 활동
    
    2. 수집하는 개인정보의 항목
    2.1 수집하는 개인정보의 항목은 아래와 같습니다.

    - 성명
    - 연락처 (전화번호, 이메일 주소 등)
    - 주소
    - 결제 정보 (신용카드 정보, 은행 계좌 정보 등)
    
    3. 개인정보의 보유 및 이용 기간
    3.1 회사는 회원 탈퇴 시까지 개인정보를 보유하며, 탈퇴 후 즉시 파기합니다.
    3.2 법령에 따라 일정 기간 동안 개인정보를 보관할 수 있습니다.

    4. 개인정보의 제공 및 공유
    4.1 회사는 고객의 동의 없이 개인정보를 외부에 제공하지 않습니다.
    4.2 외부와의 정보 공유가 필요한 경우, 사전에 고객의 동의를 받습니다.

    5. 개인정보의 파기 절차 및 방법
    5.1 개인정보의 파기 절차는 다음과 같습니다.

    - 수집된 정보의 목적이 달성된 후 즉시 파기
    5.2 파기 방법은 다음과 같습니다.
    - 전자적 방법: 데이터를 완전히 삭제하여 복구할 수 없도록 처리
    
    6. 개인정보 보호 조치
    6.1 회사는 고객의 개인정보를 안전하게 보호하기 위해 최선을 다하며, 다음과 같은 조치를 취하고 있습니다.

    - 개인정보 처리 직원의 교육 및 감독
    - 암호화 통신
    - 해킹 및 바이러스 대응 프로그램 설치 및 운영
    
    7. 개인정보 관리 책임자
    7.1 회사는 개인정보 관리 책임자를 지정하여 고객의 개인정보 보호를 위한 내부 관리 및 외부 감사를 수행합니다.
    7.2 개인정보 관리 책임자 정보는 아래와 같습니다.

    - 성명: 홍길동
    - 연락처: 02-1234-5678
    - 이메일: privacy@example.com
    
    8. 고지 의무
    본 약관은 2024년 4월 17일부터 적용되며, 내용이 변경될 경우 개정안은 본 페이지에 공지하겠습니다.
    """
    
    var body: some View {
        NavigationStack {
            HStack() {
                Text("개인정보 이용 약관")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.leading)
                
                Spacer()
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .background(
                            Circle()
                                .fill(Color.gray)
                                .opacity(0.7)
                                .frame(width: 30, height: 30)
                        )
                })
                .padding(.trailing, 25)
            }
            .padding(.top)

            ScrollView {
                Text(longText)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .padding(.leading)
                    .padding(.trailing)
            }
            
        }
    }
}

#Preview {
    PrivacyTermsView()
}

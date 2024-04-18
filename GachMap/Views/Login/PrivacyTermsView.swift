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
    본 약관은 서비스 이용자(이하 '회원'이라 합니다)가 "회사"가 제공하는 모든 서비스(이하 '서비스'라 합니다)를 이용함에 있어 회사와 회원의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

    1. 약관의 동의
    본 서비스를 이용하는 회원은 본 약관의 내용에 대해 동의하는 것으로 간주됩니다. 서비스 이용 시 본 약관에 동의하지 않는 경우, 서비스 이용이 제한될 수 있습니다.

    2. 서비스의 제공 및 변경
    회사는 회원에게 연중무휴, 24시간 동안 서비스를 제공합니다. 단, 시스템 점검, 장애 발생 등의 사유로 서비스의 일시적인 중단이 발생할 수 있습니다. 이 경우, 회사는 사전에 공지하거나 회원에게 통지합니다.

    3. 회원의 의무
    - 회원은 본 서비스를 이용함에 있어 다른 회원의 정보를 부정하게 이용하거나 서비스를 방해하는 행위를 하여서는 안 됩니다.
    - 회원은 본 서비스를 이용함에 있어 관계법령, 본 약관 및 회사가 정한 규정을 준수해야 합니다.
    
    4. 서비스의 변경 및 중단
    회사는 서비스의 내용을 수시로 변경할 수 있으며, 이에 대한 내용은 회사의 웹사이트나 앱 내에서 공지합니다. 회사는 사전 통지 없이 서비스를 중단할 수 있습니다.

    5. 서비스 이용료
    현재 회사는 본 서비스를 무료로 제공하고 있습니다. 향후 서비스 이용료를 부과할 경우, 부과 조건 및 금액에 대한 사항은 별도로 공지하겠습니다.

    6. 서비스 이용제한 및 계약해지
    회원이 본 약관 및 관련 법령을 위반한 경우, 회사는 회원의 서비스 이용을 일시적으로 정지하거나 계약을 해지할 수 있습니다.

    7. 개인정보 보호
    회사는 회원의 개인정보 보호를 위해 최선을 다하며, 회원의 개인정보 처리에 대한 사항은 회사의 개인정보 처리방침에 따릅니다.

    8. 책임의 한계
    회사는 서비스 이용과 관련하여 발생하는 문제에 대해 어떠한 책임도 부담하지 않습니다.

    본 약관은 2024년 4월 17일부터 시행됩니다.
    """
    
    var body: some View {
        HStack() {
            Text("서비스 이용 약관")
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

#Preview {
    PrivacyTermsView()
}

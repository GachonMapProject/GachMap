//
//  NavigationInfoTestView.swift
//  GachMap
//
//  Created by 이수현 on 4/22/24.
//

import SwiftUI

struct NavigationInfoTestView: View {
    let path = Path().ITtoGachon
    let coreLocation = CoreLocationEx()
    
    var rotationList : [Rotation]{
        CheckRotation().checkRotation(currentLocation: coreLocation.location!, path: path)
    }
    var body: some View {
        HStack{
            ForEach(rotationList){rotation in
                
            }
        }
    }
}

#Preview {
    NavigationInfoTestView()
}

//
//  ARCLViewControllerWrapper.swift
//  GachMap
//
//  Created by 이수현 on 4/21/24.
//

import SwiftUI
import CoreLocation

struct ARCLViewControllerWrapper: UIViewControllerRepresentable {
    
    @ObservedObject var coreLocation : CoreLocationEx
    @ObservedObject var nextNodeObject : NextNodeObject
    var path : [Node]
    var rotationList : [Rotation]
    
    func makeUIViewController(context: Context) -> ARCLViewController {
        return ARCLViewController(path: path, nextNodeObject : nextNodeObject, rotationList : rotationList)
    }
    
    func updateUIViewController(_ uiViewController: ARCLViewController, context: Context) {
        // NextNodeObject.nextIndex가 변경될 때마다 호출 
        uiViewController.addNodes(path: path)
    }
}


//- 다음 노드와의 거리를 지속적으로 확인하려면 coreLocation이 필요함
//    - ARCLViewContainerWrapper까지만 coreLocation을 받고 coreLocation과 다음 노드까지의 거리를 비교해서 5m 이내면, NextNodeObject.increase() 해서 변경시키고 ARCLViewContainer가 변경돼서 다시 로드?
// path[1]부터 거리 확인하고 1씩 증가 -> [0] 제외

//
//  ARCLViewControllerWrapper.swift
//  GachMap
//
//  Created by 이수현 on 4/21/24.
//

import SwiftUI
import CoreLocation

struct ARCLViewControllerWrapper: UIViewControllerRepresentable {
    
//    @ObservedObject var nextNodeObject : NextNodeObject
    @EnvironmentObject var nextNodeObject : NextNodeObject
    var path : [Node]
    var rotationList : [Rotation]
    
    func makeUIViewController(context: Context) -> ARCLViewController {
        return ARCLViewController(path: path, nextNodeObject : nextNodeObject, rotationList : rotationList)
    }
    
    func updateUIViewController(_ uiViewController: ARCLViewController, context: Context) {
        // NextNodeObject.nextIndex가 변경될 때마다 호출 -> scene에 노드를 추가하는 함수를 호출해야 할듯
        if nextNodeObject.nextIndex != 0 {
            uiViewController.addNodes(path: path)
        }
        
        
//        uiViewController.checkNode()
    }
}


//- 다음 노드와의 거리를 지속적으로 확인하려면 coreLocation이 필요함
//    - ARCLViewContainerWrapper까지만 coreLocation을 받고 coreLocation과 다음 노드까지의 거리를 비교해서 5m 이내면, NextNodeObject.increase() 해서 변경시키고 ARCLViewContainer가 변경돼서 다시 로드?
// path[1]부터 거리 확인하고 1씩 증가 -> [0] 제외

// -> 이거 다 ARMainView로 빼고 coreLocation을 아예 안 받아야 할듯
// 여기에 coreLocation 받아서 작업하면 위치 변경될 때마다 ARCLViewContainer가 다시 호출됨

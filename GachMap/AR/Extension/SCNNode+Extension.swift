//
//  SCNNode+Extension.swift
//  GachMap
//
//  Created by 이수현 on 4/21/24.
//

import SceneKit

extension SCNNode {
    func removeFlicker (withRenderingOrder renderingOrder: Int = Int.random(in: 1..<Int.max)) {
        self.renderingOrder = renderingOrder
        if let geom = geometry {
            geom.materials.forEach { $0.readsFromDepthBuffer = false }
        }
    }
}

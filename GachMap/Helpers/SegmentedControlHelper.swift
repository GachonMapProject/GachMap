//
//  SegmentedControlHelper.swift
//  GachMap
//
//  Created by 원웅주 on 4/17/24.
//

import SwiftUI

extension UISegmentedControl {
    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}

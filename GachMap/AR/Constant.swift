//
//  Constant.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/14.
//

import Foundation
import UIKit


struct AlertConstants {
    static let locationServiceErrorMessage = "Enable location service to continue!"
    static let noPathErrorMessage = "No path found"
    static let locationDetailErrorMessage = "Could not fetch location details"
    static let arErrorMessage = "Device does not support ArConfiguration"
    static let insertErrorMessage = "Failed to insert data into database"
    static let fetchErrorMessage = "Failed to fetch data from database"
    static let apiErrorMessage = "Api failed to fetch location detail"
    static let incorrectURLErrorMessage = "Invalid url"
    static let cameraAccessErrorMessage = "Allow camera Access to continue"
    static let responseErrorMessage = "No response"
}


struct UiViewDimension {
    static let yPostion = CGFloat(200)
    static let pathInfoHeight = CGFloat(75)
    static let pathInfoAnimateHeight = CGFloat(300)
    static let locationInfoHeight = CGFloat(225)
    static let locationInfoAnimatedHeight = CGFloat(423)
    static let tableHeight = CGFloat(80)
    static let animatedHeight = CGFloat(250)
}

struct ArkitNodeDimension {
    static let destinationNodeLength = CGFloat(2.0)
    static let destinationNodeWidth = CGFloat(2.0)
    static let destinationNodeHeight = CGFloat(2.0)
    static let destinationChamferRadius = CGFloat(0.5)
    static let sourceNodeLength = CGFloat(3.0)
    static let sourceNodeWidth = CGFloat(3.0)
    static let sourceNodeHeight = CGFloat(3.0)
    static let sourceChamferRadius = CGFloat(0.5)
    static let cylinderRadius = CGFloat(0.5)
    static let nodeYPosition = CGFloat(0.5)
    static let textDepth = CGFloat(0.2)
    static let textSize = CGFloat(1.5)
}

struct TextNodeConstant {
    static let direction = "Direction"
    static let distance = "Distance"
    static let duration = "Duration"
    static let destination = "Destination"
}

struct LocationAccuracy {
    static let accuracy = 10.0
}

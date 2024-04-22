//
//  ARCLTest.swift
//  Location_Example
//
//  Created by 이수현 on 2024/03/09.
//

import Foundation
import UIKit
import ARCL
import CoreLocation
import MapKit
import ARKit


class ARCLViewController: UIViewController, ARSCNViewDelegate {
    var sceneLocationView: SceneLocationView?
    var path : [Node]
    var coreLocation : CoreLocationEx
    var stepData = [Step]()
    var sourcePosition = SCNVector3(x: 0, y: 0, z: 0) // 출발지의 상대적 위치
    
    public var locationEstimateMethod = LocationEstimateMethod.mostRelevantEstimate // 위치 추정 방법
    public var arTrackingType = SceneLocationView.ARTrackingType.worldTracking // AR 추적 타입 (orientation : 방향 추적, world : 평면 추적)
    public var scalingScheme = ScalingScheme.normal // 스케일링 방식
        
    // 노드 위치를 조정하고 크기를 업데이트하는데 필요한 변수
    public var continuallyAdjustNodePositionWhenWithinRange = true
    public var continuallyUpdatePositionAndScale = true
    public var annotationHeightAdjustmentFactor = 1.1
    
    init(path : [Node], coreLocation : CoreLocationEx) {

        self.path = path
        self.coreLocation = coreLocation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    //SceneLocationView() 재구성 함수
    func rebuildSceneLocationView() {
         sceneLocationView?.removeFromSuperview()
        let newSceneLocationView = SceneLocationView.init(trackingType: arTrackingType, frame: view.frame, options: nil)
         newSceneLocationView.translatesAutoresizingMaskIntoConstraints = false
         newSceneLocationView.arViewDelegate = self
         newSceneLocationView.locationEstimateMethod = locationEstimateMethod
         newSceneLocationView.showsStatistics = false       // 통계 표시
         newSceneLocationView.showAxesNode = false // don't need ARCL's axesNode because we're showing SceneKit's
         newSceneLocationView.autoenablesDefaultLighting = true // 입체감 (자동 조명)
         view.addSubview(newSceneLocationView)
         sceneLocationView = newSceneLocationView
     }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCameraAccess()
        // 진북 설정 알림 창 이동 함수 추가해야 함
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rebuildSceneLocationView()  // SceneLocationView() 재구성
        
        // 노드 추가 함수
        addNodes(path : path)
        sceneLocationView?.run()    // SceneLocationView 시작
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         sceneLocationView?.removeAllNodes()
         sceneLocationView?.pause()
         super.viewWillDisappear(animated)
     }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView?.frame = view.bounds
    }
    
    // 노드 기본 설정 (노드가 추가된 후에 각 노드에 대해 수행되는 작업)
    func addScenewideNodeSettings(_ node: LocationNode) {
        if let annoNode = node as? LocationAnnotationNode {
            annoNode.annotationHeightAdjustmentFactor = annotationHeightAdjustmentFactor // 노드 높이 조절
        }
        node.scalingScheme = scalingScheme      //노드의 크기 조절 방식을 결정
        
        // 노드가 범위 내에 있을 때 노드의 위치를 지속적으로 조정하도록 설정하고, 위치와 크기를 계속해서 업데이트하도록 설정합니다.
        node.continuallyAdjustNodePositionWhenWithinRange = continuallyAdjustNodePositionWhenWithinRange
        node.continuallyUpdatePositionAndScale = continuallyUpdatePositionAndScale
    }
    
    // 노드 추가 함수
    func addNodes(path : [Node]){
        var path = path
        sceneLocationView?.removeAllNodes()
        
        // 현재 위치 가져오기
        guard let currentLocation = sceneLocationView?.sceneLocationManager.currentLocation else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addNodes(path: path)
            }
            return
        }
        
        let altitude = currentLocation.altitude                 // ARCL에서 측정한 고도
        let difAltitude = altitude - path[0].location.altitude // 0이 아니라 다음 인덱스로 수정
        print("difAltitude : \(difAltitude), altitude : \(altitude)")
        
        for i in 0..<path.count {
            let originalAltitude = path[i].location.altitude // 현재 노드의 고도
            let updatedAltitude = originalAltitude + difAltitude // 현재 위치 고도와의 차이를 더함
            path[i].location = CLLocation(coordinate: path[i].location.coordinate, altitude: updatedAltitude) // 노드의 고도 수정
        }
        getIntermediateCoordinates(path: path)
        
        placeStartNode(currentLocation : currentLocation)   // 출발지 노드
        
//         경로 노드마다 띄울 텍스트 설정
        for i in 0..<stepData.count - 1 {
            let nodeName = "node-\(stepData[i].locationName)"
            placeMiddleNode(currentLocation: currentLocation, start : stepData[i].startLocation, end: stepData[i].endLocation, next : stepData[i].nextLocation, nodeName: nodeName)
        }
        placeDestinationNode(currentLocation : currentLocation) // 목적지 노드
        
//
//        for i in 0..<path.count{
//            let originalAltitude = path[i].location.altitude        // 다음 노드의 고도
//            let updatedAltitude = originalAltitude + difAltitude    // 현재위치, 노드 고도 차
//            let newLocation = CLLocation(coordinate: path[i].location.coordinate, altitude: updatedAltitude)    // 노드의 고도 수정 (현재 위치와 동일하게)
//            
//            let sourceNode = makePngNode(fileName: "MuhanStart")
//            let muhanNode = LocationAnnotationNode(location: newLocation, node: sourceNode)
//            if sceneLocationView != nil {
//                print("muhanNode 추가 : \(newLocation.altitude)")
//            }
////            muhanNode.constraints = nil  방향 제어 해제 
//            addScenewideNodeSettings(muhanNode)
//            sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: muhanNode)
//        }
        
        
        
//        let box = SCNBox(width: 1, height: 0.5, length: 15, chamferRadius: 0)
//        
//        box.firstMaterial?.diffuse.contents = UIColor.blue
//        box.firstMaterial?.transparency = 0.9 // 투명도 (0.0(완전 투명)에서 1.0(완전 불투명))
//        let node = SCNNode(geometry: box)
//        let location = CLLocation(latitude: (path[0].location.coordinate.latitude + path[1].location.coordinate.latitude) / 2, longitude: (path[0].location.coordinate.longitude + path[1].location.coordinate.longitude) / 2)
//        let placeNode = LocationAnnotationNode(location: location, node: node)
//        addScenewideNodeSettings(placeNode)
//        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: placeNode)
//        
        
        
        
        
        // Copy the current location because it's a reference type. Necessary?
//       let referenceLocation = CLLocation(coordinate: currentLocation.coordinate,
//                                          altitude: currentLocation.altitude)   // 고도 수정 가능
//       let startingPoint = CLLocation(coordinate: referenceLocation.coordinate, altitude: referenceLocation.altitude)
//
//        let originNode = LocationNode(location: startingPoint)
//        let pyramid: SCNPyramid = SCNPyramid(width: 2.0, height: 2.0, length: 2.0)
//        pyramid.firstMaterial?.diffuse.contents = UIColor.systemPink
//        let pyramidNode = SCNNode(geometry: pyramid)
//        originNode.addChildNode(pyramidNode)
//        addScenewideNodeSettings(originNode)
//        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: originNode)
//        print("originNode 추가")
    }
    
    
    
    private func placeStartNode(currentLocation : CLLocation){

        let startLocation = stepData[0].startLocation
        print(startLocation.altitude)
        
        let sourceNode = makePngNode(fileName: "MuhanStart")
        let startNode = LocationAnnotationNode(location: startLocation, node: sourceNode)

        let distance = distanceBetweenCoordinate(source: currentLocation, destination: startLocation)
        let transformMatrix = transformMatrix(source: currentLocation, destination: startLocation, distance: distance)
        let node = SCNNode()
        node.transform = transformMatrix
        sourcePosition = node.position  // startNode의 상대적 위치

        addScenewideNodeSettings(startNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: startNode)
        
    } // end of placeStartNode
    
//    목적지 노드를 AR 환경에 배치
    private func placeMiddleNode(currentLocation: CLLocation, start :CLLocation, end: CLLocation, next : CLLocation, nodeName: String) {
    
        // 다음 노드 상대 좌표
        let nextDistance = distanceBetweenCoordinate(source: currentLocation, destination: next)
        let nextTransformationMatrix = transformMatrix(source: currentLocation, destination: next, distance: nextDistance)
        let nextNode = SCNNode()
        nextNode.transform = nextTransformationMatrix
        
        // 현재 노드 상대좌표
        let distance = distanceBetweenCoordinate(source: currentLocation, destination: end)
        let transformationMatrix = transformMatrix(source: currentLocation, destination: end, distance: distance)
        let endNode = SCNNode()
        endNode.transform = transformationMatrix
    
        
        // 1번 노드에서 2번 노드로 향하는 방향 벡터
        let sourceToEndVector = simd_float2(endNode.position.x - sourcePosition.x,
                                               endNode.position.z - sourcePosition.z)

        // 1번 노드에서 3번 노드로 향하는 방향 벡터
        let sourceToNextVector = simd_float2(nextNode.position.x - sourcePosition.x,
                                             nextNode.position.z - sourcePosition.z)
        let angleInDegrees = sourceToEndVector.x * sourceToNextVector.y - sourceToEndVector.y * sourceToNextVector.x
        print("angleInDegrees : \(angleInDegrees)")

        
        let fileName = angleInDegrees < -300 ? "MuhanPointLeft" : angleInDegrees > 300 ? "MuhanPointRight" : "MuhanMiddle"
        
       
        let sourceNode = makePngNode(fileName: fileName)
        let middleNode = LocationAnnotationNode(location: end, node: sourceNode)

        let coordinate = CLLocationCoordinate2D(latitude: (start.coordinate.latitude + end.coordinate.latitude) / 2, longitude: (start.coordinate.longitude + end.coordinate.longitude) / 2)
        
        let placeBoxLocation = CLLocation(coordinate: coordinate, altitude: (start.altitude + end.altitude) / 2 - 1.5)

        let box = placeBox(source: start, destination: end)
        let boxNode = LocationAnnotationNode(location: placeBoxLocation, node: box)
    
        
        sourcePosition = endNode.position
        boxNode.constraints = nil
        
        addScenewideNodeSettings(middleNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: middleNode)
        addScenewideNodeSettings(boxNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: boxNode)
        
        
    } // end of placeDestinationNode()
    
//    출발지와 목적지 사이에 실린더 노드 배치하는 역할
   private func placeBox(source: CLLocation, destination: CLLocation) -> SCNNode{
       let length = distanceBetweenCoordinate(source: source, destination: destination)
       
       // 출발지와 목적지 간의 고도 차이 계산
        let altitudeDifference = Double(destination.altitude - source.altitude)
       
       let box = SCNBox(width: 1, height: 0.2, length: CGFloat(length), chamferRadius: 0)
       
       box.firstMaterial?.diffuse.contents = UIColor.gachonSky
       box.firstMaterial?.transparency = 0.9 // 투명도 (0.0(완전 투명)에서 1.0(완전 불투명))
       let node = SCNNode(geometry: box)

       // 실린더 노드의 위치를 출발지와 목적지 중간으로 배치
//       node.position = SCNVector3((source.x + destination.x) / 2, (source.y + destination.y) / 2 - 1.5, (source.z + destination.z) / 2)

       // 빗변
       let hypotenuse = sqrt(pow(length, 2) + pow(altitudeDifference, 2))
       
       // 실릴더 기울기
       let angle = acos(length / hypotenuse)
//       node.eulerAngles.x = .pi / 2 + angle
       node.eulerAngles.x = Float(angle)
       
       
       // 출발지와 목적지 사이의 회전 각도 계산
          let dirVector = SCNVector3(destination.coordinate.longitude - source.coordinate.longitude,
                                     destination.altitude - source.altitude,
                                      destination.coordinate.latitude - source.coordinate.latitude)
       let yAngle = atan(dirVector.x / dirVector.z) + 0.07
       print(yAngle)
       
       // CLLocation 사용 시 yAngle
//       -1.2743467
//       -1.324047
//       0.40206537
//       -1.281677
       
       // SCNVector3 사용 시 yAngle
//       1.2034351
//       1.263546
//       -0.3286845
//       1.2121987
       
       node.eulerAngles.y = -yAngle

       
       return node
   } // end of placeCylinder
    
    private func placeDestinationNode(currentLocation : CLLocation){
        guard let last = stepData.last else {return}
        let startLocation = last.startLocation
        let destinationLocation = last.endLocation
        let sourceNode = makePngNode(fileName: "MuhanEnd")
        let destinationNode = LocationAnnotationNode(location: destinationLocation, node: sourceNode)
        
        
        let coordinate = CLLocationCoordinate2D(latitude: (startLocation.coordinate.latitude + destinationLocation.coordinate.latitude) / 2, longitude: (startLocation.coordinate.longitude + destinationLocation.coordinate.longitude) / 2)
        
        let placeBoxLocation = CLLocation(coordinate: coordinate, altitude: (startLocation.altitude + destinationLocation.altitude) / 2 - 1.5)

        let box = placeBox(source: startLocation, destination: destinationLocation)
        let boxNode = LocationAnnotationNode(location: placeBoxLocation, node: box)
        
        boxNode.constraints = nil
        
        addScenewideNodeSettings(destinationNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: destinationNode)
        addScenewideNodeSettings(boxNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: boxNode)
    }
    
    
    
    // 두 좌표 간 거리 계산
    private func distanceBetweenCoordinate(source: CLLocation, destination: CLLocation) -> Double {
            return source.distance(from: destination)
    } // end of distanceBetweenCoordinate()
    
    
    // 출발지와 목적지 사이의 변환 행렬 계산 후 노드 위치 방향 설정
    private func transformMatrix(source: CLLocation, destination: CLLocation, distance: Double) -> SCNMatrix4 {
        
        // 시작 노드와 도착 노드의 고도 차이를 계산
        let altitudeDifference = source.altitude - destination.altitude
        let translation = SCNMatrix4MakeTranslation(0, Float(-altitudeDifference), Float(-distance)) // 이동행렬
        
        // SCNMatrix4MakeRotation(회전량, x, y, z)
        // y축 기준으로 베어링 각도 만큼 회전 -> 베어링은 시계 방향 기준, rotation은 반시계 기준이라 음수를 붙임 , 회전각에 시작위치-첫번째 노드의 회전을 더함
        let rotation = SCNMatrix4MakeRotation(-1 * (Float(source.coordinate.calculateBearing(coordinate: destination.coordinate))), 0, 1, 0)
        
        let transformationMatrix = SCNMatrix4Mult(translation, rotation)
        return transformationMatrix
    }   // end of tansformMatrix
    
    
    
    
    // png 파일 노드 생성
    private func makePngNode(fileName : String) -> SCNNode {
        let file = fileName
        guard let image = UIImage(named: file) else {
            fatalError("Failed to load image \(file).png")
        }
//        image.size.width : 1400.0, heigth : 1400.0
        let plane = SCNPlane(width: image.size.width / 500 , height: image.size.height / 500)

        plane.firstMaterial?.diffuse.contents = image
        let node = SCNNode(geometry: plane)

        return node
    }
    
    
    // 카메라 엑세스 확인 메서드
    private func checkCameraAccess() {
        
        // 현재 앱이 카메라 엑세스 허용했으면 getIntermediateCordinates() 호출하여 중간 좌표를 가져옴
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            getIntermediateCoordinates(path: self.path)
            
        // 카메라 엑세스를 허용하지 않았으면 사용자에게 권한 요청
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                // 권한 허용
                if granted {
                    self.getIntermediateCoordinates(path: self.path)
                // 권한 거부
                } else {
//                        self.alert("Allow camera Access to continue")
                    print("checkCameraAccess : 권한 거부")
                }
            })
        }
    } // end of checkCameraAccess()
    
    
    // 중간 노드들의 정보를 계산하고 가져오는 메서드
    private func getIntermediateCoordinates(path: [Node]) {
        // 중간 노드(Steps)를 받아옴 -> CLLocationCoordinate2D 형식으로 보내서 [Step] 형식으로 변환해야 함
        let steps = GetIntermediateCoordinate.getCoordinates(path : path)
        stepData = steps
          
    } // end of getIntermediateCordinates()
}

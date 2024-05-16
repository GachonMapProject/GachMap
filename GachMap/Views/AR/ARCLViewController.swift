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
    var stepData = [Step]()
    var nextNodeObject : NextNodeObject
    var rotationList : [Rotation]
    var xAngle : Float = 0.0
    var yAngle : Float = 0.0
//    var nodeNames : [Int : [String]] = [:]
    
    public var locationEstimateMethod = LocationEstimateMethod.mostRelevantEstimate // 위치 추정 방법
    public var arTrackingType = SceneLocationView.ARTrackingType.worldTracking // AR 추적 타입 (orientation : 방향 추적, world : 평면 추적)
    public var scalingScheme = ScalingScheme.normal // 스케일링 방식
        
    // 노드 위치를 조정하고 크기를 업데이트하는데 필요한 변수
    public var continuallyAdjustNodePositionWhenWithinRange = false
    public var continuallyUpdatePositionAndScale = false
    public var annotationHeightAdjustmentFactor = 1.1
    
    var difAltitude = 0.0
    
    init(path : [Node], nextNodeObject : NextNodeObject, rotationList : [Rotation]) {
        self.path = path
        self.nextNodeObject = nextNodeObject
        self.rotationList = rotationList
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
        checkCameraAccess()         // 카메라 허용 확인
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rebuildSceneLocationView()  // SceneLocationView() 재구성
        
        // 노드 추가 함수
        DispatchQueue.main.async {
            self.addNodes(path : self.path)
            self.sceneLocationView?.run()    // SceneLocationView 시작
        }

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
        let index = nextNodeObject.nextIndex == 0 ? 0 : nextNodeObject.nextIndex - 1 // 현재 인덱스
        
        let altitude = currentLocation.altitude                 // ARCL에서 측정한 고도
        let difAltitude = altitude - path[index].location.altitude // 현재 인덱스와 고도를 맞춤
        self.difAltitude = difAltitude
        print("difAltitude : \(difAltitude), altitude : \(altitude)")
        
        
        // 0이 아닌 다음 인덱스부터로 수정 필요!!
        for i in 0..<path.count {
            let originalAltitude = path[i].location.altitude // 현재 노드의 고도
            let updatedAltitude = originalAltitude + difAltitude // 현재 위치 고도와의 차이를 더함
            path[i].location = CLLocation(coordinate: path[i].location.coordinate, altitude: updatedAltitude) // 노드의 고도 수정
        }
        
        getIntermediateCoordinates(path: path)  // Step 형식으로 변환
        
        // 인덱스가 0이면 출발지 노드 생성
        if index == 0 {
            placeStartNode(currentLocation : currentLocation)   // 출발지 노드
        }
        
//         경로 노드마다 띄울 텍스트 설정 (여기도 0부터 시작이 아닌 인덱스 번호부터 시작하도록)
        for i in 0..<stepData.count - 1 {
//            let nodeName = "node-\(stepData[i].locationName)"
            print(stepData[i])
            let start = stepData[i].startLocation
            let end = stepData[i].endLocation
            let next = stepData[i].nextLocation
            if stepData[i].locationName != "0" && start.altitude != difAltitude && end.altitude != difAltitude && next.altitude != difAltitude{
                print("locationName : \(stepData[i].locationName)")
                placeMiddleNode(currentLocation: currentLocation, start : start, end: end, next : next, nodeName: stepData[i].locationName, index : i)
            }
        
        }
        placeDestinationNode(currentLocation : currentLocation) // 목적지 노드
        
    } // end of addNodes()
    
    
    
    private func placeStartNode(currentLocation : CLLocation){
        
        let startLocation = stepData[0].startLocation
        print("startLocation.altitude : \(startLocation.altitude)")
        
        let sourceNode = makePngNode(fileName: "MuhanStart")
        let startNode = LocationAnnotationNode(location: startLocation, node: sourceNode)
        startNode.name = "0-0"
        
        let pinLocation = CLLocation(coordinate: startLocation.coordinate, altitude: startLocation.altitude + 2.5)
        let pinNode = makeUsdzNode(fileName: "Pin", scale : 0.005, middle: false)
        let placePinNode = LocationAnnotationNode(location: pinLocation, node: pinNode)
        placePinNode.constraints = nil
        placePinNode.name = "0-1"
        
        addScenewideNodeSettings(placePinNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: placePinNode)
        
        
        addScenewideNodeSettings(startNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: startNode)
        nextNodeObject.nodeNames[0] = [startNode.name ?? "", placePinNode.name ?? ""]
        
    } // end of placeStartNode
    
//    목적지 노드를 AR 환경에 배치
    private func placeMiddleNode(currentLocation: CLLocation, start :CLLocation, end: CLLocation, next : CLLocation, nodeName: String, index : Int) {

        // CheckRotation을 통해 rotationList를 받아와서 회전 방향 설정하면 될듯?
        let fileName = rotationList[index].rotation == "우회전" ? "MuhanPointRight" : rotationList[index].rotation == "좌회전" ? "MuhanPointLeft" : "MuhanMiddle"

        
        print("middleNode - rotation : \(rotationList[index])")
    
        let sourceNode = makePngNode(fileName: fileName)
        let middleNode = LocationAnnotationNode(location: end, node: sourceNode)

        let coordinate = CLLocationCoordinate2D(latitude: (start.coordinate.latitude + end.coordinate.latitude) / 2, longitude: (start.coordinate.longitude + end.coordinate.longitude) / 2)
        
        let placeBoxLocation = CLLocation(coordinate: coordinate, altitude: (start.altitude + end.altitude) / 2 - 1.5)

        let box = placeBox(currentLocation : currentLocation, start: start, end: end)
        let boxNode = LocationAnnotationNode(location: placeBoxLocation, node: box)
        boxNode.constraints = nil
        
        
        let naviLocation = CLLocation(coordinate: end.coordinate, altitude: end.altitude + 3)
        let navi = ARNaviInfoNode(view: ARNaviInfoView(distance: Int(rotationList[index].distance), rotation: rotationList[index].rotation))
        let naviNode = LocationAnnotationNode(location: naviLocation, node: navi)
        
        let midPoints = calculateMidPoints(start: start, end: end, numberOfDivisions: 5)
    
        middleNode.name = "\(index)-0"
        boxNode.name = "\(index)-1"
        naviNode.name = "\(index)-2"
        
        var names : [String] = [middleNode.name ?? "", boxNode.name ?? "", naviNode.name ?? ""]
        

        addScenewideNodeSettings(middleNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: middleNode)
        addScenewideNodeSettings(boxNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: boxNode)
        addScenewideNodeSettings(naviNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: naviNode)
        

        
        // boxNode 위에 화살표 노드 생성
        for point in midPoints {
//            let arrow = placeArrow(xAngle: self.xAngle, yAngle: self.yAngle)
            let arrow = makeUsdzNode(fileName: "middleArrow", scale : 0.003, middle: true)
            let placeArrowLocation = CLLocation(coordinate: point.coordinate, altitude: point.altitude - 1.39)
            let arrowNode = LocationAnnotationNode(location: placeArrowLocation, node: arrow)
            arrowNode.constraints = nil
            arrowNode.name = ("\(index)-\(point.coordinate.latitude)")
            names.append("\(index)-\(point.coordinate.latitude)")
            addScenewideNodeSettings(arrowNode)
            sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: arrowNode)
            
        }
        nextNodeObject.nodeNames[index+1] = names
       

    } // end of placeDestinationNode()
    
    private func calculateMidPoints(start: CLLocation, end: CLLocation, numberOfDivisions: Int) -> [CLLocation] {
        // 시작점과 끝점의 좌표
        let startCoordinate = start.coordinate
        let endCoordinate = end.coordinate
        
        // 각 좌표의 위도 및 경도 변화량 계산
        let latitudeDelta = (endCoordinate.latitude - startCoordinate.latitude) / Double(numberOfDivisions)
        let longitudeDelta = (endCoordinate.longitude - startCoordinate.longitude) / Double(numberOfDivisions)
        let altitudeDelta = (end.altitude - start.altitude) / Double(numberOfDivisions)
        
        // 중간 지점들의 CLLocation 배열 초기화
        var midPoints: [CLLocation] = []
        
        // 시작점에서부터 각 등분 지점의 좌표를 계산하고 CLLocation 객체를 배열에 추가
        for i in 1..<numberOfDivisions {
            let latitude = startCoordinate.latitude + (latitudeDelta * Double(i))
            let longitude = startCoordinate.longitude + (longitudeDelta * Double(i))
            let altitude = start.altitude + (altitudeDelta * Double(i))
            let midCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let midPoint = CLLocation(coordinate: midCoordinate, altitude: altitude)
            midPoints.append(midPoint)
        }
        
        return midPoints
    }
    
    
    func makeSCNVector(currnetLocation : CLLocation, location : CLLocation) -> SCNVector3{
        let distance = currnetLocation.distance(from: location)
        let transformationMatrix = transformMatrix(source: currnetLocation, destination: location, distance: distance)
        let node = SCNNode()
        node.transform = transformationMatrix
        return node.position
    }
    
//    func placeArrow(xAngle: Float, yAngle: Float) -> SCNNode {
//        print("placeArrow - xAngle :\(xAngle), yAngle: \(yAngle)")
//        let textName = "⋀"
//        
//        // 텍스트 생성
//        let text = SCNText(string: textName, extrusionDepth: 0.02)
//        text.font = UIFont.systemFont(ofSize: 3) // 폰트 크기 및 두께 설정
//        
//        // 텍스트 머티리얼 설정 (흰색으로 변경)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.white
//        text.firstMaterial = material
//        
//        // SCNNode 생성 및 텍스트 노드 추가
//        let textNode = SCNNode(geometry: text)
//        textNode.eulerAngles.x = .pi / 2 + xAngle
//        textNode.eulerAngles.y = yAngle
//        
//        return textNode
//    }


    
//    출발지와 목적지 사이에 실린더 노드 배치하는 역할
    private func placeBox(currentLocation : CLLocation, start: CLLocation, end: CLLocation) -> SCNNode{
        let startVector = makeSCNVector(currnetLocation: currentLocation, location: start)  // 현재 노드 상대 좌표
        let endVector = makeSCNVector(currnetLocation: currentLocation, location: end)      // 다음 노드 상대 좌표
        
        let length = startVector.distance(receiver: endVector)
        
       // 출발지와 목적지 간의 고도 차이 계산
        let altitudeDifference = Float(start.altitude - end.altitude)
        
//        빗변 (hypotenuse)는 평면 거리 (length)와 고도 차이 (altitudeDifference)의 제곱합의 제곱근
        let hypotenuse = sqrt(pow(length, 2) + pow(altitudeDifference, 2))
       
       
        let box = SCNBox(width: 2, height: 0.1, length: CGFloat(hypotenuse), chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        box.firstMaterial?.transparency = 0.9 // 투명도 (0.0(완전 투명)에서 1.0(완전 불투명))
        let node = SCNNode(geometry: box)

        
        /* 필요한 수학 공식:
        고도 차이와 거리 간의 각도 (xAngle): atan2(고도 차이, 거리)
        두 위치 간의 방향 각도 (yAngle): atan2(두 지점 간의 x 좌표 차이, 두 지점 간의 z 좌표 차이)
        
         */
//        let hypotenuse = sqrt(pow(length, 2) + pow(altitudeDifference, 2))
//
//        // 실릴더 기울기
//        let angle = atan2(altitudeDifference, length)
//        node.eulerAngles.x = Float(-angle)
//        xAngle = -angle


        // 실린더 기울기 (라디안)
        let angle = -atan(altitudeDifference / length)
        node.eulerAngles.x = Float(angle)
        xAngle = angle


        let dirVector = SCNVector3Make(endVector.x - startVector.x, endVector.y - startVector.y, endVector.z - startVector.z)
        let yAngle = atan(dirVector.x / dirVector.z)
        print("placeBox - yAngle : \(yAngle)")
        self.yAngle = yAngle
       
       node.eulerAngles.y = yAngle

       return node
   } // end of placeBox
    
    private func placeDestinationNode(currentLocation : CLLocation){
        guard let last = stepData.last else {return}
        let startLocation = last.startLocation
        let destinationLocation = last.endLocation
        let sourceNode = makePngNode(fileName: "MuhanEnd")
        let destinationNode = LocationAnnotationNode(location: destinationLocation, node: sourceNode)
        
        let coordinate = CLLocationCoordinate2D(latitude: (startLocation.coordinate.latitude + destinationLocation.coordinate.latitude) / 2, longitude: (startLocation.coordinate.longitude + destinationLocation.coordinate.longitude) / 2)
        
        let placeBoxLocation = CLLocation(coordinate: coordinate, altitude: (startLocation.altitude + destinationLocation.altitude) / 2 - 1.5)

        let box = placeBox(currentLocation : currentLocation, start: startLocation, end: destinationLocation)
        let boxNode = LocationAnnotationNode(location: placeBoxLocation, node: box)
        
        boxNode.constraints = nil
        
        boxNode.name = "lastBoxNode"
        destinationNode.name = "last"
        
        let pinLocation = CLLocation(coordinate: destinationLocation.coordinate, altitude: destinationLocation.altitude + 2.5)
        let pinNode = makeUsdzNode(fileName: "Pin", scale : 0.005, middle: false)
        let placePinNode = LocationAnnotationNode(location: pinLocation, node: pinNode)
        placePinNode.constraints = nil
        placePinNode.name = "lastPinNode"
        
        let midPoints = calculateMidPoints(start: startLocation, end: destinationLocation, numberOfDivisions: 5)
        var names : [String] = [destinationNode.name ?? "", boxNode.name ?? "", placePinNode.name ?? ""]
        
        // boxNode 위에 화살표 노드 생성
        for point in midPoints {
//            let arrow = placeArrow(xAngle: self.xAngle, yAngle: self.yAngle)
            let arrow = makeUsdzNode(fileName: "middleArrow", scale : 0.003, middle: true)
            let placeArrowLocation = CLLocation(coordinate: point.coordinate, altitude: point.altitude - 1.39)
            let arrowNode = LocationAnnotationNode(location: placeArrowLocation, node: arrow)
            arrowNode.constraints = nil
            arrowNode.name = ("last-\(point.coordinate.latitude)")
            names.append("last-\(point.coordinate.latitude)")
            addScenewideNodeSettings(arrowNode)
            sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: arrowNode)
            
        }
        
        
        addScenewideNodeSettings(placePinNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: placePinNode)
        addScenewideNodeSettings(destinationNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: destinationNode)
        addScenewideNodeSettings(boxNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: boxNode)
        
        nextNodeObject.nodeNames[path.count - 1] = names
    }
    
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
    } // end of tansformMatrix
    
    
    // usdz 파일 노드 생성
    private func makeUsdzNode(fileName : String, scale : Double, middle : Bool) -> SCNNode {
        let file = fileName
        guard let fileUrl = Bundle.main.url(forResource: file, withExtension: "usdz") else {
            fatalError()
        }
        let scene = try? SCNScene(url: fileUrl, options: nil)
        let node = SCNNode()
        
        if let scene = scene {
            for child in scene.rootNode.childNodes {
                child.scale = SCNVector3(scale, scale, scale)
                if middle {
                    child.eulerAngles.x = xAngle
                    child.eulerAngles.y = yAngle
                }
                else{
                    let rotateForeverAction = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0, 1, 0), duration: 1))
                    child.runAction(rotateForeverAction)
                    // 노드의 현재 위치를 저장합니다.
                    let currentPosition = child.position

                    // 점프하는 높이를 설정합니다.
                    let jumpHeight: CGFloat = 0.5

                    // 위로 점프하는 액션
                    let jumpUpAction = SCNAction.moveBy(x: 0, y: jumpHeight, z: 0, duration: 0.5)
                    jumpUpAction.timingMode = .easeInEaseOut

                    // 아래로 떨어지는 액션
                    let jumpDownAction = SCNAction.moveBy(x: 0, y: -jumpHeight, z: 0, duration: 0.5)
                    jumpDownAction.timingMode = .easeInEaseOut

                    // 점프를 반복하는 시퀀스 생성
                    let jumpSequence = SCNAction.sequence([jumpUpAction, jumpDownAction])

                    // 노드에 점프 액션 반복 실행
                    let jumpForeverAction = SCNAction.repeatForever(jumpSequence)
                    child.runAction(jumpForeverAction)
                }

                node.addChildNode(child)
            }
        }
        
        return node
    }
    
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
    
    
    // 카메라 엑세스 확인 메서드 (권한 거부 시 띄울 알림 추가해야 함)
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
    
    
    // 중간 노드들의 정보(출발 위치, 도착 위치, 다음 위치)를 계산하고 가져오는 메서드
    private func getIntermediateCoordinates(path: [Node]) {
        // 중간 노드(Steps)를 받아옴 -> CLLocationCoordinate2D 형식으로 보내서 [Step] 형식으로 변환해야 함
        let steps = GetIntermediateCoordinate.getCoordinates(path : path)
        stepData = steps
          
    } // end of getIntermediateCordinates()
    
    
    
    func ARNaviInfoNode(view : ARNaviInfoView) -> SCNNode {
        let node = SCNNode()
        let image = view.asImage()
        let material = SCNMaterial()
        material.diffuse.contents = image
        let plane = SCNPlane(width: image.size.width / 50, height: image.size.height / 50)
        plane.materials = [material]
        node.geometry = plane
        return node
    }
    
    // 이전, 현재, 다음 노드와 일정 거리 이내 노드만 화면에 표시
    func checkNode(){
        let index = nextNodeObject.nextIndex
        
//         모든 노드 숨김처리
        for value in nextNodeObject.nodeNames.values{
            value.map{name in
                sceneLocationView?.scene.rootNode.enumerateChildNodes { (node, _) in
                    if node.name == name{
                        print("hiddend - " + (node.name ?? ""))
                        node.isHidden = true
                    }
                }
            }
        }

        // 현재 위치 가져오기
        guard let currentLocation = sceneLocationView?.sceneLocationManager.currentLocation else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.checkNode()
            }
            return
        }
        nextNodeObject.nodeNames[index]?.map{ names in
            print("index-\(names)")
            sceneLocationView?.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == names {
                    print("index - find")
                    node.isHidden = false
                }
            }
        }
        
        nextNodeObject.nodeNames[index - 1]?.map{ names in
            print("index - 1 -\(names)")
            sceneLocationView?.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == names {
                    print("index-1 - find")
                    node.isHidden = false
                }
            }
        }
        nextNodeObject.nodeNames[index + 1]?.map{ names in
            print("index + 1 -\(names)")
            sceneLocationView?.scene.rootNode.enumerateChildNodes { (node, _) in
                if node.name == names {
                    node.isHidden = false
                }
            }
        }
    }
}

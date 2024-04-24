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
    
    public var locationEstimateMethod = LocationEstimateMethod.mostRelevantEstimate // 위치 추정 방법
    public var arTrackingType = SceneLocationView.ARTrackingType.worldTracking // AR 추적 타입 (orientation : 방향 추적, world : 평면 추적)
    public var scalingScheme = ScalingScheme.normal // 스케일링 방식
        
    // 노드 위치를 조정하고 크기를 업데이트하는데 필요한 변수
    public var continuallyAdjustNodePositionWhenWithinRange = true
    public var continuallyUpdatePositionAndScale = true
    public var annotationHeightAdjustmentFactor = 1.1
    
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
        let index = nextNodeObject.nextIndex // 현재 인덱스
        
        let altitude = currentLocation.altitude                 // ARCL에서 측정한 고도
        let difAltitude = altitude - path[index].location.altitude // 현재 인덱스와 고도를 맞춤
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
        for i in index..<stepData.count - 1 {
            let nodeName = "node-\(stepData[i].locationName)"
            placeMiddleNode(currentLocation: currentLocation, start : stepData[i].startLocation, end: stepData[i].endLocation, next : stepData[i].nextLocation, nodeName: nodeName, index : i)
        }
        placeDestinationNode(currentLocation : currentLocation) // 목적지 노드
    } // end of addNodes()
    
    
    
    private func placeStartNode(currentLocation : CLLocation){

        let startLocation = stepData[0].startLocation
        print("startLocation.altitude : \(startLocation.altitude)")
        
        let sourceNode = makePngNode(fileName: "MuhanStart")
        let startNode = LocationAnnotationNode(location: startLocation, node: sourceNode)

        addScenewideNodeSettings(startNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: startNode)
        
    } // end of placeStartNode
    
//    목적지 노드를 AR 환경에 배치
    private func placeMiddleNode(currentLocation: CLLocation, start :CLLocation, end: CLLocation, next : CLLocation, nodeName: String, index : Int) {
    
        // CheckRotation을 통해 rotationList를 받아와서 회전 방향 설정하면 될듯?
        let fileName = rotationList[index].rotation == "우회전" ? "MuhanPointRight" : rotationList[index].rotation == "좌회전" ? "MuhanPointLeft" : "MuhanMiddle"
//        MuhanPointLeft,MuhanMiddle
        
        print("middleNode - rotation : \(rotationList[index])")
    
        let sourceNode = makePngNode(fileName: fileName)
        let middleNode = LocationAnnotationNode(location: end, node: sourceNode)

        let coordinate = CLLocationCoordinate2D(latitude: (start.coordinate.latitude + end.coordinate.latitude) / 2, longitude: (start.coordinate.longitude + end.coordinate.longitude) / 2)
        
        let placeBoxLocation = CLLocation(coordinate: coordinate, altitude: (start.altitude + end.altitude) / 2 - 1.5)

        let box = placeBox(start: start, end: end)
        let boxNode = LocationAnnotationNode(location: placeBoxLocation, node: box)
        boxNode.constraints = nil
        
        addScenewideNodeSettings(middleNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: middleNode)
        addScenewideNodeSettings(boxNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: boxNode)
        
        
    } // end of placeDestinationNode()
    
//    출발지와 목적지 사이에 실린더 노드 배치하는 역할
   private func placeBox(start: CLLocation, end: CLLocation) -> SCNNode{
        let length = start.distance(from: end)   // 두 지점 사이의 거리
       
       // 출발지와 목적지 간의 고도 차이 계산
        let altitudeDifference = Double(end.altitude - start.altitude)
       
        let box = SCNBox(width: 1.5, height: 0.1, length: CGFloat(length), chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.gachonSky
        box.firstMaterial?.transparency = 0.9 // 투명도 (0.0(완전 투명)에서 1.0(완전 불투명))
        let node = SCNNode(geometry: box)

        // 빗변
        let hypotenuse = sqrt(pow(length, 2) + pow(altitudeDifference, 2))

        // 실릴더 기울기
        let angle = acos(length / hypotenuse)
        node.eulerAngles.x = Float(angle)


        // 출발지와 목적지 사이의 회전 각도 계산
        let dirVector = SCNVector3(end.coordinate.longitude - start.coordinate.longitude,
                                     end.altitude - start.altitude,
                                     end.coordinate.latitude - start.coordinate.latitude)
        let yAngle = atan(dirVector.x / dirVector.z) + 0.07
        print("placeBox - yAngle : \(yAngle)")
       
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
   } // end of placeBox
    
    private func placeDestinationNode(currentLocation : CLLocation){
        guard let last = stepData.last else {return}
        let startLocation = last.startLocation
        let destinationLocation = last.endLocation
        let sourceNode = makePngNode(fileName: "MuhanEnd")
        let destinationNode = LocationAnnotationNode(location: destinationLocation, node: sourceNode)
        
        let coordinate = CLLocationCoordinate2D(latitude: (startLocation.coordinate.latitude + destinationLocation.coordinate.latitude) / 2, longitude: (startLocation.coordinate.longitude + destinationLocation.coordinate.longitude) / 2)
        
        let placeBoxLocation = CLLocation(coordinate: coordinate, altitude: (startLocation.altitude + destinationLocation.altitude) / 2 - 1.5)

        let box = placeBox(start: startLocation, end: destinationLocation)
        let boxNode = LocationAnnotationNode(location: placeBoxLocation, node: box)
        
        boxNode.constraints = nil
        
        addScenewideNodeSettings(destinationNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: destinationNode)
        addScenewideNodeSettings(boxNode)
        sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: boxNode)
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
}

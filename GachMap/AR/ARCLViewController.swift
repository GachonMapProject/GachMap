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
         newSceneLocationView.autoenablesDefaultLighting = true
         view.addSubview(newSceneLocationView)
         sceneLocationView = newSceneLocationView
     }
    
    override func viewWillAppear(_ animated: Bool) {
        checkCameraAccess()
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

        for i in 0..<path.count{
            let originalAltitude = path[i].location.altitude        // 다음 노드의 고도
            let updatedAltitude = originalAltitude + difAltitude    // 현재위치, 노드 고도 차
            let newLocation = CLLocation(coordinate: path[i].location.coordinate, altitude: updatedAltitude)    // 노드의 고도 수정 (현재 위치와 동일하게)
            
            let sourceNode = makePngNode(fileName: "MuhanStart")
            let muhanNode = LocationAnnotationNode(location: newLocation, node: sourceNode)
            if sceneLocationView != nil {
                print("muhanNode 추가 : \(newLocation.altitude)")
            }
//            muhanNode.constraints = nil  방향 제어 해제 
            addScenewideNodeSettings(muhanNode)
            sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: muhanNode)
        }
        
        
        
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
            getIntermediateCoordinates()
            
        // 카메라 엑세스를 허용하지 않았으면 사용자에게 권한 요청
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                // 권한 허용
                if granted {
                    self.getIntermediateCoordinates()
                // 권한 거부
                } else {
//                        self.alert("Allow camera Access to continue")
                    print("checkCameraAccess : 권한 거부")
                }
            })
        }
    } // end of checkCameraAccess()
    
    
    // 중간 노드들의 정보를 계산하고 가져오는 메서드
    private func getIntermediateCoordinates() {
        // 중간 노드(Steps)를 받아옴 -> CLLocationCoordinate2D 형식으로 보내서 [Step] 형식으로 변환해야 함
        let steps = GetIntermediateCoordinate.getCoordinates(path : path)
        stepData = steps
          
    } // end of getIntermediateCordinates()
    
}

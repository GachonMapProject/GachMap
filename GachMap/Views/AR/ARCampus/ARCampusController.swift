//
//  ARCampusController.swift
//  GachMap
//
//  Created by 이수현 on 5/17/24.
//

import Foundation
import UIKit
import ARKit
import ARCL
import Alamofire

class ARCampusController: UIViewController, ARSCNViewDelegate {
    var sceneLocationView: SceneLocationView?
    
    public var locationEstimateMethod = LocationEstimateMethod.mostRelevantEstimate // 위치 추정 방법
    public var arTrackingType = SceneLocationView.ARTrackingType.worldTracking // AR 추적 타입 (orientation : 방향 추적, world : 평면 추적)
    public var scalingScheme = ScalingScheme.normal // 스케일링 방식
        
    // 노드 위치를 조정하고 크기를 업데이트하는데 필요한 변수
    public var continuallyAdjustNodePositionWhenWithinRange = false
    public var continuallyUpdatePositionAndScale = false
    public var annotationHeightAdjustmentFactor = 1.1
    
    var difAltitude = 0.0
    let ARInfo : [ARInfo]
    
    init(ARInfo : [ARInfo]){
        self.ARInfo = ARInfo
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
            self.addNodes(ARInfo : self.ARInfo)
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
    func addNodes(ARInfo: [ARInfo]) {
        
        sceneLocationView?.removeAllNodes()
        
        // 현재 위치 가져오기
        guard let currentLocation = sceneLocationView?.sceneLocationManager.currentLocation else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.addNodes(ARInfo: ARInfo)
            }
            return
        }
        
        let dispatchGroup = DispatchGroup()
        var annotationNodes = [LocationAnnotationNode]()
        
        for info in ARInfo {
            dispatchGroup.enter()
            let coordinate = CLLocationCoordinate2D(latitude: info.placeLatitude, longitude: info.placeLongitude)
            let location = CLLocation(coordinate: coordinate, altitude: info.plaecAltitude)
            
            confidureImagefromURL(info.arImagePath) { [weak self] image in
                guard let self = self, let image = image else {
                    dispatchGroup.leave()
                    return
                }
                
                let annotationNode = LocationAnnotationNode(location: location, image: image)
                addScenewideNodeSettings(annotationNode)
                annotationNodes.append(annotationNode)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            // 모든 노드가 추가된 후 UI 업데이트
            for node in annotationNodes {
                self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: node)
            }
        }
    }
    
    private func confidureImagefromURL(_ url: String, completion: @escaping (UIImage?) -> Void) {
         guard let url = URL(string: url) else {
             completion(nil)
             return
         }
         
         let request = AF.request(url, method: .get)
         
         request.responseData { response in
             switch response.result {
             case .success(let imageData):
                 let image = UIImage(data: imageData)
                 completion(image)
             case .failure(let error):
                 print(error)
                 completion(nil)
             }
         }
     }
    
    
    
    // 카메라 엑세스 확인 메서드 (권한 거부 시 띄울 알림 추가해야 함)
    private func checkCameraAccess() {
        
        // 현재 앱이 카메라 엑세스 허용했으면 getIntermediateCordinates() 호출하여 중간 좌표를 가져옴
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
//            getIntermediateCoordinates(path: self.path)
            
        // 카메라 엑세스를 허용하지 않았으면 사용자에게 권한 요청
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                // 권한 허용
                if granted {
//                    self.getIntermediateCoordinates(path: self.path)
                // 권한 거부
                } else {
//                        self.alert("Allow camera Access to continue")
                    print("checkCameraAccess : 권한 거부")
                }
            })
        }
    } // end of checkCameraAccess()
    
}

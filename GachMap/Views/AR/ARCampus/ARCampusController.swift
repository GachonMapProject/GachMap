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
import AlamofireImage

class ARCampusController: UIViewController, ARSCNViewDelegate {
    var sceneLocationView: SceneLocationView?
    private let imageCache = AutoPurgingImageCache()
    
    public var locationEstimateMethod = LocationEstimateMethod.mostRelevantEstimate // 위치 추정 방법
    public var arTrackingType = SceneLocationView.ARTrackingType.worldTracking // AR 추적 타입 (orientation : 방향 추적, world : 평면 추적)
    public var scalingScheme = ScalingScheme.normal // 스케일링 방식
        
    // 노드 위치를 조정하고 크기를 업데이트하는데 필요한 변수
    public var continuallyAdjustNodePositionWhenWithinRange = false
    public var continuallyUpdatePositionAndScale = false
    public var annotationHeightAdjustmentFactor = 1.1
    
    var nearAltitude : Double
    let ARInfo : [ARInfo]
    
    init(ARInfo : [ARInfo]){
        guard ARInfo.count > 1 else {
               fatalError("ARInfo array must contain at least two elements.")
           }

        // Assign the ARInfo array excluding the first element
        self.ARInfo = Array(ARInfo[1...])
        self.nearAltitude = ARInfo[0].placeAltitude
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
        rebuildSceneLocationView()  // SceneLocationView() 재구성
        
        // 노드 추가 함수
        DispatchQueue.main.async {
            self.addNodes(ARInfo : self.ARInfo)
        }
//        self.sceneLocationView?.run()    // SceneLocationView 시작
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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

        let difAltitude = currentLocation.altitude - nearAltitude // 현재 측정된 고도와 주변 노드 고도의 차이
        print("difAltitude : \(difAltitude)")

        let dispatchGroup = DispatchGroup()

        var nodes = [LocationAnnotationNode]()
        for info in ARInfo {
            let coordinate = CLLocationCoordinate2D(latitude: info.placeLatitude, longitude: info.placeLongitude)
            let distance = currentLocation.distance(from: CLLocation(coordinate: coordinate, altitude: info.placeAltitude))
            print("distance : \(distance)")

            // 현재 위치로부터 500미터 이하만 보여주기
            if distance < 500 {
                let originalAltitude = info.placeAltitude + (info.buildingHeight ?? 0) // 건물 높이 추가
                let updatedAltitude = originalAltitude + difAltitude // 고도 수정 + 위치 추가해야 함

                let location = CLLocation(coordinate: coordinate, altitude: updatedAltitude)
                
                dispatchGroup.enter()
                configureImageFromURL(info.arImagePath ?? "") { [weak self] image in
                    guard let self = self, let image = image else {
                        print("image - error")
                        dispatchGroup.leave()
                        return
                    }
                    print(info.arImagePath, "성공")
                    let annotationNode = LocationAnnotationNode(location: location, image: image)
                    self.addScenewideNodeSettings(annotationNode)
                    nodes.append(annotationNode)
//                    self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            print("All nodes added")
            nodes.map{self.sceneLocationView?.addLocationNodeWithConfirmedLocation(locationNode: $0)}
            self.sceneLocationView?.run()    // SceneLocationView 시작
        }
    }

    private func configureImageFromURL(_ url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }

        // 이미지 캐시에서 이미지를 가져옵니다.
        if let cachedImage = imageCache.image(withIdentifier: url.absoluteString) {
            completion(cachedImage)
            return
        }

        // 이미지를 다운로드하고 캐시에 저장합니다.
        AF.request(url, method: .get).responseImage { response in
            switch response.result {
            case .success(let image):
                // 이미지 크기를 최적화합니다.
                let targetWidth: CGFloat = 2000
                let scale = targetWidth / image.size.width
                let targetHeight = image.size.height * scale

                UIGraphicsBeginImageContextWithOptions(CGSize(width: targetWidth, height: targetHeight), false, 0.0)
                image.draw(in: CGRect(x: 0, y: 0, width: targetWidth, height: targetHeight))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

//                 이미지를 캐시에 저장합니다.
                if let newImage = newImage {
                    self.imageCache.add(image, withIdentifier: url.absoluteString)
                }
                self.imageCache.add(image, withIdentifier: url.absoluteString)
                
                completion(newImage)
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

import SwiftUI
import ARKit

struct ARView: View {
    
    // 전역으로 CoreLocationEx 인스턴스 생성
    @EnvironmentObject var coreLocation: CoreLocationEx
    @ObservedObject var nextNodeObject : NextNodeObject
    @State var bestHorizontalAccuracy : CLLocationAccuracy
    @State var bestVerticalAccuracy : CLLocationAccuracy
    @State var location : CLLocation
    
    var path : [Node]
    
    
    var body: some View {
        VStack{
            ARViewContainer(path: path, location : location, nextNodeObject : nextNodeObject, bestHorizontalAccuracy: bestHorizontalAccuracy, bestVerticalAccuracy: bestVerticalAccuracy)
            .edgesIgnoringSafeArea(.all)
//            Text("bestHorizontalAccuracy : \(bestHorizontalAccuracy)")
//            Text("bestVerticalAccuracy : \(bestVerticalAccuracy)")
            Text("nextIndex : \(nextNodeObject.nextIndex)")
        }
        .onAppear(){
            bestVerticalAccuracy = coreLocation.location!.verticalAccuracy
            bestHorizontalAccuracy = coreLocation.location!.horizontalAccuracy
        }
        .onChange(of: coreLocation.location) { _ in
            print("coreLocation.location Change")
            if let newLocation = coreLocation.location {
                checkARViewReady(newLocation: newLocation)
            }
        }
    }
    
    func checkARViewReady(newLocation : CLLocation){

        if newLocation.horizontalAccuracy < LocationAccuracy.accuracy && newLocation.verticalAccuracy <  LocationAccuracy.accuracy {
//            bestVerticalAccuracy = newLocation.verticalAccuracy
//            bestHorizontalAccuracy = newLocation.horizontalAccuracy
            location = newLocation
//            print("Change Accuracy :  \(bestHorizontalAccuracy), \(bestVerticalAccuracy)")
        }
        
//        if newLocation.horizontalAccuracy < bestHorizontalAccuracy && newLocation.verticalAccuracy < bestVerticalAccuracy {
//            bestVerticalAccuracy = newLocation.verticalAccuracy
//            bestHorizontalAccuracy = newLocation.horizontalAccuracy
////            location = newLocation
//            print("Change Accuracy :  \(bestHorizontalAccuracy), \(bestVerticalAccuracy)")
//        }
    }
}
        


struct ARViewContainer: UIViewRepresentable {
    
    var path : [Node] // 경로
    var location : CLLocation
    @EnvironmentObject var coreLocation : CoreLocationEx
    @ObservedObject var nextNodeObject : NextNodeObject
    @State private var stepData = [Step]()
    @State var sourcePosition = SCNVector3(x: 0, y: 0, z: 0)            // 출발지 상대적 위치
    var bestHorizontalAccuracy: CLLocationAccuracy
    var bestVerticalAccuracy: CLLocationAccuracy
    @State var nodePositions = [SCNVector3]()

    
    // 2.
    func makeUIView(context: Context) -> ARSCNView {
        
        // Coordinator 초기값 설정
        context.coordinator.oldBestHorizontalAccuracy = bestHorizontalAccuracy
        context.coordinator.oldBestVerticalAccuracy = bestVerticalAccuracy

        
        // ARSCNView 인스턴스 생성
        let arView = ARSCNView()
        
        // ARScene 생성
        let scene = SCNScene()

        // ARScene을 ARSCNView에 할당
        arView.scene = scene
        
        // 3.
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravityAndHeading // y축은 중력과 평행하게 정렬되고 z축과 x축은 나침반 방향으로 정렬
        
        config.planeDetection = [.horizontal, .vertical]
        arView.autoenablesDefaultLighting = true // 입체감 (자동 조명)
        
        
        // 4.
        arView.session.run(config)
        
        // arView.session.run(config)가 완료된 후에 checkCameraAccess() 호출
        DispatchQueue.main.async {
            checkCameraAccess()
            arViewSetup(arView : arView)
        }
                
        return arView
    }
    

    
    func updateUIView(_ arView: ARSCNView, context: Context) {
        print("updateUIView() - nextIndex : \(nextNodeObject.nextIndex)")
        
        // bestVerticalAccuracy, bestHorizontalAccuracy가 변경된 경우에만 context의 변수와 경로 노드 제거 후 새로 로드
//        if context.coordinator.oldBestVerticalAccuracy != bestVerticalAccuracy && context.coordinator.oldBestHorizontalAccuracy != bestHorizontalAccuracy {
//            print("updateUIView - 정확도 변경")
//            DispatchQueue.main.async {
//                sourcePosition = SCNVector3(x: 0, y: 0, z: 0)
//                nodePositions = []  // node의 상대적 위치 초기화
//
//                context.coordinator.oldBestVerticalAccuracy = bestVerticalAccuracy
//                context.coordinator.oldBestHorizontalAccuracy = bestHorizontalAccuracy
//
//                // 이전에 추가된 경로 노드를 모두 제거 후 새로 로드
//                arView.scene.rootNode.enumerateChildNodes { (node, _) in
//                    node.removeFromParentNode()
//                }
//                arViewSetup(arView: arView)
//            }
//       }
        
        // 현재 위치부터 다음 노드까지의 거리를 업데이트
        if let nextNode = arView.scene.rootNode.childNode(withName: "node-\(nextNodeObject.nextIndex)", recursively: true),
           let distanceToNextNode = coreLocation.location?.distance(from: path[nextNodeObject.nextIndex].location),
           let distanceNode = nextNode.childNode(withName: "distance", recursively: true),
           let textGeometry = distanceNode.geometry as? SCNText{

            if distanceToNextNode < 5 && nextNodeObject.nextIndex < path.count{
                DispatchQueue.main.async {
                    nextNodeObject.increment()
                    textGeometry.string = ""
                    print("다음 노드까지 거리 5m 이내 -> 다음 노드로 변경 - nextIndex : \(nextNodeObject.nextIndex)")

                    nodePositions = []  // node의 상대적 위치 초기화
                    
                    // 이전에 추가된 경로 노드를 모두 제거 후 새로 로드
                    arView.scene.rootNode.enumerateChildNodes { (node, _) in
                        node.removeFromParentNode()
                    }
                    arViewSetup(arView: arView)
                    // 타이머 로직, 다음 경로가 보이는 로직 추가해야 함 !!!!!!
                }
               
            } else{
                textGeometry.string = "\(String(format: "%.1f", distanceToNextNode))m"
                textGeometry.font = UIFont(name: "Verdana-Bold", size: 0.5 + 0.05 * distanceToNextNode < 2.5 ? 0.5 + 0.05 * distanceToNextNode : 2.5)

                guard let plane = nextNode.geometry as? SCNPlane else {
                        fatalError("Node geometry is not an SCNPlane")
                    }
                    
                // 플레인의 너비와 높이 설정
                plane.width = 1 + distanceToNextNode * 0.08 < 3.5 ? 1 + distanceToNextNode * 0.08 : 3.5
                plane.height = 1 + distanceToNextNode * 0.08 < 3.5 ? 1 + distanceToNextNode * 0.08 : 3.5
                
                print("distanceToNextNode : \(distanceToNextNode)")

            }
               
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(oldBestHorizontalAccuracy: bestHorizontalAccuracy, oldBestVerticalAccuracy: bestVerticalAccuracy)
    }

    class Coordinator: NSObject {
        var oldBestHorizontalAccuracy: CLLocationAccuracy
        var oldBestVerticalAccuracy: CLLocationAccuracy

        init(oldBestHorizontalAccuracy: CLLocationAccuracy, oldBestVerticalAccuracy: CLLocationAccuracy) {
            self.oldBestHorizontalAccuracy = oldBestHorizontalAccuracy
            self.oldBestVerticalAccuracy = oldBestVerticalAccuracy
        }
    }
    
//    func addDistanceTextNode(arView : ARSCNView, distance : Double){
//        print("addDistanceTextNode - distance : \(distance)")
//
//        let distanceTextNode = placeDirectionText(textPosition: nodePositions[nextNodeObject.nextIndex], text: "\(distance)", isMiddle: false)
//        arView.scene.rootNode.addChildNode(distanceTextNode)
//    }

    
    
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
    
    
//    AR 뷰 설정
    private func arViewSetup(arView : ARSCNView) {
        var source = CLLocation()
//        if nextNodeObject.nextIndex == 0 {
//            // 사용자 고도를 노드의 첫번째 위치와 같게 설정?
//             source = CLLocation(coordinate: location.coordinate, altitude: path.first?.location.altitude ?? 0, horizontalAccuracy: location.horizontalAccuracy, verticalAccuracy: location.verticalAccuracy, timestamp: location.timestamp)
//
//        } else {
//            // 첫번째 노드의 범위 내로 들어오면 그 위치 기준 다시 경로 렌더링
//            source = path[nextNodeObject.nextIndex - 1].location
//        }
        if nextNodeObject.nextIndex == 0 {
            // 사용자 고도를 노드의 첫번째 위치와 같게 설정?
             source = CLLocation(coordinate: location.coordinate, altitude: path.first?.location.altitude ?? 0, horizontalAccuracy: location.horizontalAccuracy, verticalAccuracy: location.verticalAccuracy, timestamp: location.timestamp)
            
        } else {
            // 다음 노드의 범위 내로 들어오면 그 위치 기준 다시 경로 렌더링
            source = CLLocation(coordinate: coreLocation.location!.coordinate, altitude: path[nextNodeObject.nextIndex - 1].location.altitude, horizontalAccuracy: coreLocation.location!.horizontalAccuracy, verticalAccuracy: coreLocation.location!.verticalAccuracy, timestamp: coreLocation.location!.timestamp)
        }

       
        placeSourceNode(arView : arView, source : source) // 출발지 노드 배치
        
        // 경로 노드마다 띄울 텍스트 설정
        for i in 0..<stepData.count - 1 {
            let nodeName = "node-\(stepData[i].locationName)"
            placeMiddleNode(arView : arView, source: source, start : stepData[i].startLocation, end: stepData[i].endLocation, next : stepData[i].nextLocation, nodeName: nodeName)
        }

        placeDestinationNode(arView : arView, source : source)  // 목적지 노드 배치
        
   } // end of arViewSetup()
    
    
    // 출발지 노드 AR 환경에 배치
    private func placeSourceNode(arView : ARSCNView, source : CLLocation) {
        
//        let sourceNode = makeUsdzNode(fileName: "Pin", scale: 0.01, middle: false)
        let sourceNode = makePngNode(fileName: "MuhanStart")
        
        let firstNode = path[0].location    // 경로의 첫번째 위치를 가져옴
        
        // 사용자 현재 위치부터 첫번째 노도 사이의 거리를 구함
        let distance = distanceBetweenCoordinate(source: source, destination: firstNode)
        print("placeSourceNode - distance : \(distance)")
        let transformMatrix = transformMatrix(source: source, destination: firstNode, distance: distance)
        sourceNode.transform = transformMatrix     // 출발지 노드 위치 설정
        sourceNode.name = "node-0" // 노드 이름
        
        
        // 현재 위치부터 시작 노드까지의 경로
//        let cylinder = placeCylinder(source: sourcePosition, destination: sourceNode.position, altitudeDifference: 0)
//        arView.scene.rootNode.addChildNode(cylinder)
        sourcePosition = sourceNode.position    // AR 경로 실린더의 시작 위치 설정
        nodePositions.append(sourcePosition)
        
        // 출발지 텍스트 설정
//        let directionTextNode = placeDirectionText(textPosition: sourcePosition, text: "Start", isMiddle: false)
    
//        sourceNode.addChildNode(directionTextNode)
        
        
        let distanceTextNode = placeDirectionText(textPosition: sourcePosition, text: "\(String(format: "%.1f", distance))m", isMiddle: false)
        sourceNode.addChildNode(distanceTextNode)
//        arView.scene.rootNode.addChildNode(distanceTextNode)
        arView.scene.rootNode.addChildNode(sourceNode)
     

    } // end of placeSourceNode()
    
//    목적지 노드를 AR 환경에 배치
    private func placeMiddleNode(arView : ARSCNView, source: CLLocation, start :CLLocation, end: CLLocation, next : CLLocation, nodeName: String) {
        
        // 다음 노드 상대 좌표
        let nextDistance = distanceBetweenCoordinate(source: source, destination: next)
        let nextTransformationMatrix = transformMatrix(source: source, destination: next, distance: nextDistance)
        let nextNode = SCNNode()
        nextNode.transform = nextTransformationMatrix
        
        // 현재 노드 상대좌표
        let distance = distanceBetweenCoordinate(source: source, destination: end)
        let transformationMatrix = transformMatrix(source: source, destination: end, distance: distance)
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
        
       
        let middleNode = makePngNode(fileName: fileName)
        middleNode.transform = transformationMatrix
        middleNode.name = nodeName
        
        nodePositions.append(middleNode.position)

        let cylinder = placeCylinder(source: sourcePosition, destination: middleNode.position, altitudeDifference : Float(start.altitude - end.altitude))
        
        
        // 텍스트
        let directionTextNode = placeDirectionText(textPosition: middleNode.position, text: "\(String(format: "%.1f", distance))m", isMiddle: true)
        
        
        middleNode.addChildNode(directionTextNode)

        // ARScene에 노드 추가
        arView.scene.rootNode.addChildNode(middleNode)
        arView.scene.rootNode.addChildNode(cylinder)
        
        sourcePosition = middleNode.position
        
        
    } // end of placeDestinationNode()
    
//    출발지와 목적지 사이에 실린더 노드 배치하는 역할
   private func placeCylinder(source: SCNVector3, destination: SCNVector3, altitudeDifference: Float) -> SCNNode{
       let height = source.distance(receiver: destination)
       
       let cylinder = SCNBox(width: 1, height: 0.2, length: CGFloat(height), chamferRadius: 0)
       
       cylinder.firstMaterial?.diffuse.contents = UIColor.gachonSky
       cylinder.firstMaterial?.transparency = 0.9 // 투명도 (0.0(완전 투명)에서 1.0(완전 불투명))
       let node = SCNNode(geometry: cylinder)

       // 실린더 노드의 위치를 출발지와 목적지 중간으로 배치
       node.position = SCNVector3((source.x + destination.x) / 2, (source.y + destination.y) / 2 - 1.5, (source.z + destination.z) / 2)

       // 빗변
       let hypotenuse = sqrt(pow(height, 2) + pow(altitudeDifference, 2))
       
       // 실릴더 기울기
       let angle = acos(height / hypotenuse)
//       node.eulerAngles.x = .pi / 2 + angle
       node.eulerAngles.x = -angle
       
       
       // 출발지와 목적지 사이의 회전각을 구함
       let dirVector = SCNVector3Make(destination.x - source.x, destination.y - source.y, destination.z - source.z)
       let yAngle = atan(dirVector.x / dirVector.z)
       print(yAngle)
       
       node.eulerAngles.y = yAngle

       
       return node
   } // end of placeCylinder
    
    
    // 도착지 노드 AR 환경에 배치
    private func placeDestinationNode(arView : ARSCNView, source : CLLocation) {
        
//        let destinationNode = makeUsdzNode(fileName: "Pin", scale: 0.01, middle: false)
        let destinationNode = makePngNode(fileName: "MuhanEnd")
        
        guard let lastNode = path.last?.location else { return }    // 경로의 첫번째 위치를 가져옴
        
        // 사용자 현재 위치부터 첫번째 노도 사이의 거리를 구함
        let distance = distanceBetweenCoordinate(source: source, destination: lastNode)
        print("placeDestinationNode - distance : \(distance)")
        let transformMatrix = transformMatrix(source: source, destination: lastNode, distance: distance)
        destinationNode.transform = transformMatrix     // 출발지 노드 위치 설정
        destinationNode.name = "node-\(path.count - 1)"
        nodePositions.append(destinationNode.position)
        
        let cylinder = placeCylinder(source: sourcePosition, destination: destinationNode.position, altitudeDifference : sourcePosition.y - destinationNode.position.y)

        
        // 출발지 텍스트 설정
        let directionTextNode = placeDirectionText(textPosition: destinationNode.position, text: "Destination", isMiddle: false)
        destinationNode.addChildNode(directionTextNode)
        arView.scene.rootNode.addChildNode(destinationNode)
        arView.scene.rootNode.addChildNode(cylinder)
        

    } // end of placeSourceNode()
    
    
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
    } // end of tansformMatrix
    
    
    
    
    // 3D 텍스트 노드를 생성 후 방향 제어
    private func placeDirectionText(textPosition: SCNVector3, text: String, isMiddle : Bool) -> SCNNode {
        let textNode = SCNNode(geometry: getIntermediateNodeText(text: text, isMiddle : isMiddle))
        textNode.constraints = [SCNBillboardConstraint()]
        textNode.name = "distance"
        return textNode
    } // end of placeDirectionText
    
    
    // 3D 텍스트 객체 생성 함수
    private func getIntermediateNodeText(text: String, isMiddle : Bool) -> SCNText {
        let intermediateNodeText = SCNText(string: text, extrusionDepth: ArkitNodeDimension.textDepth)
        intermediateNodeText.font = UIFont(name: "Verdana-Bold", size: ArkitNodeDimension.textSize)
        intermediateNodeText.firstMaterial?.diffuse.contents = UIColor.red
        
        
        let width = 20
//        let height = isMiddle ? 3 : 7
        let height = 4
        intermediateNodeText.containerFrame = CGRect(x: -(width / 6), y: 0, width: width, height: height)
        intermediateNodeText.isWrapped = true
        return intermediateNodeText
    } // end of getIntermediateNodeText
    
    
    
    // usdz 파일 노드 생성
    private func makeUsdzNode(fileName : String, scale : Float, middle : Bool) -> SCNNode {
        let file = fileName
        guard let fileUrl = Bundle.main.url(forResource: file, withExtension: "usdz") else {
            fatalError()
        }
        let scene = try? SCNScene(url: fileUrl, options: nil)
        let node = SCNNode()
        
//        if let scene = scene {
//            for child in scene.rootNode.childNodes {
//                child.scale = SCNVector3(scale, scale, scale)
//                if middle {
////                    child.eulerAngles.x = .pi / 2
//                }
//                else {
//                    child.eulerAngles.y = .pi / 2
//                }
//
//                node.addChildNode(child)
//            }
//        }
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
    
}







//func createArrowNode(arView : ARSCNView, source : CLLocation, firstLocation : CLLocation, secondLocation : CLLocation, text : String){
//
//    // 현재 위치부터 시작 노드까지의 거리와 상대 좌표
//    let firstDistance = distanceBetweenCoordinate(source: source, destination: firstLocation)
//    let firstTransformation = transformMatrix(source: source, destination: firstLocation, distance: firstDistance)
//    let firstNode = makeUsdzNode(fileName: "threeArrows", scale: 0.05, middle : false)
//    firstNode.transform = firstTransformation
//    let firstPosition = firstNode.position
//
//    // 현재 위치부터 다음 노드까지의 거리와 상대 좌표
//    let secondDistance = distanceBetweenCoordinate(source: source, destination: secondLocation)
//    let secondTransformation = transformMatrix(source: source, destination: secondLocation, distance: secondDistance)
//    let secondNode = makeUsdzNode(fileName: "threeArrows", scale: 0.05, middle: false)
//    secondNode.transform = secondTransformation
//    let secondPosition = secondNode.position
//
//    // 두 노드 사이의 방향 벡터 계산
//    let dirVector = SCNVector3Make(secondPosition.x - firstPosition.x,
//                                   secondPosition.y - firstPosition.y,
//                                   secondPosition.z - firstPosition.z)
//
//    // 공통 회전각 - 각 화살표 노드의 오일러 회전 y 값
//    let yAngle = atan(dirVector.x / dirVector.z)
//
//    // 두 노드 사이의 거리 계산
//    let distanceBetweenNodes = firstPosition.distance(receiver: secondPosition)
//
//    // 각 화살표 노드의 간격 계산 (5m 당 1개)
//    let interval = distanceBetweenNodes / Float(5)
//    let stepSize = Float(5) / distanceBetweenNodes
//
//    // 첫 번째 화살표 노드의 위치 계산
////        var currentNodePosition = firstPosition
//
//    // 첫 번째 화살표 노드를 제외한 나머지 화살표 노드 생성
//    for i in 1...Int(interval) {
//        // 다음 화살표 노드의 위치 계산
//        let fraction = stepSize * Float(i)
//        let intermediatePosition = SCNVector3(
//            x: firstPosition.x + fraction * dirVector.x,
//            y: firstPosition.y + fraction * dirVector.y,
//            z: firstPosition.z + fraction * dirVector.z
//        )
//
//        // 화살표 노드 생성 및 추가
//        let node = makeUsdzNode(fileName: "middleArrow", scale: 0.01, middle: true)
//        node.position = intermediatePosition
//        node.childNodes.map { $0.eulerAngles.y = yAngle }
////            middleNodeLocation.append(node) // 씬에 추가는 다른 조건에 하기 위함
//        arView.scene.rootNode.addChildNode(node)
//    }
//}

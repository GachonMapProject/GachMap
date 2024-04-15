import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
    static let parking = CLLocationCoordinate2D(latitude: 42.34528, longitude: -71.03278)
}

extension MKCoordinateRegion {
    static let boston = MKCoordinateRegion (
        center: CLLocationCoordinate2D(
            latitude: 42.360256,
            longitude: -71.057279),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1))
    
    static let northShore = MKCoordinateRegion (
        center: CLLocationCoordinate2D(
            latitude: 42.547408,
            longitude: -70.870085),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5))
}

struct MapTestView: View {
    
    @State private var position: MapCameraPosition = .automatic
    @State private var visibleRegion: MKCoordinateRegion?
    
    @State private var searchResult: [MKMapItem] = [] // MKLocalSerach가 아닌 DB에서 값 가져오도록 수정
    @State private var selectedResult: MKMapItem?
    
    var body: some View {
        Map(position: $position, selection: $selectedResult) {
            Marker("Parking", coordinate: .parking)
            
            ForEach(searchResult, id: \.self) { result in
                Marker(item: result)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                BeantownButtons(position: $position, searchResults: $searchResult)
                    .padding(.top)
                Spacer()
            }
            .background(.thinMaterial)
        }
        .onChange(of: searchResult) {
            position = .automatic
        }
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        
        
    } // end of body
}

struct MapTestView_Previews: PreviewProvider {
    static var previews: some View {
        MapTestView()
    }
}

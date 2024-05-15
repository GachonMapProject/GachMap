//
//  RootViewModel.swift
//  GachMap
//
//  Created by 이수현 on 5/14/24.
//

import Foundation

class NavigationController: ObservableObject {
    @Published var shouldPopToRoot: Bool = false
    
    //ChoosePathView
    @Published var isOnlyMapOn : Bool = false
    @Published var isAROn: Bool = false
    
    //SearchMainView
    @Published var isNavigationTriggered: Bool = false
    
    //SearchSpotDetailCard
    @Published var isStartMoved : Bool = false
    @Published var isEndMoved : Bool = false
    @Published var showBuildingDetail : Bool = false
    
    // SearchSecondView
    @Published var goPathView : Bool = false
    
    // BuildingTabView
//    @Published var goPathView : Bool = false
    
    // EventCardView
    @Published var haveLocationData : Bool = false
    
    // EventDetailView
    @Published var isSearch : Bool = false
    
    // LoginView
    @Published var isActive : Bool = false
    
    // SignUpView
    @Published var goInfo : Bool = false
    
    // InfoInputView
    @Published var loginInfoEnd : Bool = false
    
    // GuesInfoInputView
    @Published var guestInfoEnd : Bool = false
    
    // ProfileTabView
    @Published var isLogout : Bool = false
    
    // PasswordCheckView
    @Published var isSame : Bool = false
    
    // WithDrawView
    @Published var isWithDraw : Bool = false
    
    // InquireListCell
//    @Published var isLogout : Bool = false
//    @Published var isLogout : Bool = false
    
    
}

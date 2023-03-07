//
//  NavigationViewModel.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 07/03/23.
//

import SwiftUI
class NavigationViewModel: ObservableObject {
    
//    @Published var needOnboarding: Bool = false {
//        didSet {
//            debugPrint("Need Onboard changed to \(needOnboarding)")
//           UserDefaults.standard.set(needOnboarding, forKey: "userOnboarded")
//        }
//    }
    
    @Published var isTutorialOn = false
    
}

extension UserDefaults {
    var onBoardingShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "onBoardingShown") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "onBoardingShown")
        }
    }
    
    var tutorialShown: Bool {
        get {
            return (UserDefaults.standard.value(forKey: "tutorialShown") as? Bool) ?? false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "tutorialShown")
        }
    }
}

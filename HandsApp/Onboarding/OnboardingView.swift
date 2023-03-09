//
//  OnboardingView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct OnboardingView: View {

    @State private var size = 0.8
    @State private var opacity = 0.5

    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .gray
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray
            .withAlphaComponent(0.2)
    }
    
    var body: some View {
        
            ZStack {
                Image("BlurBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .padding(.top)
                    
                TabView {
                        GestureTutorial1()
                        GestureTutorial2()
                        GestureTutorial3()
                        ThumpPage()
                }
                .tabViewStyle(.page)
            }
        
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

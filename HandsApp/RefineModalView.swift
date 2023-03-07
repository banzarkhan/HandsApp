//
//  RefineModalView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 07/03/23.
//

import SwiftUI

struct RefineModalView: View {
    var body: some View {
        NavigationStack{
            ZStack {
                Image("BlurBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .padding(.top)
                TabView {
                    GestureTutorial1()
                    GestureTutorial2()
                    GestureTutorial3()
                }
                .tabViewStyle(.page)
            }
            .navigationTitle("Gestures")
        }
    }
}

struct RefineModalView_Previews: PreviewProvider {
    static var previews: some View {
        RefineModalView()
    }
}

//
//  TutorialCameraView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct TutorialCameraView: View {
    @StateObject var tutorialVM = TutorialCameraViewModel()
    
    var body: some View {
        TutorialHostedViewController(tutorialVM: tutorialVM)
            .ignoresSafeArea()
            .overlay(alignment: .bottom){
                TutorialModalView(tutorialVM: tutorialVM)
                    .ignoresSafeArea()
            }
    }
}

struct TutorialCameraView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialCameraView()
    }
}

//
//  TutorialModalView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct TutorialModalView: View {
    @ObservedObject var tutorialVM: TutorialCameraViewModel
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .ignoresSafeArea()
                .foregroundColor(.white)
                .opacity(0.30)
                .blur(radius: 1)
                .frame(height: 309)
            VStack(spacing: 23){
                Image(tutorialVM.gesture)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 192)
                Text(tutorialVM.textGesture)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
    }
}

//struct TutorialModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialModalView()
//    }
//}

//
//  TutorialModalView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct TutorialModalView: View {
    @ObservedObject var tutorialVM: TutorialCameraViewModel
    @AppStorage("NeedsTutorial") var needsTutorial = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            
            RoundedRectangle(cornerRadius: 10)
                .ignoresSafeArea()
                .foregroundColor(.white)
                .opacity(0.50)
                .frame(height: 309)
                .ignoresSafeArea()
                .foregroundStyle(.ultraThinMaterial)
            
            if tutorialVM.gesture == "" {
                VStack(spacing: 50){
                    Text("Now you are ready!")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .font(.title)
                    startButton
                }
            } else {
                VStack(spacing: 23){
                    Image(tutorialVM.gesture)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 192)
                    Text(tutorialVM.textGesture)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    var startButton: some View {
        VStack {
            Button(action: {
                print("messaggio  ontrollo")
                needsTutorial = false
                dismiss()
            }, label: {
                Text ("Start!")
                
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(10)
                    .padding(.horizontal, 40.0)
                    .background(Color.white)
                    .cornerRadius(10)
            })
            
        }
    }
    
    
}

//struct TutorialModalView_Previews: PreviewProvider {
//    static var previews: some View {
//        TutorialModalView()
//    }
//}

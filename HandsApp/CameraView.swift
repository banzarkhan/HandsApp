//
//  CameraView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 01/03/23.
//

import SwiftUI
import UIKit
struct RecordLabelView: UIViewRepresentable {
    func makeUIView(context: Context) -> UILabel {
        return CameraViewController.recordLabel
    }
    
    func updateUIView(_ uiView: UILabel, context: Context) {
        // Update the view if needed
    }
}
struct CameraView: View {
    @StateObject var cameraVM = CameraViewModel()
    @State var isRefineModal = false
    
    @AppStorage("NeedsOnboarding") var needsOnboarding = true
    @AppStorage("NeedsTutorial") var needsTutorial = false
    
    var body: some View {
        ZStack {
            ZStack(alignment:.top){
                HostedViewController(cameraVM: cameraVM)
                    .ignoresSafeArea()
                    .overlay(alignment: .top){
                        RoundedRectangle(cornerRadius: 10)
                            .ignoresSafeArea()
                            .foregroundColor(.white)
                            .opacity(0.50)
                            .frame(height: 37)
                            .foregroundStyle(.ultraThinMaterial)
                    }
                    .overlay(alignment: .bottom){
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .ignoresSafeArea()
                                .foregroundColor(.white)
                                .opacity(0.50)
                                .frame(height: 125)
                                .foregroundStyle(.ultraThinMaterial)

                            HStack(alignment: .bottom){
                                Button {
                                    isRefineModal.toggle()
                                } label: {
                                    Image("okSymbol")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .padding()
                                }
                                Spacer()
                                Button {
                                    cameraVM.capturePhoto.toggle()
                                } label: {
                                    ZStack {
                                        Circle()
                                            .strokeBorder(.white, lineWidth: 4)
                                            .frame(width: 75, height: 75)
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 63, height: 63)
                                    }
                                }
                                Spacer()
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .padding()
                            }
                            .padding()
                        }
                    }
                RecordLabelView()
                    .padding()
                    .frame(maxWidth: 20 , maxHeight: 20)
            }

        }
        .fullScreenCover(isPresented: $needsOnboarding){
            OnboardingView()
        }
        .fullScreenCover(isPresented: $needsTutorial){
            TutorialCameraView()
        }
        .sheet(isPresented: $isRefineModal) {
            RefineModalView()
        }
    }
}

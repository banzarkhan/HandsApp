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
    
    var body: some View {
        ZStack {
            ZStack(alignment:.top){
                HostedViewController(cameraVM: cameraVM)
                    .ignoresSafeArea()
                    .overlay(alignment: .top){
                        RoundedRectangle(cornerRadius: 0)
                            .ignoresSafeArea()
                            .foregroundColor(.gray)
                            .opacity(0.17)
                            .frame(height: 37)
                            .background(.ultraThinMaterial)
                            .shadow(radius: 0)
                    }
                    .overlay(alignment: .bottom){
                        ZStack{
                            
                            RoundedRectangle(cornerRadius: 0)
                                .ignoresSafeArea()
                                .foregroundColor(.gray)
                                .opacity(0.17)
                                .frame(height: 125)
                                .background(.ultraThinMaterial)
                                .shadow(radius: 30)

                            HStack{
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                Spacer()
                                Button {
                                    cameraVM.capturePhoto.toggle()
                                } label: {
                                    ZStack {
                                        Circle()
                                            .strokeBorder(.black, lineWidth: 3)
                                            .frame(width: 62, height: 62)
                                        Circle()
                                            .fill(.red)
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                Spacer()
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            .padding()
                        }
                    }
                RecordLabelView()
                    .padding()
                    .frame(maxWidth: 20 , maxHeight: 20)
            }

        }
    }
}


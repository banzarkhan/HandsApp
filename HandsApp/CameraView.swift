//
//  CameraView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 01/03/23.
//

import SwiftUI

struct CameraView: View {
    @StateObject var cameraVM = CameraViewModel()
    
    var body: some View {
        HostedViewController(cameraVM: cameraVM)
            .ignoresSafeArea()
            .overlay(alignment: .bottom) {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .ignoresSafeArea()
                        .foregroundColor(.white)
                        .opacity(0.3)
                        .frame(height: 172)
                        .shadow(radius: 5)
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
    }
}

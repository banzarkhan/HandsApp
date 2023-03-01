//
//  GesturesView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 01/03/23.
//

import SwiftUI

struct GesturesView: View {
//    @State var isCameraOpen = false
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 30){
                Text("Show these gestures to:")
                HStack{
                    Text("👌🏻")
                        .font(.largeTitle)
                    Text("take a photo")
                }
                HStack{
                    Text("✌🏼")
                        .font(.largeTitle)
                    Text("start record the video")
                }
                HStack{
                    Text("✊🏾")
                        .font(.largeTitle)
                    Text("stop record the video")
                }
                NavigationLink(destination: CameraView()){
                    Text("Open camera")
                }
            }
            .font(.title)
            //        .sheet(isPresented: $isCameraOpen){
            //            CameraView()
            //        }
        }
    }
}

struct GesturesView_Previews: PreviewProvider {
    static var previews: some View {
        GesturesView()
    }
}

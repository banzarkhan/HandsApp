//
//  GestureTutorial2.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct GestureTutorial2: View {
    var body: some View {
        ZStack{
            VStack{
            Image("FistPose")
                .resizable()
                .frame(width: 136, height: 260)
                .padding(60)
                HStack{
                    Text("Show this gesture to the camera to")
                    Text("STOP")
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                }
                Text("recording")
            }
        }
    }
}

struct GestureTutorial2_Previews: PreviewProvider {
    static var previews: some View {
        GestureTutorial2()
    }
}

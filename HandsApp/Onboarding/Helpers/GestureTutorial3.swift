//
//  GestureTutorial3.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct GestureTutorial3: View {
    var body: some View {
        ZStack{
            VStack{
            Image("OkPose")
                .resizable()
                .frame(width: 114.53, height: 260)
                .padding(60)
                Text(LocalizedStringKey("Show this gesture to the camera to"))
                Text(("TAKE A PICTURE"))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct GestureTutorial3_Previews: PreviewProvider {
    static var previews: some View {
        GestureTutorial3()
    }
}

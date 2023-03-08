//
//  GestureTutorial1.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct GestureTutorial1: View {
    var body: some View {
        ZStack{
            VStack{
            Image("PeaceOk")
                .resizable()
                .frame(width: 97, height: 260)
                .padding(60)
                HStack{
                    Text(LocalizedStringKey("Show this gesture to the camera to"))
                    Text(LocalizedStringKey("START"))
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                }
                Text(LocalizedStringKey("recording"))
            }
        }
    }
}

struct GestureTutorial1_Previews: PreviewProvider {
    static var previews: some View {
        GestureTutorial1()
//            .environment(\.locale, .init(identifier: "ru"))
    }
}

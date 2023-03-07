//
//  ContentView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 01/03/23.
//

import SwiftUI

struct ContentView: View {
        
    @AppStorage("NeedsSplash") var needsSplash = true

    var body: some View {
        
        if needsSplash{
            SplashPage()
        } else {
            CameraView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

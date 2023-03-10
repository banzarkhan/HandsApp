//
//  SplashPage.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct SplashPage: View {

    @State private var size = 0.8
    @State private var opacity = 0.5
    
    @AppStorage("NeedsSplash") var needsSplash = true
    
    var body: some View {
            ZStack {
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                    .padding(.top)
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .padding(60)
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 0.9
                            self.opacity = 1.0
                        }
                    }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        needsSplash = false
                    }
                }
            }
    }
    
    struct SplashPage_Previews: PreviewProvider {
        static var previews: some View {
            SplashPage()
        }
    }
}

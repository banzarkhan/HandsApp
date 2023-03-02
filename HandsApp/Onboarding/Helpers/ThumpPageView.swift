//
//  ThumpPageView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct ThumpPage: View {
    var body: some View {
        ZStack{
            VStack{
            Image("ThumpPose")
                .resizable()
                .frame(width: 305.81, height: 190.34)
                .padding(60)
                NextButton()
            }
        }
    }
}

struct ThumpPage_Previews: PreviewProvider {
    static var previews: some View {
        ThumpPage()
    }
}

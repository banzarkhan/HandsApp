//
//  CaptionView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct Caption: View {
    @State var text: String
    var body: some View {
        Text(text)
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
}

struct Caption_Previews: PreviewProvider {
    static var previews: some View {
        Caption(text: "Show your fingers like this to the camera to START recording")
    }
}

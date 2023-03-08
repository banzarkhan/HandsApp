//
//  NextButtonView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import SwiftUI

struct NextButton: View {
    var body: some View {
        Button(action: {print("Button Tap")},
               label: {
            Text(LocalizedStringKey("TRY now!"))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(10)
                .padding(.horizontal, 40.0)
                .background(Color                  .black.opacity(0.8))
                .cornerRadius(10)
            
            
        })
    }
    
    struct NextButton_Previews: PreviewProvider {
        static var previews: some View {
            NextButton()
                .previewLayout(.sizeThatFits)
        }
    }
}

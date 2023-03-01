//
//  BottomView.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 01/03/23.
//

import SwiftUI

struct BottomView: View {
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .frame(height: 172)
                .shadow(radius: 5)
            HStack{
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                Spacer()
                Button {
                    
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

struct BottomView_Previews: PreviewProvider {
    static var previews: some View {
        BottomView()
    }
}

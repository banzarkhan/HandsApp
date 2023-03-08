//
//  TutorialCameraViewModel.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import Foundation
import SwiftUI

class TutorialCameraViewModel: ObservableObject {
    @Published var gesture: String = "PeacePoseBlack"
    @Published var textGesture: LocalizedStringKey = "START recording"
}



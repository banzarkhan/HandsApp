//
//  TutorialCameraViewModel.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 02/03/23.
//

import Foundation
import SwiftUI

class TutorialCameraViewModel: ObservableObject {
    @Published var gesture = "PeacePoseBlack"
    @Published var textGesture = "START recording"
}

enum Gestures: String {
    case peace = "PeaceOk"
    case okay
    case fist
    case peaceShadow = "PeacePoseBlack"
    case okayShadow
    case fistShadow
}

func gesturesImage(gestures: Gestures) -> String {
    switch (gestures) {
    case .peace:
        return ("PeaceOk")
    case .okay:
        return ("OkPose")
    case .fist:
        return ("FistPose")
    case .peaceShadow:
        return ("PeacePoseBlack")
    case .okayShadow:
        return ("OkayPoseBlack")
    case .fistShadow:
        return ("FistPoseBlack")
    }
}

func gesturesText(gestures: Gestures) -> String {
    switch (gestures) {
    case .peace:
        return ("GOOD JOB!")
    case .okay:
        return ("GREAT!")
    case .fist:
        return ("WELL DONE!")
    case .peaceShadow:
        return ("START recording")
    case .fistShadow:
        return ("STOP recording")
    case .okayShadow:
        return ("Now TAKE A PICTURE")
    }
}

//
//  CameraViewModel.swift
//  HandsApp
//
//  Created by Ariuna Banzarkhanova on 01/03/23.
//

import Foundation

class CameraViewModel: ObservableObject{
    @Published public var capturePhoto: Bool = false
    @Published public var toggleCamera: Bool = false
}

//
//  UIImagePickerController.SourceType+Ext.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 29/03/2568.
//

import Foundation
import SwiftUI

extension UIImagePickerController.SourceType: @retroactive Identifiable {
    public var id: Int {
        switch self {
        case .camera:
            return 1
        case .photoLibrary:
            return 2
        case .savedPhotosAlbum:
            return 3
        default:
            return 4
        }
    }
}

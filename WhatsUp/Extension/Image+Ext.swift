//
//  Image+Ext.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 29/03/2568.
//

import Foundation
import SwiftUI

extension Image {
    func rounded(width: CGFloat = 100, height: CGFloat = 100) -> some View {
        self
            .resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}

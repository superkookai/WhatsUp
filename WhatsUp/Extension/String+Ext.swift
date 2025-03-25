//
//  String+Ext.swift
//  WhatsUp
//
//  Created by Weerawut Chaiyasomboon on 24/03/2568.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

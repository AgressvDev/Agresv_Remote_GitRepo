//
//  File.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 10/13/24.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Message: Identifiable, Codable
    {
        var id: String
        var text: String
        var received: Bool
        var timestamp: Date
    
    }

//
//  DoublesSharedVariables.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 9/27/23.
//

import Foundation

class SharedData {
    static let shared = SharedData()
    var PartnerSelection: String!
    var OppOneSelection: String!
    var OppTwoSelection: String!
}

class SharedDataNoRank {
    static let sharednorank = SharedDataNoRank()
    var PartnerSelection_NoRank: String!
    var OppOneSelection_NoRank: String!
    var OppTwoSelection_NoRank: String!
}

class SharedDataEmails{
    static let sharedemails = SharedDataEmails()
    var PartnerEmail: String!
    var OppOneEmail: String!
    var OppTwoEmail: String!
}

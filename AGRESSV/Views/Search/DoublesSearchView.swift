//
//  DoublesSearchView.swift
//  AGRESSV
//
//  Created by RyanMax OMelia on 8/31/23.
//

import SwiftUI

   
struct DoublesSearchView: View {
    @State private var searchTerm = ""
    
    var body: some View {
        NavigationStack {
            VStack{
                Text("Pick Your Doubles Partner")
                    .font(.title.weight(.bold))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.gray)
            .navigationTitle("Search")
            .position(x:210, y:100)
            
            
        }
        .searchable(text: $searchTerm)
    }
    
    struct DoublesSearchView_Previews: PreviewProvider {
        static var previews: some View {
            DoublesSearchView()
            
        }
        
    }
    
    
    
}

//
//  countrySheet.swift
//  Amer
//
//  Created by Noori on 27/12/2024.
//

import SwiftUI

struct countrySheet: View {
    @StateObject private var userVM = UserViewModel()
        
    @Binding var selectedCountry: Country?
    @Environment(\.dismiss) var dismiss
    var countries: [Country]

    var body: some View {
        NavigationView {
            List(countries, id: \.id) { country in
                Button(action: {
                    selectedCountry = country
                    dismiss()
                }) {
                    HStack {
                        Text(country.flag)
                            .font(.custom("Tajawal-Medium", size: 24))
                        Text(country.name)
                            .font(.custom("Tajawal-Medium", size: 24))
                    }
                }
            }
            .searchable(text: $userVM.searchText, prompt: "Search countries")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Select a Country")
                        .font(.custom("Tajawal-Bold", size: 30))
                        .foregroundColor(Color("FontColor"))
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    
                }
            } // tool bar end
        }
    }
}


//#Preview {
//    countrySheet()
//}


#Preview {
    @Previewable @State var selectedCountry: Country? = nil

        // Load countries from JSON
        let countries: [Country] = {
            if let url = Bundle.main.url(forResource: "countries", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let decodedCountries = try? JSONDecoder().decode([Country].self, from: data) {
                return decodedCountries
            } else {
                return []
            }
        }()

        return countrySheet(
            selectedCountry: $selectedCountry,
            countries: countries
        )
}

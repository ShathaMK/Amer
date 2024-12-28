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
            
            List(userVM.filteredCountries, id: \.id) { country in
                Button(action: {
                    selectedCountry = country
                    dismiss()
                }) {
                    HStack {
                        Text(country.code)
                            .font(.custom("Tajawal-Medium", size: 20))
                        Text(country.flag)
                            .font(.custom("Tajawal-Medium", size: 20))
                        Text(country.name)
                            .font(.custom("Tajawal-Medium", size: 20))
                    }
                }
            }
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode( .inline)
            .searchable(text: $userVM.searchText, prompt: "Search countries")
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.custom("Tajawal-Bold", size: 20))
                }
                
            } // tool bar end
            
        }
    }
}



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

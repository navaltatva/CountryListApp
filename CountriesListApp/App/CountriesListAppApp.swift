//
//  CountriesListAppApp.swift
//  CountriesListApp
//
//  Created by Naval Hasan on 08/06/25.
//

import SwiftUI

@main
struct CountriesListAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CountryListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

//
//  MenuItemListView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct MenuItemListView: View {
    @EnvironmentObject var menuItemVM: MenuItemViewModel
    @EnvironmentObject var reviewsVM: ReviewViewModel
    @FirestoreQuery(collectionPath: "menuItems") var menuItems: [MenuItem]
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var showWebView = false
    @State private var sheetIsPresented = false

    var searchResult: [MenuItem] { //TODO: Sort this by avg rating and add photo functionality
        if searchText.isEmpty {
            return menuItems
        } else {
            return menuItems.filter {$0.name.capitalized.contains(searchText)}
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List(searchResult) { menuItem in
                    NavigationLink {
                        MenuItemDetailView(menuItem: menuItem)
                    } label: {
                        Text(menuItem.name)
                    }
                }
                .listStyle(.plain)
                .font(.title2)
                .navigationTitle("Popular Meals")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
                .onAppear {
                    reviewsVM.reviews = []
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            sheetIsPresented.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                
                HStack {
                    Button {
                        showWebView.toggle()
                    } label: {
                        Text("Tap For Today's Menu")
                    }
                    .sheet(isPresented: $showWebView) { //TODO: Add a toolbar to this somehow
                        NavigationView {
                            WebView(url: URL(string: "https://www.bc.edu/bc-web/offices/auxiliary-services/sites/dining/locations/dining-menus.html")!)
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    dismiss()
                                }
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            
            NavigationStack {
                MenuItemDetailView(menuItem: MenuItem())
            }
        }
    }
}

struct MenuItemListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemListView()
    }
}

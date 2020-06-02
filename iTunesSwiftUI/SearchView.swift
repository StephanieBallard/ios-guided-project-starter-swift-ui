//
//  SearchView.swift
//  iTunesSwiftUI
//
//  Created by Stephanie Ballard on 6/2/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import SwiftUI

 final class SearchBar: NSObject, UIViewRepresentable {
    
    typealias UIViewType = UISearchBar
    
    @Binding var artistName: String
    @Binding var genreName: String
    
    internal init(artistName: Binding<String> = .constant(""), artistGenre: Binding<String> = .constant("")) {
        _artistName = artistName
        _genreName = artistGenre
    }
    
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.delegate = self
    }
}

extension SearchBar: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("Searched for \(searchBar.text!)")
        searchBar.endEditing(false)
        
        guard let query = searchBar.text else { return }
        
        
        iTunesAPI.searchArtists(for: query) { result in
            do {
                let artists = try result.get()
                guard let artist = artists.first else {
                    self.artistName = "No Artists Found"
                    self.genreName = ""
                    print("No artists found")
                    return
                }
                
                print(artist)
                self.artistName = artist.artistName
                self.genreName = artist.primaryGenreName
            } catch {
                print("iTunes API threw error: \(error)")
                self.artistName = "Error Searching for Artists"
                self.genreName = ""
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}

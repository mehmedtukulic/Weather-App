//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Mehmed Tukulic on 28. 4. 2021..
//

import Foundation

class SearchViewModel{
    private var searchTerm: String = ""
    
    var isLoading: Box<Bool> = Box(false)
    var locations: Box<[Location]> = Box([])
}

extension SearchViewModel {
    func updateSearchTerm(term: String){
        searchTerm = term
        
        //Start searching after 3 characters
        if term.count >= 3 {
            searchForLocations()
        } else {
            locations.value.removeAll()
        }
    }
    
    func searchForLocations(){
        isLoading.value = true
        LocationWorker().getLocations(searchTerm: searchTerm) { [weak self] (locationModel) in
            self?.locations.value = locationModel.locations
            self?.isLoading.value = false
        } failure: { (error) in
            print(error)
        }

    }
}

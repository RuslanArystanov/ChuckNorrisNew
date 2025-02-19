//
//  NetworkManager.swift
//  ChuckNorrisFacts
//
//  Created by Руслан Арыстанов on 05.02.2025.
//

import Foundation

enum URLChuckNorris: String {
    case searchURL = "https://api.chucknorris.io/jokes/search?query="
    case randomURL = "https://api.chucknorris.io/jokes/random"
    case categoryURL = "https://api.chucknorris.io/jokes/categories"
}

class NetworkManager {
    static var share = NetworkManager()
    private init (){}
    
    func fetchData<T:Decodable>(url: String, searchText: String = "", completion: @escaping(T)-> Void) {
        guard let url = URL(string: url + searchText) else {return}
        print(searchText)
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let jsonData = data else {
                print("ошибка в запросе", error.debugDescription)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: jsonData)
                
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch let error {
                print("ошибка пр парсинге", error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchRandomData(url: String, categoryName: String = "", isCategory: Bool = false, completion: @escaping(ChuckNorris)-> Void) {
        var chuckUrl = url
        if isCategory == true {
            chuckUrl += "?category=\(categoryName)"
        }
        
        guard let requestUrl = URL(string: chuckUrl) else {return}
        
        URLSession.shared.dataTask(with: requestUrl) { data, _, error in
            guard let jsonData = data else {
                print(error.debugDescription)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let chuckNorris = try decoder.decode(ChuckNorris.self, from: jsonData)
                
                DispatchQueue.main.async {
                    completion(chuckNorris)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
}

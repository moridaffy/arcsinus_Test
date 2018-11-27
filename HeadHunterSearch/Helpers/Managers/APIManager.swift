//
//  APIManager.swift
//  HeadHunterSearch
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import Foundation

class APIManager {
    
    struct URLs {
        static let baseUrl: String = "https://api.hh.ru"
        
        static let vacancies: String = "/vacancies"
    }
    
    class func getVacancies(text: String?, result: @escaping ([Vacancy]?, Error?) -> Void) {
        var urlString = URLs.baseUrl + URLs.vacancies
        if let text = text {
            urlString += "?text=\(text)"
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let headHunterObject = try decoder.decode(HeadHunterObject.self, from: data)
                        result(headHunterObject.items, nil)
                    } catch let error {
                        result(nil, error)
                    }
                } else {
                    result(nil, error)
                }
            }.resume()
        } else {
            result(nil, nil)
        }
    }
    
}

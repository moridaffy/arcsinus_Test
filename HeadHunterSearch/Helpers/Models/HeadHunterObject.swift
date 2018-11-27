//
//  HeadHunterObject.swift
//  HeadHunterSearch
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import Foundation

struct HeadHunterObject: Codable {
    var items: [Vacancy]
}

struct Vacancy: Codable {
    var name: String
    var alternateUrl: String
    
    var salary: Salary?
    var employer: Employer?
    
    var employerName: String {
        return employer?.name ?? "Не указано"
    }
    
    var price: Int? {
        var count: Int = 0
        var sum: Int = 0
        
        if let from = salary?.from {
            count += 1
            sum += from
        }
        if let to = salary?.to {
            count += 1
            sum += to
        }
        
        if count == 0 {
            return nil
        } else {
            return sum / count
        }
    }
}

struct Salary: Codable {
    var from: Int?
    var to: Int?
}

struct Employer: Codable {
    var name: String?
}

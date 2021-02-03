//
//  City.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 18.12.2020.
//

import UIKit
import RealmSwift


struct City0: Equatable {
    var name: String
    var title: String
    var emblem:  UIImage?
}

class City: Object {
    @objc dynamic var name = ""
    let weathers = List<Weather>()
    
    override static func primaryKey() -> String? {
        return "name"
    }
}



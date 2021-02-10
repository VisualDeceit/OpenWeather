//
//  Firebase.swift
//  OpenWeather
//
//  Created by Alexander Fomin on 07.02.2021.
//

import Foundation
import Firebase


class FirebaseCity {
    let name: String
    let zipcode: Int
    let ref: DatabaseReference?
    
    init(name: String, zipcode: Int) {
        self.name = name
        self.zipcode = zipcode
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let zipcode = value["zipcode"] as? Int,
              let name = value["name"] as? String else {
            return nil
        }
        self.ref = snapshot.ref
        self.name = name
        self.zipcode = zipcode
    }
    
    func toAnyObject() -> [String: Any] {
        return ["name": name,
                "zipcode": zipcode]
    }
}

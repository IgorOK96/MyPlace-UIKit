//
//  StorageManager.swift
//  MyPlace
//
//  Created by user246073 on 10/27/24.
//

import RealmSwift
import Foundation

var realm = try! Realm()

final class StorageManager {
    static func saveobject(_ place: Place) {
        write {
            realm.add(place)
        }
    }
    
    static func delete(_ place: Place) {
        write {
            realm.delete(place)
        }
    }
    
    static func edit(_ place: Place, name: String? = nil, location: String? = nil, type: String? = nil, imageData: Data? = nil, rating: Double? = nil) {
        write {
            place.name = name ?? place.name
            place.location = location ?? place.location
            place.type = type ?? place.type
            place.imageData = imageData ?? place.imageData
            place.rating = rating ?? place.rating
        }
    }

    
    static private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}

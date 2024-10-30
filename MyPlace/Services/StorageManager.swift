//
//  StorageManager.swift
//  MyPlace
//
//  Created by user246073 on 10/27/24.
//

import RealmSwift
import Foundation

var realm = try! Realm()

class StorageManager {
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
    
    static func edit(_ place: Place, name: String?, location: String?, type: String?, imageData: Data?, rating: Double?) {
        write {
            if let name = name {
                place.name = name
            }
            if let location = location {
                place.location = location
            }
            if let type = type {
                place.type = type
            }
            if let imageData = imageData {
                place.imageData = imageData
            }
            if let rating = rating {
                place.rating = rating
            }
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

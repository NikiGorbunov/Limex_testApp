//
//  StorageManager.swift
//  Limex_testApp
//
//  Created by Никита Горбунов on 03.07.2022.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    let realm = try! Realm()
    private init() {}
    
    func save(_ channel: FavoriteChannel) {
        write {
            realm.add(channel)
        }
    }
    
    func delete(_ channelName: String) {
        let channels = realm.objects(FavoriteChannel.self)
        
        for channel in channels {
            if channel.nameRu == channelName {
                write {
                    realm.delete(channel)
                }
            }
        }
    }
    
    private func write(completion: () -> ()) {
        do {
            try realm.write({
                completion()
            })
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}

//
//  NetworkManager.swift
//  Limex_testApp
//
//  Created by Никита Горбунов on 30.06.2022.
//

import Foundation

class NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    func fetchChannels(from url: String?, with completion: @escaping(Channels) -> Void) {
        guard let url = URL(string: url ?? "") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error ?? "No error description")
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let channels = try decoder.decode(Channels.self, from: data)
                DispatchQueue.main.async {
                    completion(channels)
                }
            } catch let error {
                print(error)
            }

        }.resume()
    }
}

class ImageManager {
    static var shared = ImageManager()
    
    private init() {}
    
    func fetchImage(from url: String?) -> Data? {
        guard let stringURL = url else { return nil }
        guard let imageURL = URL(string: stringURL) else { return nil }
        return try? Data(contentsOf: imageURL)
    }
}

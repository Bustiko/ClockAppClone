//
//  TimezoneManager.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 20.08.2024.
//

import Foundation

class DataManager {
    func fetchData<T: Codable>(from url: String) async -> T? {
        do {
            guard let url = URL(string: url) else {
                throw NetworkError.invalidURL
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                throw NetworkError.badStatus
            }
            guard let decodedResponse = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.failedToDecodeJSON
            }
            
            return decodedResponse
        }catch NetworkError.invalidURL {
            print("Error creating URL object")
        }catch NetworkError.invalidResponse {
            print("Did not get valid response")
        }catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response")
        }catch NetworkError.failedToDecodeJSON {
            print("Failed to decode JSON data")
        }catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

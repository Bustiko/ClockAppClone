//
//  NetworkError.swift
//  ClockAppClone
//
//  Created by Buse Karabıyık on 20.08.2024.
//

import Foundation


enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case badStatus
    case failedToDecodeJSON
}

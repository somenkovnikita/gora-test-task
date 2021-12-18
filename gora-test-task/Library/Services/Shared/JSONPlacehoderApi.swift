//
//  JSONPlacehoderApi.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Foundation
import Combine

enum JSONPlacehoderAPI {

    // MARK: - Neested Type

    enum Method {

        case users
        case albums
        case photos

    }

    private static let baseURL: String = "https://jsonplaceholder.typicode.com"

    // MARK: - Public Methods

    static func url(for method: Method) -> URL {
        let url: URL?

        switch method {
        case .users:
            url = URL(string: Self.baseURL + "/users")
        case .albums:
            url = URL(string: Self.baseURL + "/albums")
        case .photos:
            url = URL(string: Self.baseURL + "/photos")
        }

        if let url = url {
            return url
        }

        fatalError("developer error: cannot build url")
    }

    static func fetch<AnyEntryType: Decodable>(usingMethod method: Method) -> AnyPublisher<AnyEntryType, Error> {
        return fetch(url: url(for: method))
    }

    static func fetch<AnyEntryType: Decodable>(url: URL) -> AnyPublisher<AnyEntryType, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
            }
            .decode(type: AnyEntryType.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}

//
//  Photo.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Foundation

struct PhotoEntry: Decodable {

    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String

}

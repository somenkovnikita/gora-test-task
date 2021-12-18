//
//  UserPhotosService.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

import Combine
import Foundation

final class UserPhotosService: AnyUserPhotosService {

    func photos(for userId: Int) -> AnyPublisher<[Photo], Error> {
        let albumsRequst: AnyPublisher<[AlbumEntry], Error> = JSONPlacehoderAPI.fetch(usingMethod: .albums)
        let photosRequst: AnyPublisher<[PhotoEntry], Error> = JSONPlacehoderAPI.fetch(usingMethod: .photos)

        return Publishers.Zip(albumsRequst, photosRequst)
            /* Uncomment for emulate bad network */
            //.delay(for: 1, scheduler: DispatchQueue.main)
            .map { (albumsAndPhotosResult: ([AlbumEntry], [PhotoEntry])) -> [Photo] in
                let albums = albumsAndPhotosResult.0
                let photos = albumsAndPhotosResult.1

                let userAlbums = albums.filter({ album in album.userId == userId })
                let userPhotos = photos.filter({ photo in userAlbums.contains(where: { $0.id == photo.albumId }) })

                return userPhotos.compactMap { (photo: PhotoEntry) -> Photo? in
                    guard let url = URL(string: photo.url) else {
                        return nil
                    }

                    return Photo(url: url, title: photo.title)
                }
            }
            .eraseToAnyPublisher()
    }

}

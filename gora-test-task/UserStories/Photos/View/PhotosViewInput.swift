//
//  PhotosViewInput.swift
//  gora-test-task
//
//  Created by Nikita Somenkov on 18.12.2021.
//

protocol PhotosViewInput: AnyObject {

    func configure(state: State<[PhotoCellViewModel]>)

}

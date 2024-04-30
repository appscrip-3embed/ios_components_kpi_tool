//
//  ImageResponseModel.swift
//  DemoProject
//
//  Created by Appscrip 3Embed on 30/04/24.
//

import Foundation

struct ImageResponseModel: Codable {
    let urls: ImagesUrls?
    let width: Double?
    let height: Double?
}

struct ImagesUrls: Codable {
    let raw: String?
    let full: String?
    let regular: String?
    let small: String?
    let thumb: String?
    let small_s3: String?
}

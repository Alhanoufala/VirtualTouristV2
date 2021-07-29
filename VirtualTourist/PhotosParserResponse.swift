//
//  PhotosParserResponse.swift
//  VirtualTourist
//
//  Created by Alhanouf Alawwad on 15/12/1442 AH.
//
class PhotosParserResponse :Codable {
    
    let page ,pages,perpage ,total :Int
    let photo :[PhotoParserResponse]
}

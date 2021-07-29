//
//  PhotoParserResponse.swift
//  VirtualTourist
//
//  Created by Alhanouf Alawwad on 15/12/1442 AH.
//

class PhotoParserResponse:Codable {
    
    let url :String?
    let title: String
    
    enum CodingKeys: String, CodingKey{
        case url = "url_m"
        case title
    }
}

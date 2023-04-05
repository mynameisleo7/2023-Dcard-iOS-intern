//
//  trackData.swift
//  HW
//
//  Created by Leo Lui on 2023/4/4.
//

import Foundation


struct LookUpResult : Decodable{
    let results:[Track]
    
}


struct Track: Decodable{
    let artworkUrl100: String
    let collectionName: String
    let artistName: String
    let trackName: String
    let releaseDate: String
    let artistViewUrl:String
    let collectionViewUrl: String
    let previewUrl: String
}

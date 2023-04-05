//
//  trackManager.swift
//  HW
//
//  Created by Leo Lui on 2023/4/4.
//

import Foundation

protocol TrackManagerDelegate{
    func outputTrackInfo(track:Track)
}



struct TrackManager{
    let lookupUrl = "https://itunes.apple.com/lookup"
    
    var delegate : TrackManagerDelegate?
    
    func getTrackInfo (trackId: String){
        let urlString = "\(lookupUrl)?id=\(trackId)"
        searchtrack(urlString: urlString)
    }
    
    func searchtrack (urlString:String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    return
                }
                if let safeData = data{
                    if let track = self.parseJSON(trackData: safeData){
                        self.delegate?.outputTrackInfo(track: track)
                    }
                }
            }
            task.resume()
        }
        
    }


    func parseJSON(trackData:Data)->Track?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LookUpResult.self, from: trackData)
            let collectionName = (decodedData.results[0].collectionName)
            let artworkUrl100 = (decodedData.results[0].artworkUrl100)
            let artistName = (decodedData.results[0].artistName)
            let trackName = (decodedData.results[0].trackName)
            let releaseDate = (decodedData.results[0].releaseDate)
            let artistViewUrl = (decodedData.results[0].artistViewUrl)
            let collectionViewUrl = (decodedData.results[0].collectionViewUrl)
            let previewUrl = (decodedData.results[0].previewUrl)
            let track = Track(artworkUrl100: artworkUrl100, collectionName: collectionName, artistName: artistName, trackName: trackName, releaseDate: releaseDate, artistViewUrl: artistViewUrl, collectionViewUrl: collectionViewUrl, previewUrl: previewUrl)
            return track
            
        } catch{
            print(error)
            return nil
        }
    }
    
    
    
    
    
}

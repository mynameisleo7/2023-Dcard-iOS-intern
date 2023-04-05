//
//  searchMusicWithOffset.swift
//  HW
//
//  Created by ＬＥＯ on 2023/4/3.
//

import Foundation

func searchMusicWithOffset(query: String,offset: Int, limit: Int ,completion: @escaping ([Music]) -> Void) {
    let urlString = "https://itunes.apple.com/search?term=\(query)&media=music&offset=\(offset)&limit=\(limit)"
    guard let url = URL(string: urlString) else { return }

    // 创建 URLSession
    let session = URLSession.shared

    // 发送搜索请求
    let task = session.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error searching music: \(error.localizedDescription)")
            return
        }

        // 解析 JSON 数据
        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let results = json["results"] as? [[String: Any]] else {
            completion([])
            return
        }

        // 将搜索结果解析为 Music 对象数组
        let musicList : [Music] = results.compactMap { result in
            guard let artist = result["artistName"] as? String,
                  let album = result["collectionName"] as? String,
                  let song = result["trackName"] as? String,
                  let coverURLString = result["artworkUrl100"] as? String,
                  let coverURL = URL(string: coverURLString) ,
                  let trackId = result["trackId"] as? Int else { return nil }

            return Music(artist: artist, album: album, song: song, coverURL: coverURL,trackId: trackId)
        }

        completion(musicList)
    }

    task.resume()
}

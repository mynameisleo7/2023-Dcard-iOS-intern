//
//  decodeTime.swift
//  HW
//
//  Created by Leo Lui on 2023/4/4.
//

import Foundation

func decodeTime (timeString:String)->String{
    let dateString = timeString
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "西元yyyy年M月d日"
        let formattedDate = dateFormatter.string(from: date)
        return(formattedDate)
    } else {
        return("日期解析失敗")
    }
}

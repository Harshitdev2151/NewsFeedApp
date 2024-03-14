//
//  Converter.swift
//  NewsReader
//
//  Created by Harshit Kumar on 02/03/24.
//

import Foundation

extension String {
    func convertDateFormat() -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let oldDate = olDateFormatter.date(from: self) ?? Date()
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "MMM dd yyyy h:mm a"
        return convertDateFormatter.string(from: oldDate)
    }
}

extension Sequence {
    func limit(_ max: Int) -> [Element] {
        return self.enumerated()
            .filter { $0.offset < max }
            .map { $0.element }
    }
}

func getdate() -> Int {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    let result = formatter.string(from: date)
    return (Int(result) ?? 0) - 1
}

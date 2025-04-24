//
//  String+Extensions.swift
//  Vollmed
//
//  Created by Eliezer Rodrigo on 24/04/25.
//

import Foundation

extension String {
    func converDateStringToReadableDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        guard let date = dateFormatter.date(from: self) else { return "" }
        
        let readableDateFormatter = DateFormatter()
        readableDateFormatter.dateFormat = "dd/MM/yyyy 'às' HH:mm"
        
        return readableDateFormatter.string(from: date)
    }
}

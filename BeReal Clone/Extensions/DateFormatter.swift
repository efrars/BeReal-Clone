//
//  DateFormatter.swift
//  BeReal Clone
//
//  Created by Efrain Rodriguez on 2/27/23.
//




import Foundation

extension DateFormatter {
    static var postFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
}

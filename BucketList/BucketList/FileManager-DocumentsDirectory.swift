//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Esam Sherif on 8/19/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

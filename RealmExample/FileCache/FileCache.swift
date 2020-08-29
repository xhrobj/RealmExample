//
//  FileCache.swift
//  RealmExample
//

import Foundation

enum CacheName: String {
    case arrayTest, setTest, dictionaryTest
}

final class FileCache<T: Codable> {
    
    private let cacheFileName: String
    
    private let queue = DispatchQueue(label: "fileCache")
    
    init(name: CacheName) {
        self.cacheFileName = "\(name.rawValue)Cache"
    }
    
    func writeToCache(data: T) {
        queue.async {
            guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let fileURL = dir.appendingPathComponent(self.cacheFileName)
            
            do {
                let json = try JSONEncoder().encode(data)
                try json.write(to: fileURL)
            }
            catch {
                debugPrint(error)
            }
        }
    }
    
    func readFromCache() -> T? {
        
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = dir.appendingPathComponent(cacheFileName)
        do {
            var decodingData: T? = nil
            try queue.sync {
                let data = try Data(contentsOf: fileURL)
                decodingData = try JSONDecoder().decode(T.self, from: data)
            }
            return decodingData
        }
        catch {
            debugPrint(error)
            return nil
        }
    }
    
}

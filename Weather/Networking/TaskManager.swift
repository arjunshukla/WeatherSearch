//
//  TaskManager.swift
//  Weather
//
//  Created by Arjun Shukla on 5/30/22.
//

import Foundation

class TaskManager {
    typealias completion = (Data?, URLResponse?, Error?) -> Void
    
    static let shared = TaskManager()
    
    let session = URLSession(configuration: .default)
    private var writerQueue = DispatchQueue(label: "com.threadSafe.taskWriter", attributes: .concurrent)

    
    var tasks = [URL: [completion]]()

    private func safeReader(key: URL) -> [completion]?{
        writerQueue.sync {
            return tasks[key]
        }
    }
    
    private func safeWriter(key: URL, completion: @escaping completion) {
        writerQueue.async(flags: .barrier) {
            self.tasks[key]?.append(completion)
        }
    }
    
    func dataTask(with url: URL, completion: @escaping completion) {
        if let _ = safeReader(key: url) {
            safeWriter(key: url, completion: completion)
        } else {
            tasks[url] = [completion]
            
            let _ = session.dataTask(with: url) { [weak self] data, response, error in
                print("Finished network task")
                guard let completions = self?.tasks[url] else { return }
                for handler in completions {
                    print("Executing completions")
                    handler(data, response, error)
                }
            }.resume()
        }
    }
}

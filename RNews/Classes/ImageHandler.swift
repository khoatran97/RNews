//
//  DownloadHandler.swift
//  RNews
//
//  Created by Khoa Huu Tran on 8/19/18.
//  Copyright © 2018 Khoa Huu Tran. All rights reserved.
//

import Foundation
import UIKit

class ImageHandler {
    static var instance = ImageHandler()
    
    private init() {
        // Do nothing
    }
    
    func getImageFromUrl(url: String, completion: @escaping(UIImage?, Error?) -> Void) {
        if url == "" {
            completion(nil, nil)
            return
        }
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, respond, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
        }.resume()
    }
    
    func saveImage(image: UIImage, name: String) -> Bool {
        guard let data = UIImageJPEGRepresentation(image, 0.5) ?? UIImagePNGRepresentation(image) else {
            return false
        }
        
        guard let directory = try? FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        
        do {
            try data.write(to: directory.appendingPathComponent(name)!)
            return true
        } catch {
            return false
        }
    }
    
    func getImage(name: String) -> UIImage? {
        if let directory = try? FileManager.default.url(for: .applicationDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: directory.absoluteString).appendingPathComponent(name).path)
        }
        return nil
    }
}

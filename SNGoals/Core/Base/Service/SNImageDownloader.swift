//
//  ACImageDownloader.swift
//  Sanada
//
//  Created by Matheus D Sanada on 28/03/22.
//

import UIKit

public class SNImageDownloader {
    
    public init () { }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) -> UIImage? {
        print("Download Started")
        var image: UIImage? = nil
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            image = UIImage(data: data)
        }
        return image
    }
    
    public func downloadImage(from link: String) -> UIImage? {
        guard let url = URL(string: link) else { return nil }
        return downloadImage(from: url)
    }
}

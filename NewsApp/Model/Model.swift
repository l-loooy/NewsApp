//
//  Model.swift
//  NewsApp
//
//  Created by admin on 03.06.2022.
//  Copyright © 2022 Sergey Lolaev. All rights reserved.
//

import Foundation

var articles: [Article] = []

let urlString =  "https://newsapi.org/v2/everything?q=apple&from=2022-06-02&to=2022-06-02&sortBy=popularity&apiKey=03f4d624080f4ab58e11fa60bb501090"

func loadNews () {
    guard let url = URL(string: urlString) else { return } //Извлекаем опционал
    let session = URLSession(configuration: .default)
    let downloadTask = session.downloadTask(with: url) { (urlFile, response, error) in
        if urlFile != nil {
            let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]+"/data.json"
            let urlPath = URL(fileURLWithPath: path)
            
            try? FileManager.default.copyItem(at: urlFile!, to: urlPath)
            print(urlPath)
            parseJSON()
            
            print(articles.count)
        }
    }
    downloadTask.resume()
}

func parseJSON() {
    let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]+"/data.json"
    let urlPath = URL(fileURLWithPath: path)
    let data = try? Data(contentsOf: urlPath)
    let rootDictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String, Any>
    let array = rootDictionary!["articles"] as! [Dictionary<String, Any>]
    
    var returnArray: [Article] = []
    
    for dict in array {
        let newArticle = Article(dictionary: dict)
        returnArray.append(newArticle)
    }
}

//
//  NetworkService.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 08.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import Foundation
/**
 Сервис с методам запроса по API
 */
class NetworkService {
    
    let baseUrl = "https://api.deezer.com/search?q="
    
    func searchRequest(_ name: String, completion: @escaping ([String: Any]) -> Void) {
        let group = DispatchGroup()
        guard let url = URL(string: baseUrl + name) else { return }
        let request = URLRequest(url: url)
        group.enter()
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let usageData = data,
                let json = try? JSONSerialization.jsonObject(with: usageData, options: []) as? [String: Any],
                let finalResult = json else { return }
            completion(finalResult)
            group.leave()
        }.resume()
    }
}

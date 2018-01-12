//
//  String+GetDataFromURL.swift
//  SpoyMne
//
//  Created by macbook on 12.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import Foundation

extension String {
    func getDataFromUrl() -> Data {
        guard let url = URL.init(string: self),
            let data = NSData(contentsOf: url) else { return Data() }
        return data as Data
    }
}

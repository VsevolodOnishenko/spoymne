//
//  CoreDataService.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 10.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
    
    private let container = AppDelegate().persistentContainer
    
    func saveSong(_ song: SongModel) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Song", in: container.viewContext) else { return }
        let saveObject = Song(entity: entity, insertInto: container.viewContext)
        saveObject.artistName = song.artistName
        saveObject.songName = song.songName
        saveObject.songImage = song.songImage
        saveObject.songUrl = song.songUrl
        do {
            try container.viewContext.save()
        }
        catch {
            print(error)
        }
    }
    
    func fetchSong(completion: @escaping ([Song]) -> Void) {
        let fetchRequest = NSFetchRequest<Song>(entityName: "Song")
        do {
            let fetchResult = try container.viewContext.fetch(fetchRequest)
            completion(fetchResult)
        }
        catch {
            print(error)
        }
    }
    
}


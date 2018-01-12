//
//  Song+CoreDataProperties.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 11.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Song {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Song> {
        return NSFetchRequest<Song>(entityName: "Song")
    }

    @NSManaged public var artistName: String?
    @NSManaged public var songImage: String?
    @NSManaged public var songName: String?
    @NSManaged public var songUrl: String?

}

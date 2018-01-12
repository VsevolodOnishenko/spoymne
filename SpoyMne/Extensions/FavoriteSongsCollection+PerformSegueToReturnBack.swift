//
//  FavoriteSongsCollection+PerformSegueToReturnBack.swift
//  SpoyMne
//
//  Created by macbook on 12.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import Foundation
/**
 Расширение FavoriteSongsCollection, которое которое позволяет вернуться
 назад по иерархии представлений при нажатии на ячейку в плэйлисте
 */
extension FavoriteSongsCollection {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

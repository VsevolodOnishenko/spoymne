//
//  BaseViewController.swift
//  SpoyMne
//
//  Created by Vsevolod Onishchenko on 09.01.2018.
//  Copyright © 2018 Vsevolod Onishchenko. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let background = UIImage(named:"background") else { return }
        self.view.contentMode = .scaleAspectFill
        self.view.backgroundColor = UIColor(patternImage: background)
    }
}

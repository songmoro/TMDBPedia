//
//  MovieViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/1/25.
//

import UIKit

final class MovieViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension MovieViewController {
    func configure() {
        view.backgroundColor = .Background
        navigationItem.title = "TMDBPedia"
    }
}

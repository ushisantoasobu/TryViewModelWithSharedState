//
//  ViewController.swift
//  TryViewModelWithSharedState
//
//  Created by Shunsuke Sato on 2021/10/15.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let vc = FoldersAndFilesViewController.instantiate(
            foldreId: nil,
            initialSelectedFileIds: [],
            fileSelectedRelayFromPrevious: nil
        )
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
}


//
//  File.swift
//  TryViewModelWithSharedState
//
//  Created by Shunsuke Sato on 2021/10/15.
//

import Foundation

struct File {

    struct Id: Hashable {
        let value: Int
    }

    let id: Id
    let name: String
}

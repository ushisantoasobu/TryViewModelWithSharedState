//
//  FoldersAndFiles.swift
//  TryViewModelWithSharedState
//
//  Created by Shunsuke Sato on 2021/10/15.
//

import Foundation

struct FoldersAndFiles {
    let folders: [Folder]
    let files: [File]

    static func empty() -> FoldersAndFiles {
        return .init(folders: [], files: [])
    }
}


//
//  FoldersAndFilesRepository.swift
//  TryViewModelWithSharedState
//
//  Created by Shunsuke Sato on 2021/10/15.
//

import Foundation
import RxSwift

protocol FoldersAndFilesRepository {
    func fetch() -> Single<FoldersAndFiles>
    func fetch(folderId: Folder.Id) -> Single<FoldersAndFiles>
}

struct FoldersAndFilesRepositoryImpl: FoldersAndFilesRepository {

    // stub
    func fetch() -> Single<FoldersAndFiles> {
        Single.just(FoldersAndFiles(
            folders: [
                Folder(
                    id: .init(value: 1),
                    name: "フォルダ1"
                )
            ],
            files: [
                File(id: .init(value: 1), name: "ファイル1"),
                File(id: .init(value: 2), name: "ファイル2"),
                File(id: .init(value: 3), name: "ファイル3")
            ]
        ))
    }

    // stub
    func fetch(folderId: Folder.Id) -> Single<FoldersAndFiles> {
        if folderId.value == 1 {
            return Single.just(FoldersAndFiles(
                folders: [
                    Folder(
                        id: .init(value: 2),
                        name: "フォルダ2"
                    )
                ],
                files: [
                    File(id: .init(value: 4), name: "ファイル4"),
                    File(id: .init(value: 5), name: "ファイル5"),
                    File(id: .init(value: 6), name: "ファイル6")
                ]
            ))
        } else if folderId.value == 2 {
            return Single.just(FoldersAndFiles(
                folders: [],
                files: [
                    File(id: .init(value: 7), name: "ファイル7")
                ]
            ))
        } else {
            fatalError()
        }
    }
}

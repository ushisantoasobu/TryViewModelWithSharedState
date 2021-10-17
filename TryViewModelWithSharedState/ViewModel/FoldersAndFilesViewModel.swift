//
//  FoldersAndFilesViewModel.swift
//  TryViewModelWithSharedState
//
//  Created by Shunsuke Sato on 2021/10/15.
//

import Foundation
import RxSwift
import RxRelay

class FoldersAndFilesViewModel {

    var folderId: Folder.Id?

    var foldersAndFiles: BehaviorRelay<FoldersAndFiles> = .init(value: .empty())
    var selectedFileIds: BehaviorRelay<Set<File.Id>> = .init(value: [])

    // Output
    var hoge: PublishRelay<(FoldersAndFiles, Set<File.Id>)> = .init()
    var navigateToNext: PublishRelay<Folder.Id> = .init()
    var showSelectedIds: PublishRelay<Set<File.Id>> = .init()
    var refresh: PublishRelay<Void> = .init()
    let fileSelectedRelay: PublishRelay<File.Id> = .init()

    let bag = DisposeBag()

    // no injection
    let repository: FoldersAndFilesRepository

    init(
        folderId: Folder.Id?,
        initialSelectedFileIds: Set<File.Id>,
        repository: FoldersAndFilesRepository = FoldersAndFilesRepositoryImpl()
    ) {
        self.folderId = folderId
        self.selectedFileIds.accept(initialSelectedFileIds)
        self.repository = repository

        Observable
            .combineLatest(foldersAndFiles, selectedFileIds)
            .bind(to: hoge)
            .disposed(by: bag)
    }

    func viewDidLoad() {
        if let folderId = self.folderId {
            repository.fetch(folderId: folderId)
                .subscribe { [weak self] response in
                    self?.foldersAndFiles.accept(response)
                } onFailure: { _ in
                } onDisposed: {}
                .disposed(by: bag)
        } else {
            repository.fetch()
                .subscribe { [weak self] response in
                    self?.foldersAndFiles.accept(response)
                } onFailure: { _ in
                } onDisposed: {}
                .disposed(by: bag)
        }
    }

    func folderSelected(folderId: Folder.Id) {
        navigateToNext.accept(folderId)
    }

    func fileSelected(fileId: File.Id) {
        fileSelectedRelay.accept(fileId)
    }

    func updateSelectedFile(fileId: File.Id) {
        var current = selectedFileIds.value
        if current.contains(fileId) {
            current.remove(fileId)
        } else {
            current.insert(fileId)
        }
        selectedFileIds.accept(current)
        refresh.accept(())
    }

    func confirmButtonTapped() {
        self.showSelectedIds.accept(self.selectedFileIds.value)
    }
}

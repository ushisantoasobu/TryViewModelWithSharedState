//
//  SharedState.swift
//  TryViewModelWithSharedState
//
//  Created by Shunsuke Sato on 2021/10/16.
//

import Foundation
import RxRelay

class SharedState {

    static let shared = SharedState()

    private init() {}

    var selectedFileIds: BehaviorRelay<Set<File.Id>> = .init(value: [])

    func updateSelectedFileIds(_ fileIds: Set<File.Id>) {
        self.selectedFileIds.accept(fileIds)
    }
}

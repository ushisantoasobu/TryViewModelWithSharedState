//
//  FoldersAndFilesViewController.swift
//  TryViewModelWithSharedState
//
//  Created by Shunsuke Sato on 2021/10/15.
//

import UIKit
import RxCocoa
import RxSwift

class FoldersAndFilesViewController: UIViewController {

    static func instantiate(foldreId: Folder.Id?) -> FoldersAndFilesViewController {
        let sb = UIStoryboard(name: "FoldersAndFilesViewController", bundle: nil)
        let vc = sb.instantiateInitialViewController() as! FoldersAndFilesViewController
        vc.folderId = foldreId
        return vc
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!

    var folderId: Folder.Id?
    var viewModel: FoldersAndFilesViewModel!

    let dataSource = FoldersAndFilesViewControllerDataSource()

    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = FoldersAndFilesViewModel(folderId: folderId)
        setupTableView()
        setupBinding()

        viewModel.viewDidLoad()
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func setupBinding() {
        viewModel
            .hoge
            .map {
                FoldersAndFilesViewControllerDataSource.FoldersAndFilesWithSelectedState(
                    foldersAndFiles: $0,
                    selectedFileIds: $1
                )
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

        viewModel
            .navigateToNext
            .subscribe(onNext: { [weak self] folderId in
                let vc = FoldersAndFilesViewController.instantiate(foldreId: folderId)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)

        viewModel
            .showSelectedIds
            .subscribe(onNext: { [weak self] ids in
                let alert = UIAlertController(
                    title: "選択中のファイルID",
                    message: "\(ids.map { $0.value })",
                    preferredStyle: .alert
                )
                alert.addAction(.init(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: bag)

        viewModel
            .refresh
            .subscribe(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: bag)

        tableView
            .rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }

                self.tableView.deselectRow(at: indexPath, animated: true)

                if indexPath.section == 0 {
                    let folderId = self.viewModel.foldersAndFiles.value.folders[indexPath.row].id
                    self.viewModel.folderSelected(folderId: folderId)
                } else if indexPath.section == 1 {
                    let fileId = self.viewModel.foldersAndFiles.value.files[indexPath.row].id
                    self.viewModel.fileSelected(fileId: fileId)
                }
            })
            .disposed(by: bag)
    }

    @IBAction func confirmButtonTapped(_ sender: Any) {
        self.viewModel.confirmButtonTapped()
    }
}


class FoldersAndFilesViewControllerDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    struct FoldersAndFilesWithSelectedState {
        let foldersAndFiles: FoldersAndFiles
        let selectedFileIds: Set<File.Id>
    }

    typealias Element = FoldersAndFilesWithSelectedState
    var _items: FoldersAndFilesWithSelectedState = .init(foldersAndFiles: FoldersAndFiles.empty(),
                                                                   selectedFileIds: [])

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return _items.foldersAndFiles.folders.count
        case 1:
            return _items.foldersAndFiles.files.count
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let element = _items.foldersAndFiles.folders[indexPath.row]
            cell.textLabel?.text = element.name
            cell.accessoryType = .disclosureIndicator
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let element = _items.foldersAndFiles.files[indexPath.row]
            cell.textLabel?.text = element.name
            if _items.selectedFileIds.contains(_items.foldersAndFiles.files[indexPath.row].id) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        default:
            fatalError()
        }
    }

    func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
        Binder(self) { dataSource, element in
            dataSource._items = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }
}

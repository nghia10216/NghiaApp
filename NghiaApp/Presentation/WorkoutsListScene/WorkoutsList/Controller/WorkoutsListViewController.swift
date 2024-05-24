//
//  WorkoutsListViewController.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 22/05/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WorkoutsListViewController: BaseViewController {

  // MARK: - Outlets
  @IBOutlet weak var tableView: UITableView!

  // MARK: - Properties
  private let viewModel: WorkoutsListViewModel
  private lazy var dataSource = makeDataSource()

  // MARK: - Subjects
  private let assignmentTrigger = PublishRelay<(excersiseIndexPath: IndexPath, assignmentIndexPath: IndexPath)>()

  let disposeBag = DisposeBag()

  // MARK: - Initialize
  init(viewModel: WorkoutsListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Life Cycles
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  // MARK: - configUI
  override func configUI() {
    super.configUI()
    configTableView()
  }

  // MARK: - bindingData
  override func bindingData() {
    super.bindingData()

    let input = WorkoutsListViewModel.Input(
      getMoviesListTrigger: .just(()), 
      assignmentTrigger: assignmentTrigger.asDriverOnErrorJustComplete()
    )

    let output = viewModel.transform(input: input)
    output.workoutsListSections.drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    output.appError
      .drive(onNext: { [weak self] appError in
          self?.showAlert(title: LanguageKey.errorTitle.text, message: appError.actualErrorMessage)
      })
      .disposed(by: disposeBag)
  }

  // MARK: - Private
  private func configTableView() {
    tableView.register(WorkoutTableViewCell.self)
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
  }

}

// MARK: RxTableViewSectionedReloadDataSource
extension WorkoutsListViewController {
  private func makeDataSource() -> RxTableViewSectionedReloadDataSource<WorkoutSection> {
    RxTableViewSectionedReloadDataSource<
      WorkoutSection>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
          let cell = tableView.dequeue(WorkoutTableViewCell.self, for: indexPath)
          cell.updateCell(with: item)
          cell.assignmentTrigger.drive(onNext: { [weak self] assignmentIndexPath in
            self?.assignmentTrigger.accept((indexPath, assignmentIndexPath))
          })
          .disposed(by: cell.disposeBag)

          return cell
        })
  }
}

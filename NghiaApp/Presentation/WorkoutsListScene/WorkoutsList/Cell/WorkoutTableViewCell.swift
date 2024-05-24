//
//  WorkoutTableViewCell.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 23/05/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WorkoutTableViewCell: UITableViewCell {

  @IBOutlet weak var dayNameLabel: UILabel!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var tableView: ContentSizedTableView!

  var disposeBag = DisposeBag()
  private let internalDisposeBag = DisposeBag()
  lazy var dataSource = makeDataSource()

  private let assignmentSections = BehaviorRelay<[AssignmentSection]>(value: [])

  var assignmentTrigger: Driver<IndexPath> {
    tableView.rx.itemSelected.asDriver()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    configTableView()
    assignmentSections.asDriver().drive(tableView.rx.items(dataSource: dataSource))
      .disposed(by: internalDisposeBag)
  }

  private func configTableView() {
    tableView.register(ExcerciseTableViewCell.self)
    tableView.rowHeight = 80
  }

  func updateCell(with item: WorkoutItem) {
    let isCurrentDay = item.differentDay == 0
    dayLabel.textColor = isCurrentDay ? ColorDefine.completeAssignmentBgColor : ColorDefine.dayColor
    dayLabel.text = "\(item.day.day)"
    dayNameLabel.text = item.day.format(to: .eee).uppercased()
    dayNameLabel.textColor = isCurrentDay ? ColorDefine.completeAssignmentBgColor : ColorDefine.dayNameColor
    let assignmentItems = item.workout?.assignments.map {
      AssignmentItem(assignment: $0, differentDay: item.differentDay)
    } ?? []
    assignmentSections.accept([AssignmentSection(items: assignmentItems)])
  }
}

extension WorkoutTableViewCell {
  private func makeDataSource() -> RxTableViewSectionedReloadDataSource<AssignmentSection> {
    RxTableViewSectionedReloadDataSource<
      AssignmentSection>(
        configureCell: { [weak self] dataSource, tableView, indexPath, item in
          guard let _ = self else {
            return UITableViewCell()
          }
          let cell = tableView.dequeue(ExcerciseTableViewCell.self, for: indexPath)
          cell.updateCell(with: item)
          return cell
        }
      )
  }
}

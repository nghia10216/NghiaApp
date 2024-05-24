//
//  ExcerciseTableViewCell.swift
//  NghiaApp
//
//  Created by Lê Nghĩa on 23/05/2024.
//

import UIKit

class ExcerciseTableViewCell: UITableViewCell {

  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var excerciseTitleLabel: UILabel!
  @IBOutlet weak var numberOfExcerciseLabel: UILabel!
  @IBOutlet weak var filledImageView: UIImageView!
  @IBOutlet weak var bgView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  func updateCell(with item: AssignmentItem) {
    let isLocalCompleted = item.assignment.isComplete
    filledImageView.isHidden = !isLocalCompleted
    numberOfExcerciseLabel.isHidden = isLocalCompleted
    excerciseTitleLabel.text = item.assignment.title
    let isDelay = item.differentDay < 0
    statusLabel.isHidden = !isDelay
    statusLabel.textColor = isLocalCompleted ? ColorDefine.workoutTitleColor : ColorDefine.missedStatusColor
    statusLabel.text = isLocalCompleted ? LanguageKey.completed.text : LanguageKey.missed.text
    bgView.backgroundColor = isLocalCompleted ? ColorDefine.completeAssignmentBgColor : ColorDefine.assignmentBgColor
    let isFuture = item.differentDay > 0
    isUserInteractionEnabled = !isFuture
    if isLocalCompleted {
      excerciseTitleLabel.textColor = ColorDefine.workoutTitleColor
      numberOfExcerciseLabel.textColor = ColorDefine.workoutTitleColor
      statusLabel.isHidden = false
    } else {
      excerciseTitleLabel.textColor = isFuture ? ColorDefine.assignmentDisableTitleColor : ColorDefine.dayNameColor
      let exercisesCount = item.assignment.exercisesCount.unwrapped(or: 0)
      numberOfExcerciseLabel.text = "\(isDelay ? " • " : "")\(exercisesCount) \(exercisesCount > 1 ? LanguageKey.excerscises.text : LanguageKey.excerscise.text)"
      numberOfExcerciseLabel.textColor = isFuture ? ColorDefine.assignmentDisableTitleColor : ColorDefine.dayNameColor
    }
  }
}

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
    excerciseTitleLabel.text = item.assignment.title
    let isDelay = item.differentDay < 0
    statusLabel.isHidden = !isDelay
    let isFuture = item.differentDay > 0
    isUserInteractionEnabled = !isFuture
    if isLocalCompleted {
      excerciseTitleLabel.textColor = ColorDefine.workoutTitleColor
      numberOfExcerciseLabel.textColor = ColorDefine.workoutTitleColor
      statusLabel.isHidden = false
      statusLabel.textColor = ColorDefine.workoutTitleColor
      bgView.backgroundColor = ColorDefine.completeAssignmentBgColor
      filledImageView.isHidden = false
      numberOfExcerciseLabel.isHidden = true
      statusLabel.text = LanguageKey.completed.text
    } else {
      numberOfExcerciseLabel.isHidden = false
      filledImageView.isHidden = true
      excerciseTitleLabel.textColor = isFuture ? ColorDefine.assignmentDisableTitleColor : ColorDefine.dayNameColor
      let exercisesCount = item.assignment.exercisesCount.unwrapped(or: 0)
      numberOfExcerciseLabel.text = "\(isDelay ? " • " : "")\(exercisesCount) \(exercisesCount > 1 ? LanguageKey.excerscises.text : LanguageKey.excerscise.text)"
      numberOfExcerciseLabel.textColor = isFuture ? ColorDefine.assignmentDisableTitleColor : ColorDefine.dayNameColor
      statusLabel.text = LanguageKey.missed.text
      statusLabel.textColor = ColorDefine.missedStatusColor
      bgView.backgroundColor = ColorDefine.assignmentBgColor
    }
  }
}

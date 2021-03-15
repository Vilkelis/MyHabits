//
//  HabitCollectionViewCell.swift
//  MyHabits
//
//  Created by Stepas Vilkelis on 08.03.2021.
//

import UIKit

class HabitCollectionViewCell: UICollectionViewCell{
    
    var onCheked: (() -> Void)?
    
    var habit: Habit? {
        didSet {
           habitChanged()
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "SF Pro Text Semibold", size: 17)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AppColor1")
        label.text = "Каждый день в 11:00"
        label.font = UIFont.init(name: "SF Pro Text Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let retryCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AppColor2")
        label.text = "Подряд: 0"
        label.font = UIFont.init(name: "SF Pro Text Regular", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "AppBackground")
        button.roundCornersWithRadius(18, shadowEnabled: false)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(named: "AppColor8")?.cgColor
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initializators
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.roundCornersWithRadius(8, shadowEnabled: false)
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(named: "AppColorBackground")
        
        checkButton.addTarget(self, action: #selector(checkButtonPressed), for: .touchUpInside)
        
        let views = [nameLabel, timeLabel, checkButton, retryCountLabel]
        views.forEach {
            self.addSubview($0)
        }
        let constraints = [
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -80),
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            checkButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 47),
            checkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26),
            checkButton.heightAnchor.constraint(equalToConstant: 36),
            checkButton.widthAnchor.constraint(equalToConstant: 36),
            self.heightAnchor.constraint(equalToConstant: 130),
            retryCountLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            retryCountLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    //MARK: Events
    @objc private func checkButtonPressed() {
        if let h = self.habit {
            if !h.isAlreadyTakenToday {
                HabitsStore.shared.track(h)
                habitTakenTodayShow()
                if let checkEvent = onCheked {
                    checkEvent()
                }
            }
        }
    }
    
    private func habitChanged() {
        if let h = self.habit {
            nameLabel.text = h.name
            nameLabel.textColor = h.color
            timeLabel.text = h.dateString
            checkButton.layer.borderColor = h.color.cgColor
            retryCountLabel.text = {
                var counts = 0
                for index in 0..<HabitsStore.shared.dates.count {
                    let dateIndex = HabitsStore.shared.dates.count - index - 1
                    let date = HabitsStore.shared.dates[dateIndex]
                    guard HabitsStore.shared.habit(h, isTrackedIn: date) else { break }
                    counts += 1
                }
                return "Подряд: \(counts)"
            }()
        } else {
            nameLabel.text = ""
            timeLabel.text = ""
            checkButton.layer.borderColor = self.backgroundColor?.cgColor
        }
        habitTakenTodayShow()
    }
    
    private func habitTakenTodayShow(){
        if let h = self.habit {
            if h.isAlreadyTakenToday {
              checkButton.backgroundColor = h.color
              checkButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
              checkButton.tintColor = self.backgroundColor
            } else {
              checkButton.backgroundColor = self.backgroundColor
              checkButton.setImage(nil, for: .normal)
              checkButton.tintColor = self.backgroundColor
            }
        } else {
            checkButton.backgroundColor = self.backgroundColor
            checkButton.setImage(nil, for: .normal)
            checkButton.tintColor = self.backgroundColor
        }
    }
}

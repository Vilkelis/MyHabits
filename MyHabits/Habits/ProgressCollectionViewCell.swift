//
//  ProgressCollectionViewCell.swift
//  MyHabits
//
//  Created by Stepas Vilkelis on 08.03.2021.
//

import UIKit

class ProgressCollectionViewCell: UICollectionViewCell {
    
    private let progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progressTintColor = UIColor(named: "AppColor4")
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Все получится!"
        label.textColor = UIColor(named: "AppColor1")
        label.font = UIFont.init(name: "SF Pro Text Semibold", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let percentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "AppColor1")
        label.font = UIFont.init(name: "SF Pro Text Semibold", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Initializators
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupProgressValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.roundCornersWithRadius(4, shadowEnabled: false)
        self.backgroundColor = UIColor(named: "AppColorBackground")
        
        let views = [titleLabel, percentLabel, progressView]
        views.forEach {
            contentView.addSubview($0)
        }
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            percentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            percentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            progressView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            progressView.heightAnchor.constraint(equalToConstant: 7),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
     func setupProgressValue() {
        progressView.setProgress(HabitsStore.shared.todayProgress, animated: false)
        percentLabel.text = "\(Int(HabitsStore.shared.todayProgress * 100))%"
    }
}

//
//  HabitDetailsTableViewHeader.swift
//  MyHabits
//
//  Created by Stepas Vilkelis on 10.03.2021.
//

import UIKit

class HabitDetailsTableViewHeader: UITableViewHeaderFooterView {
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "SF Pro Text Regular", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "AppColor2")
        label.text = "АКТИВНОСТЬ"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(named: "AppColor3")
        
        contentView.addSubview(titleLabel)
        let constraints = [
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

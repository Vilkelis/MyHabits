//
//  HabbitDetailsTableViewCell.swift
//  MyHabits
//
//  Created by Stepas Vilkelis on 10.03.2021.
//

import UIKit

class HabitDetailsTableViewCell: UITableViewCell {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var checked: Bool = false {
        didSet {
            checkImage.isHidden = !checked
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "SF Pro Text Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        return label
    }()
    
    let checkImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "checkmark")
        img.tintColor = UIColor(named: "AppColor4")
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        img.isHidden = true
        return img
    } ()
    
    
    
    // MARK: - Initializators
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupViews
    private func setupViews() {
        [titleLabel, checkImage].forEach {
            self.contentView.addSubview($0)
        }
        
        let constraints = [
            checkImage.heightAnchor.constraint(equalToConstant: 22),
            checkImage.widthAnchor.constraint(equalToConstant: 22),
            checkImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            checkImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: checkImage.centerYAnchor),
            
            contentView.bottomAnchor.constraint(equalTo: checkImage.bottomAnchor, constant: 12),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

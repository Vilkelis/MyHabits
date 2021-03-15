//
//  HabitViewController.swift
//  MyHabits
//
//  Created by Stepas Vilkelis on 14.02.2021.
//

import UIKit

class HabitViewController: UIViewController {
    
    var onSave: (() -> Void)?
    
    var onDelete: (() -> Void)?
    
    var habit: Habit? {
        didSet {
            habitChanged()
        }
    }
    
    func createMode() -> Bool {
        return self.habit == nil
    }
    
    private let navBar: UINavigationBar = {
        let bar = UINavigationBar()
        let mainItem = UINavigationItem()
        let cancelBtn = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action:  #selector(cancelButtonPressed))
        let saveBtn = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonPressed))
        mainItem.leftBarButtonItem = cancelBtn
        mainItem.rightBarButtonItem = saveBtn
        bar.pushItem(mainItem, animated: true)
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.tintColor = UIColor(named: "AppColor4")
        return bar
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(UIColor(named: "AppColorDanger"), for: .normal)
        button.titleLabel?.font = UIFont(name: "SF Pro Text Regular", size: 17)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Наименование"
        label.font = UIFont.init(name: "SF Pro Text Semibold", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.init(name: "SF Pro Text Semibold", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время"
        label.font = UIFont.init(name: "SF Pro Text Semibold", size: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeChooseLabel: UILabel = {
        let label = UILabel()
        label.text = "Каждый день в"
        label.font = UIFont.init(name: "SF Pro Text Regular", size: 17)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeChooseFieldLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.init(name: "SF Pro Text Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "AppColor4")
        return label
    }()
    
    private let nameField: UITextField = {
        let field = UITextField()
        field.font = UIFont.init(name: "SF Pro Text Regular", size: 17)
        field.placeholder = "Бегать по утрам, спать 8 часов и т.п."
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let colorButton: UIButton = {
        let button = UIButton()
        button.roundCornersWithRadius(15, shadowEnabled: false)
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(colorButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let localeId = Locale.preferredLanguages.first
        datePicker.datePickerMode = .countDownTimer
        datePicker.minuteInterval = 1
        datePicker.locale = Locale(identifier: localeId!)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(datePickerDateChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var colorPicker: UIColorPickerViewController = {
        let cp = UIColorPickerViewController()
        cp.supportsAlpha = false
        cp.delegate = self
        return cp
    }()
    
    // MARK: View Did Load
    override func viewDidLoad() {
        self.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        super.viewDidLoad()
        setupLayout()
        setupControls()
    }
    
    private func setupControls(){
        habitChanged()
    }
    
    private func setupLayout(){
        self.view.backgroundColor = UIColor(named: "AppColorBackground")
        let views = [navBar, nameLabel, nameField, colorLabel, colorButton, timeLabel, timeChooseLabel, timeChooseFieldLabel, datePicker, deleteButton]
        views.forEach {
            self.view.addSubview($0)
        }
        let constraints = [
            navBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 22),
            
            nameField.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 7),
            
            colorLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            colorLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            colorLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 15),
            
            colorButton.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 7),
            colorButton.leadingAnchor.constraint(equalTo: colorLabel.leadingAnchor),
            colorButton.heightAnchor.constraint(equalToConstant: 30),
            colorButton.widthAnchor.constraint(equalToConstant: 30),
            
            timeLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeLabel.topAnchor.constraint(equalTo: colorButton.bottomAnchor, constant: 15),
            
            timeChooseLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            timeChooseLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            timeChooseLabel.widthAnchor.constraint(equalToConstant: timeChooseLabel.frame.width),
            
            timeChooseFieldLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 7),
            timeChooseFieldLabel.leadingAnchor.constraint(equalTo: timeChooseLabel.trailingAnchor, constant: 7),
            timeChooseFieldLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            timeChooseFieldLabel.heightAnchor.constraint(equalTo: timeChooseLabel.heightAnchor),
            datePicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            datePicker.topAnchor.constraint(equalTo: self.timeLabel.bottomAnchor, constant: 15),
            deleteButton.heightAnchor.constraint(equalToConstant: 20),
            deleteButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -12)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Events
    @objc private func colorButtonPressed() {
        self.colorPicker.selectedColor = self.colorButton.backgroundColor!
        self.present(self.colorPicker, animated: true, completion: nil)
    }
    
    @objc private func datePickerDateChanged(){
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        timeChooseFieldLabel.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func cancelButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveButtonPressed(){
        if createMode() {
            let newHabit = Habit(name: self.nameField.text ?? "",
                                 date: datePicker.date,
                                 color: self.colorButton.backgroundColor! )
            HabitsStore.shared.habits.append(newHabit)
        } else {
            let h = self.habit!
            h.name = self.nameField.text ?? ""
            h.date = datePicker.date
            h.color = self.colorButton.backgroundColor!
        }
        self.dismiss(animated: true, completion: onSave)
    }
    
    @objc private func deleteButtonPressed() {
        let alert = UIAlertController(title: "Удалить привычку",
                                      message: "Вы хотите удалить привычку \"\(self.habit!.name)\"",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Удалить",
                                      style: .destructive,
                                      handler: handleDeleteHabit
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteHabit(action: UIAlertAction) {
        HabitsStore.shared.habits.removeAll{$0 == self.habit}
        if let deleteEvent = self.onDelete {
            deleteEvent()
        }
    }
    
    func habitChanged() {
        if let h = habit {
            nameField.text = h.name
            colorButton.backgroundColor = h.color
            datePicker.date = h.date
            navBar.topItem?.title = "Править"
            deleteButton.isHidden = false
        }
        else {
            nameField.text = ""
            colorButton.backgroundColor = UIColor(named: "AppColor8")
            datePicker.date = Date()
            navBar.topItem?.title = "Создать"
            deleteButton.isHidden = true
        }
        datePickerDateChanged()
    }
}

// MARK - ColorPicker Delegate
extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorButton.backgroundColor = viewController.selectedColor
    }
}

// MARK: - Extensions
extension UIView {
    
    /// Method adds shadow and corner radius for top of view by default.
    ///
    /// - Parameters:
    ///   - top: Top corners
    ///   - bottom: Bottom corners
    ///   - radius: Corner radius
    func roundCornersWithRadius(_ radius: CGFloat, top: Bool? = true, bottom: Bool? = true, shadowEnabled: Bool = true) {
        var maskedCorners = CACornerMask()
        
        if shadowEnabled {
            clipsToBounds = true
            layer.masksToBounds = false
            layer.shadowOpacity = 0.5
            layer.shadowColor = UIColor(white: 0.0, alpha: 1.0).cgColor
            layer.shadowRadius = 4
            layer.shadowOffset = CGSize(width: 4, height: 4)
        }
        
        switch (top, bottom) {
        case (true, false):
            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case (false, true):
            maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case (true, true):
            maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        default:
            break
        }
        
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorners
    }
    
}

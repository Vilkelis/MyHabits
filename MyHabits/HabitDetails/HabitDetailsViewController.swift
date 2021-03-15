//
//  HabitDetailsViewController.swift
//  MyHabits
//
//  Created by Stepas Vilkelis on 09.03.2021.
//

import UIKit

class HabitDetailsViewController: UIViewController {
    
    var habit: Habit? {
        didSet {
            habitChanged()
        }
    }
    
    var onDelete: (() -> Void)?
    var onSave: (() -> Void)?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self         
        tableView.register(HabitDetailsTableViewCell.self, forCellReuseIdentifier: String(describing: HabitDetailsTableViewCell.self))
        tableView.register(HabitDetailsTableViewHeader.self, forHeaderFooterViewReuseIdentifier: String(describing: HabitDetailsTableViewHeader.self))
        tableView.backgroundColor = UIColor(named: "AppColor3")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        habitChanged()
        self.view.backgroundColor = UIColor(named: "AppColorBackground")
        self.navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Править", style: .plain, target: self, action:  #selector(editButtonPressed))
        navigationController?.navigationBar.tintColor = UIColor(named: "AppColor4")
        
        view.addSubview(tableView)
        
        let constraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: - Events
    @objc private func editButtonPressed() {
        let modalViewController = HabitViewController()
        modalViewController.onSave = {
            self.habitChanged()
            if let saveEvent = self.onSave {
                saveEvent()
            }
        }
        modalViewController.habit = self.habit
        modalViewController.onDelete = {
            modalViewController.dismiss(animated: true, completion: self.onDelete)
        }
        self.present(modalViewController, animated: true, completion: nil)
    }
    
    private func habitChanged(){
        if let h = self.habit {
            self.navigationItem.title = h.name
        } else {
            self.navigationItem.title = ""
        }
    }
}

// MARK: - UITableViewDataSource
extension HabitDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(HabitsStore.shared.dates.count)
        return HabitsStore.shared.dates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: HabitDetailsTableViewCell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: HabitDetailsTableViewCell.self),
            for: indexPath) as! HabitDetailsTableViewCell
        let dateIndex = HabitsStore.shared.dates.count - indexPath.item - 1
        cell.title = HabitsStore.shared.trackDateString(forIndex: dateIndex) ?? ""
        if let h = self.habit {
            let date = HabitsStore.shared.dates[dateIndex]
            cell.checked = HabitsStore.shared.habit(h, isTrackedIn: date)
        } else {
            cell.checked = false
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: HabitDetailsTableViewHeader.self)) as! HabitDetailsTableViewHeader
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

// MARK: - UITableViewDelegate
extension HabitDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



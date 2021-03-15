//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Stepas Vilkelis on 13.02.2021.
//

import UIKit

class HabitsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ProgressCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ProgressCollectionViewCell.self))
        view.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HabitCollectionViewCell.self))
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(named: "AppColor3")
        
        return view
    }()
    
    //MARK: - Load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Сегодня"
        self.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = UIColor(named: "AppColor4")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        
        self.view.addSubview(collectionView)
        
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    //MARK: Events
    @objc private func addButtonPressed() {
        let modalViewController = HabitViewController()
        modalViewController.onSave = { self.collectionView.reloadData() }
        self.present(modalViewController, animated: true, completion: nil)
    }    
}

//MARK: Collection Data Source
extension HabitsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            let store = HabitsStore.shared
            return store.habits.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell: ProgressCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: ProgressCollectionViewCell.self),
                for: indexPath) as! ProgressCollectionViewCell
            cell.setupProgressValue()
            return cell
        } else {
            let cell: HabitCollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: String(describing: HabitCollectionViewCell.self),
                for: indexPath) as! HabitCollectionViewCell
            let store = HabitsStore.shared
            cell.habit = store.habits[indexPath.item]
            cell.onCheked = { self.collectionView.reloadData() }
            return cell
        }
    }
}

//MARK: Collection Layout
extension HabitsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthSize = collectionView.bounds.width - 16 * 2
        let heightSize:CGFloat = indexPath.section == 0 ? 60 : 130
        return CGSize(width: widthSize, height: heightSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 22, left: 16, bottom: 9, right: 16)
        } else {
            return UIEdgeInsets(top: 9, left: 16, bottom: 22, right: 16)
        }
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 12
    }
}

//MARK Collection Delegate
extension HabitsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if indexPath.section == 1 {
            let habitDetailsViewController = HabitDetailsViewController()
            habitDetailsViewController.habit = (collectionView.cellForItem(at: indexPath) as! HabitCollectionViewCell).habit
            habitDetailsViewController.onSave = { self.collectionView.reloadData() }
            habitDetailsViewController.onDelete = {
                self.navigationController?.popViewController(animated: true)
                self.collectionView.reloadData()
            }
            navigationController?.pushViewController(habitDetailsViewController, animated: true)            
        }
    }
}

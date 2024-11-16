//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//
import Foundation
import UIKit

protocol TaskListViewInput: AnyObject {
    func showTasks(_ tasks: [TaskEntity])
}

class TaskListViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: TaskListPresenterInput!
    private var tasks: [TaskEntity] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        return tableView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        label.text = "Задачи"
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.searchTextField.backgroundColor = UIColor(named: "SearchBar")
        // Изменяем режим рендеринга для изображения микрофона
        if let micImage = UIImage(systemName: "mic.fill")?.withRenderingMode(.alwaysTemplate) {
            searchBar.setImage(micImage, for: .bookmark, state: .normal)
        }

        searchBar.showsBookmarkButton = true

        return searchBar
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = UIColor(named: "CustomYellow")
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false // Убедитесь, что это установлено в false
        return label
    }()
    
    private let toolbar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ToolBar")
        view.translatesAutoresizingMaskIntoConstraints = false // Убедитесь, что это установлено в false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TaskListPresenter()
        presenter.view = self
        setupUI()
        presenter.loadTasks()
        tableView.reloadData()
    }

    private func setupUI() {
        navigationItem.titleView = titleLabel
        view.backgroundColor = .black
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(toolbar)
        
        // Добавляем метку и кнопку к нижнему бару
        toolbar.addSubview(taskCountLabel)
        toolbar.addSubview(addButton)
        
        if let textField = searchBar.value(forKey: "searchTextField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: "Поиск",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
            if let searchIcon = textField.leftView as? UIImageView {
                searchIcon.tintColor = .gray
            }
        }
        
        tableView.separatorColor = .white
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .gray
        searchBar.delegate = self
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 83),
            
            taskCountLabel.centerYAnchor.constraint(equalTo: toolbar.topAnchor, constant: 30),
            taskCountLabel.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor), // Центр по горизонтали
            
            addButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -20),
            addButton.centerYAnchor.constraint(equalTo: toolbar.topAnchor, constant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func addButtonTapped() {
        let taskDetailVC = TaskDetailViewController()
        taskDetailVC.presenter = TaskDetailPresenter()
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTask = tasks[indexPath.row]
        presenter.navigateToTaskDetail(with: selectedTask)
    }
}

// MARK: - TaskListViewInput
extension TaskListViewController: TaskListViewInput {
    func showTasks(_ tasks: [TaskEntity]) {
        self.tasks = tasks
        let taskCountText = tasks.count == 1 ? "1 Задача" : "\(tasks.count) Задачь"
        taskCountLabel.text = taskCountText
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearchBarDelegate
extension TaskListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Реализуйте логику поиска в задачах (фильтрация массива задач)
    }
}

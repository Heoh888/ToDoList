//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation
import UIKit
import Combine

protocol TaskListViewInput: AnyObject {
    func showTasks(_ tasks: [TaskEntity])
}

class TaskListViewController: UIViewController, UISearchBarDelegate, UIContextMenuInteractionDelegate {
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var addButton: UIButton = {
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
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let toolbar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ToolBar")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TaskListPresenter()
        presenter.view = self
        setupUI()
        presenter.fetchTasksFromNetwork()
        observeSearchTextChanges()
        tableView.reloadData()
        
        // Подписка на уведомления
        NotificationCenter.default.addObserver(self, selector: #selector(tasksDidChange),
                                               name: .tasksDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchTasksFromLocalStorage()
        tableView.reloadData()
    }
    
    @objc private func tasksDidChange() {
        presenter.fetchTasksFromLocalStorage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(toolbar)
        //         Добавляем метку и кнопку к нижнему бару
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
        
        tableView.separatorColor = .gray
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
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
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
            taskCountLabel.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -20),
            addButton.centerYAnchor.constraint(equalTo: toolbar.topAnchor, constant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func observeSearchTextChanges() {
        // Подписка на изменения текста в UISearchBar
        let textPublisher = NotificationCenter
            .default
            .publisher(for: UISearchTextField.textDidChangeNotification, object: searchBar.searchTextField)
            .map { ($0.object as? UISearchTextField)?.text }
            .compactMap { $0 }
        
        textPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] searchText in
                self?.presenter.searchTasks(searchText)
            })
            .store(in: &cancellables)
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell {
            let task = tasks[indexPath.row]
            cell.configure(with: task)
            // Создаем интеракцию для контекстного меню
            let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
            cell.addInteraction(contextMenuInteraction)
            return cell
        } else {
            fatalError("Expected TaskCell, but got a different cell type or nil.")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true)
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedTask = tasks[indexPath.row]
        presenter.navigateToTaskDetail(with: selectedTask)
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let indexPath = tableView.indexPathForRow(at: tableView.convert(location, from: interaction.view))
        guard let rowIndex = indexPath?.row else { return nil }
        // Представляем UIActivityViewController
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { [self] in
            let previewViewController = ContextMenuViewController()
            previewViewController.titleText = tasks[rowIndex].title
            previewViewController.descriptionText = tasks[rowIndex].descriptionText
            previewViewController.creationDate = tasks[rowIndex].creationDate?.formatDate()
            return previewViewController
        }, actionProvider: { _ in
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.presenter.navigateToTaskDetail(with: self.tasks[rowIndex])
            }
            let activityViewController = UIActivityViewController(activityItems: ["Поделиться: \(self.tasks[rowIndex].title)"],
                                                                  applicationActivities: nil)
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "export")) { _ in
                self.present(activityViewController, animated: true, completion: nil)
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "trash")) { _ in
                self.presenter.deleteTask(with: self.tasks[rowIndex].id)
            }
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        })
        return configuration
    }
}

// MARK: - TaskListViewInput
extension TaskListViewController: TaskListViewInput {
    func showTasks(_ tasks: [TaskEntity]) {
        self.tasks = tasks
        let taskCountText = tasks.count == 1 ? "1 Задача" : "\(tasks.count) Задач"
        taskCountLabel.text = taskCountText
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

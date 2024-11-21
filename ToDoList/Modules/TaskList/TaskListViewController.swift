//
//  TaskListViewController.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import Foundation
import UIKit
import Combine

/// Протокол TaskListViewInput служит для отображения списка задач и их взаимодействия в View.
protocol TaskListViewInput: AnyObject {
    func showTasks(_ tasks: [TaskEntity])
    var tasks: [TaskEntity] { get set }
}

/// Контроллер, отвечающий за отображение списка задач.
class TaskListViewController: UIViewController, UISearchBarDelegate, UIContextMenuInteractionDelegate {
  
    // MARK: - Свойства
    var presenter: TaskListPresenterInput! // Презентер для управления логикой контроллера
    var tasks: [TaskEntity] = [] // Хранит массив задач

    // Создание таблицы для отображения задач
    private let taskTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        return tableView
    }()
  
    // Создание метки заголовка
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textColor = .white
        label.text = "Задачи"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    // Создание строки поиска
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Поиск"
        searchBar.searchTextField.backgroundColor = UIColor(named: "SearchBar")
        
        // Изменяем режим рендеринга для изображения микрофона
        if let microphoneImage = UIImage(systemName: "mic.fill")?.withRenderingMode(.alwaysTemplate) {
            searchBar.setImage(microphoneImage, for: .bookmark, state: .normal)
        }
      
        searchBar.showsBookmarkButton = true
        return searchBar
    }()
  
    // Создание кнопки для добавления новой задачи
    private lazy var addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.backgroundColor = .clear
        button.tintColor = UIColor(named: "CustomYellow")
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
  
    // Создание метки для отображения количества задач
    private let taskCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
  
    // Создание нижней панели инструментов
    private let toolbar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ToolBar")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
  
    // Хранит отменяемые подписки для Combine
    private var cancellables = Set<AnyCancellable>()
  
    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = TaskListPresenter()
        presenter.view = self
        setupUI()
        presenter.fetchTasksFromNetwork()
        observeSearchTextChanges()
        taskTableView.reloadData()
        
        // Подписка на уведомления о изменении задач
        NotificationCenter.default.addObserver(self, selector: #selector(tasksDidChange),
                                                 name: .tasksDidChange, object: nil)
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.fetchTasksFromLocalStorage()
        taskTableView.reloadData()
    }
  
    /// Метод для обработки уведомлений о изменении задач
    @objc private func tasksDidChange() {
        presenter.fetchTasksFromLocalStorage()
    }
  
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
  
    /// Настройка пользовательского интерфейса
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(taskTableView)
        view.addSubview(toolbar)
      
        // Добавляем метку и кнопку к нижнему бару
        toolbar.addSubview(taskCountLabel)
        toolbar.addSubview(addTaskButton)

        // Настройка поля для поиска
        if let textField = searchBar.value(forKey: "searchTextField") as? UITextField {
            textField.attributedPlaceholder = NSAttributedString(
                string: "Поиск",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
            if let searchIcon = textField.leftView as? UIImageView {
                searchIcon.tintColor = .gray
            }
        }
      
        taskTableView.separatorColor = .gray
        taskTableView.backgroundColor = .black
        taskTableView.dataSource = self
        taskTableView.delegate = self
      
        searchBar.barTintColor = .black
        searchBar.searchTextField.textColor = .gray
        searchBar.delegate = self
      
        setupConstraints()
    }
  
    /// Настройка ограничений для пользовательского интерфейса
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
          
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
          
            taskTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            taskTableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            taskTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            taskTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
          
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 83),
          
            taskCountLabel.centerYAnchor.constraint(equalTo: toolbar.topAnchor, constant: 30),
            taskCountLabel.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
          
            addTaskButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -20),
            addTaskButton.centerYAnchor.constraint(equalTo: toolbar.topAnchor, constant: 30),
            addTaskButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
  
    /// Метод для отслеживания изменений текста в строке поиска
    private func observeSearchTextChanges() {
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
  
    /// Метод, срабатывающий при нажатии кнопки добавления задачи
    @objc private func addButtonTapped() {
        let taskDetailVC = TaskDetailViewController()
        taskDetailVC.presenter = TaskDetailPresenter()
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}

// MARK: - extension TaskListViewController
extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Метод возвращает количество строк для отображения в заданном разделе таблицы.
    /// - Parameters:
    ///   - tableView: Таблица, для которой требуется количество строк.
    ///   - section: Раздел таблицы.
    /// - Returns: Количество задач, отображаемых в таблице.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
  
    /// Настраивает ячейку для отображения в таблице.
    /// - Parameters:
    ///   - tableView: Таблица, в которой отображается ячейка.
    ///   - indexPath: Индексная дорожка, определяющая ячейку.
    /// - Returns: Настроенная ячейка с задачей.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell {
            let task = tasks[indexPath.row] // Получаем задачу по индексу
            cell.configure(with: task) // Конфигурируем ячейку
            
            // Создаем интеракцию для контекстного меню
            let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
            cell.addInteraction(contextMenuInteraction)
            return cell
        } else {
            fatalError("Expected TaskCell, but got a different cell type or nil.") // Вызывает ошибку, если тип ячейки неправильный
        }
    }
  
    /// Метод обрабатывает выбор ячейки пользователем.
    /// - Parameters:
    ///   - tableView: Таблица, из которой выбрана ячейка.
    ///   - indexPath: Индексная дорожка выбранной ячейки.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchBar.endEditing(true) // Закрываем строку поиска
        tableView.deselectRow(at: indexPath, animated: true) // Убираем выделение ячейки
        let selectedTask = tasks[indexPath.row] // Получаем выбранную задачу
        presenter.navigateToTaskDetail(with: selectedTask) // Переходим к деталям выбранной задачи
    }
    
    /// Метод обрабатывает создание контекстного меню для ячейки.
    /// - Parameters:
    ///   - interaction: Интеракция с контекстным меню.
    ///   - location: Позиция, где было вызвано меню.
    /// - Returns: Конфигурация контекстного меню.
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction,
                                configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let indexPath = taskTableView.indexPathForRow(at: taskTableView.convert(location, from: interaction.view)) // Получаем индекс ячейки
        guard let rowIndex = indexPath?.row else { return nil } // Если нет, ничего не возвращаем
        
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: { [self] in
            let previewViewController = ContextMenuViewController() // Создаем контроллер предварительного просмотра
            previewViewController.titleText = tasks[rowIndex].title // Устанавливаем заголовок задачи
            previewViewController.descriptionText = tasks[rowIndex].descriptionText // Устанавливаем описание задачи
            previewViewController.creationDate = tasks[rowIndex].creationDate?.formatDate() // Устанавливаем дату создания задачи
            return previewViewController
        }, actionProvider: { _ in
            // Создаем действия для контекстного меню
            let editAction = UIAction(title: "Редактировать", image: UIImage(named: "edit")) { _ in
                self.presenter.navigateToTaskDetail(with: self.tasks[rowIndex]) // Переход к редактированию задачи
            }
            let activityViewController = UIActivityViewController(activityItems: ["Поделиться: \(self.tasks[rowIndex].title)"],
                                                                  applicationActivities: nil) // Поделиться задачей
            let shareAction = UIAction(title: "Поделиться", image: UIImage(named: "export")) { _ in
                self.present(activityViewController, animated: true, completion: nil)
            }
            let deleteAction = UIAction(title: "Удалить", image: UIImage(named: "trash")) { _ in
                self.presenter.deleteTask(with: self.tasks[rowIndex].id) // Удаление задачи
            }
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction]) // Возвращаем меню с действиями
        })
        
        return configuration // Возвращаем конфигурацию меню
    }
}

extension TaskListViewController: TaskListViewInput {
    
    /// Метод для отображения задач в списке.
    /// - Parameters:
    ///   - tasks: Список задач для отображения.
    func showTasks(_ tasks: [TaskEntity]) {
        self.tasks = tasks // Обновление списка задач
        let taskCountText = tasks.count == 1 ? "1 Задача" : "\(tasks.count) Задач" // Подсчет и форматирование текста
        taskCountLabel.text = taskCountText // Обновляем метку с количеством задач
        DispatchQueue.main.async {
            self.taskTableView.reloadData() // Перезагрузить таблицу на главном потоке
        }
    }
}

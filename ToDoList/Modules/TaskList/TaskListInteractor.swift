//
//  TaskListInteractor.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//
import Foundation

/// Протокол `TaskListInteractorInput` описывает интерфейс для взаимодействия с задачами.
/// Он определяет обязательные методы для получения задач из сети и локального хранилища,
/// а также для удаления конкретной задачи по идентификатору.
protocol TaskListInteractorInput {
    var networkService: NetworkServiceInput? { get set } // Сервис для работы с сетью
    func fetchTasksFromNetwork() // Получение задач из сети
    func fetchTasksFromLocalStorage() // Получение задач из локального хранилища
    func deleteTask(with id: Int16) // Удаление задачи по идентификатору
}

/// Класс `TaskListInteractor` реализует протокол `TaskListInteractorInput`
/// и управляет получением, сохранением и удалением задач.
class TaskListInteractor: TaskListInteractorInput {
    
    var presenter: TaskListPresenterInput? // Презентер для отправки данных
    var networkService: NetworkServiceInput? // Сервис для работы с сетью
    var localStorage: StorageManagerInput? // Локальное хранилище для задач
    private let userDefaults = UserDefaults.standard // Стандартное хранилище пользовательских данных
    private let operationQueue = OperationQueue() // Очередь операций для обработки задач
     
    /// Инициализирует `TaskListInteractor`.
    /// - Parameters:
    ///   - presenter: Презентер для отображения задач.
    ///   - networkService: Сервис для работы с сетью, по умолчанию создается новый экземпляр.
    ///   - localStorage: Локальное хранилище задач, по умолчанию используется общий экземпляр.
    init(presenter: TaskListPresenterInput? = nil,
         networkService: NetworkServiceInput? = NetworkService(),
         localStorage: StorageManagerInput? = StorageManager.shared) {
        self.networkService = networkService
        self.presenter = presenter
        self.localStorage = localStorage
    }

    /// Получает задачи из сети.
    func fetchTasksFromNetwork() {
        // Проверяем, был ли уже загружен первый раз данные
        if let firstLaunch = userDefaults.string(forKey: "firstLaunch") {
            print(firstLaunch)
        } else {
            // Запускаем асинхронный запрос на получение задач
            DispatchQueue.global(qos: .background).async {
                guard let networkService = self.networkService else { return }
                networkService.fetchTasks { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let taskList):
                        self.userDefaults.set("Данные были успешно загружены", forKey: "firstLaunch") // Логирование успешного запуска
                        self.validateTasksUniqueness(taskList: taskList) // Валидация уникальности задач
                    case .failure(let error):
                        print("Ошибка \(error.localizedDescription)") // Логирование ошибки
                    }
                }
            }
        }
    }
     
    /// Удаляет задачу по идентификатору.
    /// - Parameter id: Идентификатор задачи, которую необходимо удалить.
    func deleteTask(with id: Int16) {
        guard let localStorage = localStorage else { return }
        localStorage.deleteTask(with: id) // Удаляем задачу из локального хранилища
    }
     
    /// Получает задачи из локального хранилища и передает их презентеру.
    func fetchTasksFromLocalStorage() {
        guard let presenter = presenter, let localStorage = localStorage else { return }
        let localTasks = localStorage.fetchTasks() // Получаем задачи из локального хранилища
        let result = convertData(data: localTasks) // Конвертируем данные
        presenter.presentTasks(result) // Отправляем задачи презентеру
    }

    /// Сохраняет задачи в локальном хранилище.
    /// - Parameter tasks: Массив задач для сохранения.
    func saveTasks(_ tasks: [TaskEntity]) {
        guard let localStorage = localStorage else { return }
        let localTasks = localStorage.fetchTasks() // Получаем существующие задачи
        let tasksFromLocalStorage = self.convertData(data: localTasks) // Конвертируем существующие задачи
        let operation = BlockOperation { [weak self] in
            print("ccewcewcewcwc")
            guard let self = self else { return }
            print("32223232")
            for task in tasks {
                localStorage.createTask(
                    with: task.id,
                    title: task.title,
                    descriptionText: task.descriptionText,
                    creationDate: task.creationDate,
                    isCompleted: task.isCompleted
                ) // Сохраняем каждую задачу в локальное хранилище
            }
            
            OperationQueue.main.addOperation {
                guard let presenter = self.presenter else { return }
                let allTasks = tasks + tasksFromLocalStorage // Объединяем новые и существующие задачи
                print(allTasks)
                presenter.presentTasks(allTasks) // Отправляем объединенные задачи презентеру
            }
        }
        operationQueue.addOperation(operation) // Добавляем операцию в очередь
    }

    /// Проверяет уникальность задач из списка переданных задач.
    /// - Parameter taskList: Список задач для проверки уникальности.
    private func validateTasksUniqueness(taskList: TaskListEntity) {
        guard let localStorage = localStorage else { return }
        let localTasks = localStorage.fetchTasks()
        let tasksFromLocalStorage = convertData(data: localTasks)
        let existingTaskIds = Set(tasksFromLocalStorage.map { $0.id }) // Получаем уникальные идентификаторы существующих задач
        let uniqueTasks = taskList.todos.filter { !existingTaskIds.contains($0.id) } // Фильтруем уникальные задачи
        saveTasks(uniqueTasks) // Сохраняем уникальные задачи
    }

    /// Конвертирует данные входных задач в задачи сущности.
    /// - Parameter data: Массив входных задач.
    /// - Returns: Массив сущностей задач.
    internal func convertData(data: [TaskInput]) -> [TaskEntity] {
        return data.map { TaskEntity(id: $0.id,
                                      title: $0.title,
                                      descriptionText: $0.descriptionText,
                                      creationDate: $0.creationDate,
                                      isCompleted: $0.isCompleted) }
    }
}

//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import UIKit

/// Протокол для ввода данных в экран деталей задачи.
protocol TaskDetailViewInput: AnyObject {
    /// Функция для отображения деталей задачи.
    func showTaskDetails()
}

/// Контроллер для отображения деталей задачи.
class TaskDetailViewController: UIViewController {

    // MARK: - Свойства
    var presenter: TaskDetailPresenterInput!
    var task: TaskEntity?

    /// Кнопка для сохранения задачи.
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Сохранить", style: .plain,
                                     target: self,
                                     action: #selector(saveButtonTapped))
        return button
    }()

    /// Выбор даты.
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        picker.tintColor = .black
        picker.accessibilityIgnoresInvertColors = false
        return picker
    }()

    /// Прокручиваемое представление.
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .black
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()

    /// Поле ввода заголовка.
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.textContainer.maximumNumberOfLines = 1
        textView.font = UIFont.systemFont(ofSize: 34)
        textView.textColor = .white
        textView.backgroundColor = .black
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    /// Метка для отображения даты.
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Плейсхолдер для заголовка.
    private let placeholderTitle: UILabel = {
        let label = UILabel()
        label.text = "Сформулируй заголовок для задачи..."
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    /// Поле ввода описания задачи.
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    /// Плейсхолдер для описания задачи.
    private let placeholderDescription: UILabel = {
        let label = UILabel()
        label.text = "Расскажи подробнее о сути твоей задачи..."
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Жизненный цикл
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        setupUI()
        showTaskDetails()
    }

    // MARK: - UI Setup
    private func setupUI() {
        navigationController?.navigationBar.tintColor = UIColor(named: "CustomYellow")
        navigationController?.navigationBar.topItem?.title = "Назад"
        view.backgroundColor = .black
        view.addSubview(scrollView)
        scrollView.addSubview(titleTextView)
        view.addSubview(placeholderTitle)
        view.addSubview(datePicker)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(placeholderDescription)
        setupConstraints()
    }

    // MARK: - Констрейнты
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            scrollView.heightAnchor.constraint(equalToConstant: 70),

            titleTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            titleTextView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            titleTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            titleTextView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            titleTextView.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),

            placeholderTitle.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor, constant: 5),
            placeholderTitle.centerYAnchor.constraint(equalTo: titleTextView.centerYAnchor),

            datePicker.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: -10),
            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            dateLabel.centerYAnchor.constraint(equalTo: datePicker.centerYAnchor),
            dateLabel.centerXAnchor.constraint(equalTo: datePicker.centerXAnchor),

            descriptionTextView.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            placeholderDescription.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor, constant: 5),
            placeholderDescription.topAnchor.constraint(equalTo: descriptionTextView.topAnchor, constant: 8)
        ])
    }

    /// Функция нажатия кнопки сохранения.
    @objc private func saveButtonTapped() {
        // Проверяем, если задача существует
        if let existingTask = task {
            let updatedTask = TaskEntity(id: existingTask.id,
                                         title: titleTextView.text,
                                         descriptionText: descriptionTextView.text,
                                         creationDate: datePicker.date,
                                         isCompleted: existingTask.isCompleted)
            presenter.updateTask(updatedTask)
        } else {
            guard let newId = UUID().uuidToInt16() else { return }
            let newTask = TaskEntity(id: newId,
                                     title: titleTextView.text,
                                     descriptionText: descriptionTextView.text,
                                     creationDate: datePicker.date,
                                     isCompleted: false)
            presenter.createTask(newTask)
        }
        navigationController?.popViewController(animated: true)
    }

    /// Обработка изменения даты в datePicker.
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // Установите нужный стиль
        dateLabel.text = formatter.string(from: sender.date)

        // Проверка состояния кнопки сохранения
        checkSaveButtonState()
    }

    /// Проверка состояния кнопки сохранения на основе текста в полях.
    private func checkSaveButtonState() {
        let isTitleChanged = titleTextView.text != task?.title && task != nil
        let isDescriptionChanged = descriptionTextView.text != task?.descriptionText && task != nil
        let isDateChanged = !(datePicker.date == task?.creationDate)

        // Кнопка активна, если изменено описание, заголовок или изменена дата и заголовок не пустой
        saveButton.isEnabled = isDescriptionChanged || isTitleChanged || (isDateChanged && !titleTextView.text.isEmpty)
        navigationItem.rightBarButtonItem = saveButton
    }
}

// MARK: - Реализация TaskDetailViewInput
extension TaskDetailViewController: TaskDetailViewInput {
    func showTaskDetails() {
        guard let existingTask = task else {
            dateLabel.text = Date().formatDate()
            return
        }
        datePicker.date = existingTask.creationDate ?? Date()
        dateLabel.text = (existingTask.creationDate ?? Date()).formatDate()
        placeholderTitle.text = ""
        placeholderDescription.text = ""
        titleTextView.text = existingTask.title
        descriptionTextView.text = existingTask.descriptionText
    }
}

// MARK: - UITextViewDelegate
extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkPlaceholder(for: titleTextView, placeholderLabel: placeholderTitle)
        checkPlaceholder(for: descriptionTextView, placeholderLabel: placeholderDescription)

        // Проверяем состояние кнопки сохранения
        checkSaveButtonState()
    }

    /// Проверка видимости плейсхолдера.
    private func checkPlaceholder(for textView: UITextView, placeholderLabel: UILabel) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

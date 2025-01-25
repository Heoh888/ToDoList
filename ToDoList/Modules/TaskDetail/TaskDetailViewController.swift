//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import UIKit
import SwiftUI

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
    
    private var hostingController: UIHostingController<DatePickerView>?

    /// Кнопка для сохранения задачи.
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Сохранить", style: .plain,
                                     target: self,
                                     action: #selector(saveButtonTapped))
        return button
    }()
    
    private var blurEffectView: UIVisualEffectView?
    
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
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.textAlignment = .left
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
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(placeholderDescription)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDateLabelTap))
        dateLabel.addGestureRecognizer(tapGesture)
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
            
            dateLabel.centerYAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 0),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
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
                                         creationDate: dateLabel.text?.toDate() ?? Date(),
                                         isCompleted: existingTask.isCompleted)
            presenter.updateTask(updatedTask)
        } else {
            guard let newId = UUID().uuidToInt16() else { return }
            let newTask = TaskEntity(id: newId,
                                     title: titleTextView.text,
                                     descriptionText: descriptionTextView.text,
                                     creationDate: Date(),
                                     isCompleted: false)
            presenter.createTask(newTask)
        }
        navigationController?.popViewController(animated: true)
    }
    
    /// Обработка изменения даты в datePicker.
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        dateLabel.text = sender.date.formatDate()
        // Проверка состояния кнопки сохранения
        checkSaveButtonState()
    }
    
    @objc private func handleDateLabelTap() {
        if blurEffectView == nil && hostingController == nil {
            showDatePickerWithBlurEffect()
        } else {
            hideDatePickerWithBlurEffect()
            checkSaveButtonState()
        }
    }

    private func showDatePickerWithBlurEffect() {
        // Создаем и добавляем эффект размытия
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDateLabelTap))
        blurView.addGestureRecognizer(tapGesture)
        view.addSubview(blurView)
        blurEffectView = blurView

        // Создаем SwiftUI View для выбора даты
        let swiftUIView = DatePickerView(dateString: dateLabel.text ?? Date().formatDate())
        hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController!)
        hostingController!.view.layer.cornerRadius = 20
        view.addSubview(hostingController!.view)
        hostingController?.didMove(toParent: self)

        // Устанавливаем констрейнты для SwiftUI View
        hostingController!.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController!.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hostingController!.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func hideDatePickerWithBlurEffect() {
        // Удаляем эффект размытия
        blurEffectView?.removeFromSuperview()
        blurEffectView = nil

        // Удаляем представление и обновляем дату
        if let hostingView = hostingController?.view {
            dateLabel.text = hostingController?.rootView.viewModel.getDate()
            hostingView.removeFromSuperview()
            hostingController?.removeFromParent()
            hostingController = nil
        }
    }
    
    /// Проверка состояния кнопки сохранения на основе текста в полях.
    private func checkSaveButtonState() {
        let isTitleChanged = titleTextView.text != task?.title && task != nil
        let isDescriptionChanged = descriptionTextView.text != task?.descriptionText && task != nil
        let isDateChanged = !(dateLabel.text?.toDate() == task?.creationDate) && (dateLabel.text != "Установите дату")
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
        dateLabel.text = existingTask.creationDate?.formatDate() ?? "Установите дату"
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

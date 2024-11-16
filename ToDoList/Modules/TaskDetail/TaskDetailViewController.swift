//
//  TaskDetailViewController.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import UIKit

protocol TaskDetailViewInput: AnyObject {
    func showTaskDetails()
}

class TaskDetailViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: TaskDetailPresenterInput!
    var task: TaskEntity?
    
    private let rightButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(rightButtonTapped))
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .clear
        picker.tintColor = .black
        picker.accessibilityIgnoresInvertColors = false
        return picker
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .black
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
    
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
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeholderTitle: UILabel = {
        let label = UILabel()
        label.text = "Сформулируй заголовок для задачи..."
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let placeholderDescription: UILabel = {
        let label = UILabel()
        label.text = "Расскажи подробнее о сути твоей задачи..."
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        setupUI()
        showTaskDetails()
    }
    
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
        
        // Добавление целевого действия для datePicker
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        
        setupConstraints()
    }
    
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
    
    @objc private func rightButtonTapped() {
        print("Правый кнопка нажата")
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // Установите нужный стиль
        dateLabel.text = formatter.string(from: sender.date)
        
        let isTitleChanged = !titleTextView.text.isEmpty
        let isDescriptionChanged = !descriptionTextView.text.isEmpty
        
        rightButton.isEnabled = isTitleChanged || isDescriptionChanged
        navigationItem.rightBarButtonItem = rightButton
    }
}

extension TaskDetailViewController: TaskDetailViewInput {
    func showTaskDetails() {
        guard let task = task else {
            dateLabel.text = "Задать дату"
            return
        }
        placeholderTitle.text = ""
        placeholderDescription.text = ""
        dateLabel.text = DateFormatter.localizedString(from: task.creationDate ?? Date(), dateStyle: .short, timeStyle: .none)
        titleTextView.text = task.title
        descriptionTextView.text = task.descriptionText
    }
}

extension TaskDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        checkPlaceholder(for: titleTextView, placeholderLabel: placeholderTitle)
        checkPlaceholder(for: descriptionTextView, placeholderLabel: placeholderDescription)
        
        let isTitleChanged = !titleTextView.text.isEmpty
        let isDescriptionChanged = !descriptionTextView.text.isEmpty
        
        rightButton.isEnabled = isTitleChanged || isDescriptionChanged
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func checkPlaceholder(for textView: UITextView, placeholderLabel: UILabel) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

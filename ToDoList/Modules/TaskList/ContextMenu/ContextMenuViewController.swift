//
//  ContextMenuViewController.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 19.11.2024.
import UIKit

/// `ContextMenuViewController` - контроллер, который отображает контекстное меню с заголовком, описанием и датой создания.
class ContextMenuViewController: UIViewController {
    
    // Переменные для хранения текста заголовка, описания и даты создания
    var titleText: String?
    var descriptionText: String?
    var creationDate: String?
    
    // Метки для отображения информации
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    /// Настройка пользовательского интерфейса
    private func setupUI() {
        // Установка фона для представления
        view.backgroundColor = UIColor(named: "SearchBar")
        
        // Настройка заголовка
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel) // Добавляем заголовок на представление

        // Настройка описания
        descriptionLabel.text = descriptionText
        descriptionLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.numberOfLines = 2 // Позволяет многострочное отображение
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel) // Добавляем описание на представление

        // Настройка даты создания
        dateLabel.text = creationDate
        dateLabel.textColor = .lightGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateLabel) // Добавляем дату на представление

        // Установка ограничений для меток
        setupConstraints()

        // Установка предпочтительного размера контента для представления
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 106)
    }

    /// Метод для установки ограничений для меток
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Ограничения для заголовка
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            // Ограничения для описания
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            // Ограничения для даты создания
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

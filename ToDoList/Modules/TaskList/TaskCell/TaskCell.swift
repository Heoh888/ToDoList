//
//  TaskCell.swift
//  ToDoList
//
//  Created by Алексей Ходаков on 15.11.2024.
//

import UIKit

class TaskCell: UITableViewCell {

    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray // Цвет текста
        label.numberOfLines = 0 // Позволяет тексту занимать много строк
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()

    private let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Properties
    var task: TaskEntity?

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addGestureToStatusImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(statusImageView)

        setupConstraints()

        // Основные настройки ячейки
        selectionStyle = .none // Убираем выделение ячейки
        contentView.backgroundColor = .black // Фон ячейки
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Constraints для statusImageView
            statusImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusImageView.centerYAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            statusImageView.widthAnchor.constraint(equalToConstant: 24),
            statusImageView.heightAnchor.constraint(equalToConstant: 24),

            // Constraints для titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 7),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),

            // Constraints для descriptionLabel
            descriptionLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 7),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20), // Убедитесь, что есть минимальная высота

            // Constraints для dateLabel
            dateLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: 0),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    private func addGestureToStatusImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(statusImageTapped))
        statusImageView.isUserInteractionEnabled = true
        statusImageView.addGestureRecognizer(tapGesture)
    }

    @objc private func statusImageTapped() {
        guard let task = task else { return }
        task.isCompleted.toggle() // Меняем состояние isCompleted
        configure(with: task) // Обновляем изображение
        // Если необходимо, уведомите делегата или школу о том, что задача была обновлена
    }

    // MARK: - Configuration
    func configure(with task: TaskEntity?) {
        guard let task = task else { return }
        task.descriptionText = "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку!"
        task.creationDate = Date()

        if let description = task.descriptionText, !description.isEmpty {
            descriptionLabel.text = description
        }
        
        self.task = task
        titleLabel.attributedText = task.isCompleted ?
        NSAttributedString(string: task.title ?? "", attributes: [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.lightGray
        ]) :
        NSAttributedString(string: task.title ?? "", attributes: [
            .foregroundColor: UIColor.white
        ])
        descriptionLabel.attributedText = task.isCompleted ?
        NSAttributedString(string: task.descriptionText ?? "", attributes: [
            .foregroundColor: UIColor.lightGray
        ]):
        NSAttributedString(string: task.descriptionText ?? "", attributes: [
            .foregroundColor: UIColor.white
        ])
        
        dateLabel.text = formatDate(task.creationDate) // Предполагаем, что у вас есть поле для даты создания
        statusImageView.tintColor = .yellow
        statusImageView.image = task.isCompleted ? UIImage(named: "isCompleted") : UIImage(named: "notCompleted")
    }

    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy" // Задайте нужный формат
        return dateFormatter.string(from: date)
    }
}

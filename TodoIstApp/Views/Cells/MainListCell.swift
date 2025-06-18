//
//  CustomCell.swift
//  TodoIstApp
//
//  Created by Нурик  Генджалиев   on 16.06.2025.
//

import UIKit
class MainListCell: UITableViewCell {
    
    let checkmarkButton: UIButton = {
        let button = UIButton()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .light, scale: .default)
        
        let circleImage = UIImage(systemName: "circle", withConfiguration: symbolConfig)
        let checkmarkImage = UIImage(systemName: "checkmark.circle", withConfiguration: symbolConfig)
        
        button.setImage(circleImage, for: .normal)
        button.setImage(checkmarkImage, for: .selected)
        button.tintColor = .systemYellow
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(secondaryLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(separatorView)
        
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            checkmarkButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            checkmarkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 32),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.topAnchor.constraint(equalTo: checkmarkButton.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            secondaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            secondaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            secondaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configure(with todoItem: ToDoItem) {
        
        if todoItem.isCompleted == true {
            let attributedString = NSMutableAttributedString(string: todoItem.title ?? "")
            attributedString.addAttribute(
                .strikethroughStyle,
                value: NSUnderlineStyle.single.rawValue,
                range: NSRange(location: 0, length: attributedString.length)
            )
            attributedString.addAttribute(
                .strikethroughColor,
                value: UIColor.gray,
                range: NSRange(location: 0, length: attributedString.length)
            )
            attributedString.addAttribute(
                .foregroundColor,
                value: UIColor.gray,
                range: NSRange(location: 0, length: attributedString.length)
            )
            titleLabel.attributedText = attributedString
            checkmarkButton.isSelected = true
        }
        
        if todoItem.isCompleted == false {
            titleLabel.text = todoItem.title ?? ""
            checkmarkButton.isSelected = false
        }
        
        secondaryLabel.text = todoItem.toDoItem
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: todoItem.creationDate ?? Date())
    }
}

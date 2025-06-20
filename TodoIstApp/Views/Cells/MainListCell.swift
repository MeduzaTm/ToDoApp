//
//  CustomCell.swift
//  TodoIstApp
//
//  Created by Нурик  Генджалиев   on 16.06.2025.
//

import UIKit
import SnapKit

class MainListCell: UITableViewCell {
        
    let circleImage = UIImageView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = false
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
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 4
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(secondaryLabel)
        stackView.addArrangedSubview(dateLabel)
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(circleImage)
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)
        
        circleImage.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.width.height.equalTo(32)
        }
        
        stackView.snp.makeConstraints {
            $0.left.equalTo(circleImage.snp.right).offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        separatorView.snp.makeConstraints {
            $0.width.equalTo(0.5)
            $0.height.equalTo(10)
        }
        
        separatorView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalTo(contentView)
            $0.height.equalTo(0.5)
        }
        
        circleImage.tintColor = .systemYellow
    }
    
    func configure(with todoItem: ToDoItem, isSelected: Bool) {
        let title = todoItem.title ?? ""
        let attributedString = NSMutableAttributedString(string: title)
        
        if todoItem.isCompleted {
            attributedString.addAttributes([
                .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                .strikethroughColor: UIColor.lightGray,
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .regular)
            ], range: NSRange(location: 0, length: attributedString.length))
        } else {
            attributedString.addAttributes([
                .strikethroughStyle: 0,
                .foregroundColor: UIColor.label,
                .font: UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .medium)
            ], range: NSRange(location: 0, length: attributedString.length))
        }
        
        titleLabel.attributedText = attributedString
        circleImage.image = isSelected ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
//        if todoItem.isCompleted {
//                attributedString.addAttributes([
//                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
//                    .strikethroughColor: UIColor.lightGray,
//                    .foregroundColor: UIColor.lightGray,
//                    .font: UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .regular)
//                ], range: NSRange(location: 0, length: attributedString.length))
//                
//                circleImage.image = UIImage(systemName: "checkmark.circle")
//            } else {
//                attributedString.addAttributes([
//                    .strikethroughStyle: 0,
//                    .foregroundColor: UIColor.label,
//                    .font: UIFont.systemFont(ofSize: titleLabel.font.pointSize, weight: .medium)
//                ], range: NSRange(location: 0, length: attributedString.length))
                
//                circleImage.image = UIImage(systemName: "circle")
//            }
        secondaryLabel.text = todoItem.toDoItem

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateLabel.text = dateFormatter.string(from: todoItem.creationDate ?? Date())
        layoutIfNeeded()
    }
}

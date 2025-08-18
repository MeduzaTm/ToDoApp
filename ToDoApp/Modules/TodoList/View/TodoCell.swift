import UIKit

protocol TodoCellDelegate: AnyObject {
    func todoCellDidLongPressCircle(_ cell: TodoCell)
}

class TodoCell: UITableViewCell {
    static let identifier = "TodoCell"
    weak var delegate: TodoCellDelegate?
    
    private let circleButton = UIButton(type: .system)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        contentView.addSubview(circleButton)
        contentView.addSubview(stackView)
        contentView.addSubview(separatorView)
        
        let stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        stackViewBottomConstraint.priority = .defaultHigh
        
        circleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circleButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            circleButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            circleButton.widthAnchor.constraint(equalToConstant: 32),
            circleButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: circleButton.rightAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackViewBottomConstraint,
            stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            separatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            separatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.2)
        ])
        
        circleButton.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressCircle(_:)))
        longPress.minimumPressDuration = 0.35
        circleButton.addGestureRecognizer(longPress)
    }
    
    func configure(with viewModel: TodoCellViewModel) {
        let title = viewModel.title
        let maxLength = 20
        let trimmedTitle = title.count > maxLength ? String(title.prefix(maxLength)) + "..." : title
        let attributedString = NSMutableAttributedString(string: trimmedTitle)
        
        if viewModel.isCompleted {
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
        circleButton.tintColor = viewModel.isCompleted ? .systemYellow : .systemGray
        
        circleButton.setImage(
            UIImage(
                systemName: viewModel.isCompleted ? "checkmark.circle" : "circle",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .thin)
            ),
            for: .normal
        )
        secondaryLabel.text = viewModel.description
        secondaryLabel.textColor = viewModel.isCompleted ? .secondaryLabel : .label
        dateLabel.text = viewModel.dateString
    }

    @objc private func handleLongPressCircle(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            delegate?.todoCellDidLongPressCircle(self)
        }
    }
}

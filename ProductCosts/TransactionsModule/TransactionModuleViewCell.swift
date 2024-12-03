import UIKit

final class TransactionModuleViewCell: UITableViewCell {
    
    static let id = "TransactionModuleViewCell"
    
    struct Model {
        let amountAndCurrency: String
        let amountConvertGBP: String
    }
    
    private lazy var amountAndCurrency: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var amountConvertGBP: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.spacing = 2.0
        return view
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        backgroundColor = .systemBackground
        selectionStyle = .none
        tintColor = .systemGray
        
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with model: Model) {
        amountAndCurrency.text = model.amountAndCurrency
        amountConvertGBP.text = model.amountConvertGBP
    }
}

// MARK: - ExtensionConstrains
private extension TransactionModuleViewCell {
    func commonInit() {
        setupSubView()
        setupConstraints()
    }
    
    func setupSubView() {
        stack.addArrangedSubview(amountAndCurrency)
        stack.addArrangedSubview(amountConvertGBP)
        contentView.addSubview(stack)
        contentView.addSubview(line)
    }
    
    func setupConstraints() {
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            line.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 8),
            line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            line.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }
}

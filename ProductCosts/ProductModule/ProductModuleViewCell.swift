
import UIKit
 
final class ProductModuleViewCell: UITableViewCell {
    static let id = "ProductModuleViewCell"
    
    struct Model {
        let sku: String
        let transactionCount: String
    }
    
    private lazy var skuLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var numLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 8.0
        return view
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
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
        skuLabel.text = model.sku
        numLabel.text = model.transactionCount
    }
}

// MARK: - ExtensionConstrains
private extension ProductModuleViewCell {
    func commonInit() {
        setupSubview()
        setupConstraints()
    }
    
    func setupSubview() {
        stack.addArrangedSubview(skuLabel)
        stack.addArrangedSubview(numLabel)
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
            stack.bottomAnchor.constraint(equalTo: line.topAnchor, constant: -8),
            
            line.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 8),
            line.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            line.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            line.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            line.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale)
        ])
    }
}

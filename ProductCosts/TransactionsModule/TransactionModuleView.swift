import UIKit

final class TransactionModuleView: UIView {
    
    typealias Item = TransactionModuleViewCell.Model
    
    struct Model {
        let items: [Item]
        let totalCount: String
    }
    
    private var model: Model?
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(TransactionModuleViewCell.self, forCellReuseIdentifier: TransactionModuleViewCell.id)
        view.separatorInset = .zero
        view.tableFooterView = UIView()
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var totalCount: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        return label
    }()
    
    private let presenter: TransactionModulePresenterProtocol
    
    init(presenter: TransactionModulePresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(model: Model) {
        self.model = model
        totalCount.text = model.totalCount
        tableView.reloadData()
    }
    
    func showError() {
        print("Error")
    }
    
    func showEmpty() {
        print("Empty")
    }
    
    func startLoader() {
        print("startLoader")
    }
    
    func stopLoader() {
        print("stopLoader")
    }
}

// MARK: - UITableViewDataSource
extension TransactionModuleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model, let cell = tableView.dequeueReusableCell(withIdentifier: TransactionModuleViewCell.id) as? TransactionModuleViewCell else {
            return UITableViewCell()
        }
        let item = model.items[indexPath.row]
        let cellmodel = TransactionModuleViewCell.Model(amountAndCurrency: item.amountAndCurrency, amountConvertGBP: item.amountConvertGBP)
        cell.update(with: cellmodel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TransactionModuleView: UITableViewDelegate {
    // исправить
}


// MARK: - ExtensionConstrains
extension TransactionModuleView {
    func commonInit() {
        backgroundColor = .systemBackground
        setupConstraints()
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(totalCount)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        
        totalCount.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalCount.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            totalCount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            totalCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10),
            
            tableView.topAnchor.constraint(equalTo: totalCount.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


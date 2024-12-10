
import UIKit

final class ProductModuleView: UIView {
    typealias Item = ProductModuleViewCell.Model
    
    struct Model {
        let items: [Item]
    }
    
    private var model: Model?
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(ProductModuleViewCell.self, forCellReuseIdentifier: ProductModuleViewCell.id)
        view.separatorInset = .zero
        view.tableFooterView = UIView()
        view.backgroundColor = .systemBackground
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private let presenter: ProductModulePresenterProtocol
    
    init(presenter: ProductModulePresenterProtocol) {
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
extension ProductModuleView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model, let cell = tableView.dequeueReusableCell(withIdentifier: ProductModuleViewCell.id) as? ProductModuleViewCell else {
            return UITableViewCell()
        }
        
        let item = model.items[indexPath.row]
        let cellModel = ProductModuleViewCell.Model(sku: item.sku, transactionCount: item.transactionCount)
        cell.update(with: cellModel)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductModuleView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tapRow(index: indexPath.row)
    }
}

// MARK: - ConstraintsSubviews
private extension ProductModuleView {
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

import UIKit

protocol TransactionModuleControllerProtocol: AnyObject {
    func update(with transactions: [String], total: String)
}

final class TransactionModuleController: UIViewController, TransactionModuleControllerProtocol {
    
    private let presenter: TransactionModulePresenterProtocol
    private lazy var tableView = UITableView()
    
    private var transactions: [String] = []
    private var total: String = ""
    
    init(presenter: TransactionModulePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad() 
    }
    
    func update(with transactions: [String], total: String) {
        self.transactions = transactions
        self.total = total
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension TransactionModuleController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = transactions[indexPath.row]
        return cell
    }
    
}


// MARK: - ExtensionConstrains
extension TransactionModuleController {
    func setupUI() {
        title = "Transactions"
        setupConstraints()
        setupSubviews()
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

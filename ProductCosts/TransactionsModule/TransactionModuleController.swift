import UIKit

protocol TransactionModuleViewProtocol: AnyObject {
    func update(model: TransactionModuleView.Model)
    func showError()
    func showEmpty()
    func startLoader()
    func stopLoader()
}

final class TransactionModuleController: UIViewController {
    private let presenter: TransactionModulePresenter
    private lazy var customView = TransactionModuleView(presenter: presenter)
    
    init(presenter: TransactionModulePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.tittle
        navigationController?.navigationBar.prefersLargeTitles = true
        presenter.viewDidLoad()
    }
}

extension TransactionModuleController: TransactionModuleViewProtocol {
    func update(model: TransactionModuleView.Model) {
        customView.update(model: model)
    }
    
    func showError() {
        customView.showEmpty()
    }
    
    func showEmpty() {
        customView.showEmpty()
    }
    
    func startLoader() {
        customView.startLoader()
    }
    
    func stopLoader() {
        customView.stopLoader()
    }
}

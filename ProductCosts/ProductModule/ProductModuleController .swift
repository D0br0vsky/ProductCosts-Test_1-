import UIKit

protocol ProductModuleViewProtocol: AnyObject {
    func update(model: ProductModuleView.Model)
    func showError()
    func showEmpty()
    func startLoader()
    func stopLoader()
}

final class ProductModuleController: UIViewController {
    
    private lazy var customView = ProductModuleView(presenter: presenter)
    private let presenter: ProductModulePresenter
    
    init(presenter: ProductModulePresenter) {
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
        title = presenter.title
        navigationController?.navigationBar.prefersLargeTitles = true
        presenter.viewDidLoad()
    }
}

extension ProductModuleController: ProductModuleViewProtocol {
    func update(model: ProductModuleView.Model) {
        customView.update(model: model)
    }
    
    func showError() {
        customView.showError()
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

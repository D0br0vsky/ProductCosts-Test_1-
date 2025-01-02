import UIKit

class LoadingViewController: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let progressView = UIProgressView(progressViewStyle: .bar)
    private let statusLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }
}

// MARK: - Extension Constrains
extension LoadingViewController {
    func commonInit() {
        setupSubviews()
        setupConstraints()
        configureAppearance()
    }

    func setupSubviews() {
        view.addSubview(progressView)
        view.addSubview(statusLabel)

    }

    func setupConstraints() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 440),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 10)
        ])
        progressView.progress = 0.0
    }

    func updateProgress(_ progress: Float, status: String) {
        progressView.setProgress(progress, animated: true)
        statusLabel.text = status
    }
    
    func configureAppearance() {
        view.backgroundColor = .white
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .black
        statusLabel.textColor = .black
        statusLabel.text = "Loading..."
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 16)
    }
}

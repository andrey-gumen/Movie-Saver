import Combine
import EasyAutolayout
import UIKit

final class MainListView: UIViewController {

    // MARK: - Properties
    var viewModel: MainListViewModel!

    // MARK: Public
    // MARK: Private
    private var cancellables: Set<AnyCancellable> = []

    private let titleLabel = UILabel()
    private let movieTableView = UITableView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addSubview()
        configureUI()
        configureConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureToolbar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        restoreToolbar()
    }

    // MARK: - API
    // MARK: - Setups
    private func addSubview() {
        view.addSubview(titleLabel)
        view.addSubview(movieTableView)
    }

    private func configureUI() {
        view.backgroundColor = ColorScheme.tableViewBackground

        titleLabel.text = "My Moview List"
        titleLabel.font = UIFont(name: "SFProDisplay-Bold", size: 34)
        
        movieTableView.backgroundColor = ColorScheme.tableViewBackground
        movieTableView.allowsSelection = false
        movieTableView.separatorStyle = .none
        movieTableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
    }

    private func configureConstraints() {
        titleLabel.pin
            .top(to: view.safeAreaLayoutGuide)
            .leading(to: view, offset: 16)
            .trailing(to: view, offset: 16)
            .height(to: 41)

        movieTableView.pin
            .below(of: titleLabel, offset: 30)
            .leading(to: view)
            .trailing(to: view)
            .bottom(to: view)
    }

    private func configureToolbar() {
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTapped))
        navigationItem.setRightBarButton(barButton, animated: false)
        navigationController?.isToolbarHidden = false
    }

    private func restoreToolbar() {
        navigationItem.setRightBarButton(nil, animated: false)
        navigationController?.isToolbarHidden = true
    }

    // MARK: - Helpers
    @objc private func addButtonDidTapped() {
        print(#function)
    }
}

// MARK: table view

extension MainListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieCell.reuseIdentifier,
            for: indexPath
        ) as! MovieCell
        cell.updateView(title: "Test", raiting: "10", preview: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MovieCell.cellHeight
    }
    
}

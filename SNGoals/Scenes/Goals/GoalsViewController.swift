//
//  TreatmentViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class GoalsViewController: SNViewController<GoalsStates, GoalsViewModel> {
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var tableGoals: UITableView!

    weak var delegate: GoalsProtocol?
    
    private let searchController = UISearchController()
    private let refreshControl = UIRefreshControl()
    private var disposeBag = DisposeBag()

    fileprivate let searchText = PublishSubject<String>()
    fileprivate var dataBase: [GoalsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        configureBindings()
        configureTable()
        configureRefreshControl()
        mock()
    }
    
    private func mock() {
    }
    
    private func configureTable() {
        tableGoals.delegate = self
        tableGoals.dataSource = self
        tableGoals.register(type: GoalsCell.self)
        tableGoals.remembersLastFocusedIndexPath = true
    }
    
    private func configureRefreshControl() {
        refreshControl.tintColor = .accent
        tableGoals.refreshControl = refreshControl
        tableGoals.refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
    }
    
    @objc private func refresh(_ sender: Any) {
        Vibration.medium.vibrate()
        viewModel?.refresh.onNext(())
    }
    
    override func configureViews() {
        buttonAdd.imageView?.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.tintColor = .accent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    override func configureBindings() {
        searchText
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                self?.filter(text: text)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func createNewGoal(_ sender: Any) {
        delegate?.presentCreateNewGoals()
    }
    
    private func filter(text: String) {
        if text.isEmpty {
            print("Will not filter")
        } else {
            print("Will filter: \(text)")
        }
    }
    
    override func render(states: GoalsStates) {
        switch states {
        case .goals(let goals):
            self.dataBase = goals
            self.tableGoals.reloadData()
        case .refresh(let goals):
            Vibration.success.vibrate()
            dataBase = goals
            tableGoals.reloadData()
        case .loading(let loading):
            if !loading {
                tableGoals.refreshControl?.endRefreshing()
            }
        case .error(let message):
            Vibration.error.vibrate()
            Sanada.print(message)
        }
    }
}

extension GoalsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText.onNext(text)
    }
}

extension GoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoalsCell = tableView.dequeueReusableCell(indexPath)
        let item = dataBase[indexPath.row]
        guard let name = item.name,
              let date = item.date,
              let image = item.icon,
              let color = item.color else { return UITableViewCell() }
        cell.render(title: name,
                    date: date,
                    image: image,
                    color: color)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Vibration.light.vibrate()
        delegate?.pushGoal(from: dataBase[indexPath.row])
    }
}

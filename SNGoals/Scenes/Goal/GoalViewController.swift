//
//  TreatmentViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa

class GoalViewController: SNViewController<GoalStates, GoalViewModel> {
    weak var delegate: GoalProtocol?
    fileprivate let searchText = PublishSubject<String>()
    private let searchController = UISearchController()
    @IBOutlet weak var buttonNewGoal: UIButton!
    private var disposeBag = DisposeBag()
    @IBOutlet weak var tableGoal: UITableView!
    var color: HEXColor?
    var dataBase: [GoalModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        configureBindings()
        configureTable()
        mock()
    }
    
    private func mock() {
        dataBase = MockHelper.createGoal()
        tableGoal.reloadData()
    }
    
    private func configureTable() {
        tableGoal.delegate = self
        tableGoal.dataSource = self
        tableGoal.register(type: GoalCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func configureViews() {
        guard let color = color else { return }
        buttonNewGoal.tintColor = UIColor.fromHex(color)
        buttonNewGoal.imageView?.contentMode = .scaleAspectFit
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
    
    private func filter(text: String) {
        if text.isEmpty {
            print("Will not filter")
        } else {
            print("Will filter: \(text)")
        }
    }
    
    @IBAction func actionAddGoal(_ sender: UIButton) {
        delegate?.addGoal()
    }
}

extension GoalViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchText.onNext(text)
    }
}

extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataBase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoalCell = tableView.dequeueReusableCell(indexPath)
        let item = dataBase[indexPath.row]
        guard let title = item.name,
              let value = item.value,
              let goal = item.goal,
              let icon = item.icon,
              let type = item.type,
              let color = color else { return UITableViewCell() }
        cell.render(title: title,
                    image: icon,
                    color: color,
                    type: type,
                    value: value,
                    goal: goal)
        return cell
    }
    
    
}

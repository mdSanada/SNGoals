//
//  TreatmentViewController.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 27/09/22.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate enum GoalMenuType {
    case nav
    case add
}

class GoalViewController: SNViewController<GoalStates, GoalViewModel> {
    @IBOutlet weak var buttonNewGoal: UIButton!
    @IBOutlet weak var tableGoal: UITableView!

    weak var delegate: GoalProtocol?
    
    fileprivate let searchText = PublishSubject<String>()
    private let searchController = UISearchController()
    
    var color: HEXColor?
    var group: GoalsModel?
    var dataBase: [GoalModel] = []
    private var disposeBag = DisposeBag()
    
    private var rightButton: UIBarButtonItem = {
        let image = UIImage(systemName: "ellipsis.circle")
        let button = UIBarButtonItem(image: image)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        if let uuid = group?.uuid {
            viewModel?.uuid.onNext(uuid)
        }
        addNotification()
        configureBindings()
        configureTable()
        configureFromGoal()
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
        configureNavigationButton()
        buttonNewGoal.menu = createMenu(type: .add)
        buttonNewGoal.showsMenuAsPrimaryAction = true
        if let color = color {
            buttonNewGoal.tintColor = UIColor.fromHex(color)
            buttonNewGoal.imageView?.contentMode = .scaleAspectFit
        }
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

    override func render(states: GoalStates) {
        switch states {
        case .goals(let goals):
            self.dataBase = goals
            self.tableGoal.reloadData()
        case .refresh(let goals):
            self.dataBase = goals
            self.tableGoal.reloadData()
        case .loading(let loading):
            Sanada.print(loading)
        case .error(let message):
            Vibration.error.vibrate()
            Sanada.print(message)
        case .delete:
            delegate?.back()
        case .deleteLoading(let loading):
            Sanada.print("Loading Delete: \(loading)")
        }
    }
    
    @IBAction func actionAddGoal(_ sender: UIButton) {
        
    }
    
    private func addNotification() {
        SNNotificationCenter.shared.addObserver(self, selector: #selector(changedGoals(_:)),
                                                name: SNNotificationCenter.didChangeGoals.name,
                                                object: nil)
    }
    
    @objc private func changedGoals(_ notification: NSNotification) {
        if notification.userInfo?.keys.contains("goals") ?? false {
            guard let goals = notification.userInfo?["goals"] as? GoalsModel else { return }
            if !(group?.uuid?.isEmpty ?? true) && group?.uuid == goals.uuid {
                Vibration.success.vibrate()
                self.group = goals
                delegate?.didChangeGoals(goals)
                configureFromGoal()
            }
        }
    }
    
    private func configureFromGoal() {
        self.title = group?.name ?? ""
        self.color = group?.color ?? ""
        tableGoal.reloadData()
    }
    
    private func configureTable() {
        tableGoal.delegate = self
        tableGoal.dataSource = self
        tableGoal.register(type: GoalCell.self)
    }
    
    private func configureNavigationButton() {
        self.navigationItem.rightBarButtonItems = [rightButton]
        rightButton.menu = createMenu(type: .nav)
    }
    
    private func createMenu(type: GoalMenuType) -> UIMenu {
        let menu = UIMenu(options: .destructive, children: createMenuActions(type: type))
        return menu
    }
    
    private func createMenuActions(type: GoalMenuType) -> [UIAction] {
        switch type {
        case .nav:
            let stringActions = NavMenuActions.allCases
            var actions: [UIAction] = []
            stringActions.forEach { action in
                let newElement = UIAction(title: action.title(),
                                          image: action.image(),
                                          attributes: action.attributes()) { [weak self] _ in
                    self?.handlerMenu(type: type, navAction: action)
                }
                actions.append(newElement)
            }
            return actions
        case .add:
            let stringActions = GoalTypeMenuActions.allCases
            var actions: [UIAction] = []
            stringActions.forEach { action in
                let newElement = UIAction(title: action.title(),
                                          image: action.image(),
                                          attributes: action.attributes()) { [weak self] _ in
                    self?.handlerMenu(type: type, goalAction: action)
                }
                actions.append(newElement)
            }
            return actions
        }
    }
    
    private func handlerMenu(type: GoalMenuType,
                             navAction: NavMenuActions? = nil,
                             goalAction: GoalTypeMenuActions? = nil) {
        switch type {
        case .nav:
            guard let action = navAction else { return }
            switch action {
            case .edit:
                Vibration.light.vibrate()
                delegate?.presentEditGroup()
            case .share:
                Vibration.light.vibrate()
            case .delete:
                guard let uuid = group?.uuid else { return }
                Vibration.error.vibrate()
                viewModel?.delete.onNext(uuid)
            }
        case .add:
            guard let action = goalAction else { return }
            switch action {
            case .simple:
                Vibration.light.vibrate()
                delegate?.addGoal(goalType: .simple)
            case .currency:
                Vibration.light.vibrate()
                delegate?.addGoal(goalType: .money)
            case .number:
                Vibration.light.vibrate()
                delegate?.addGoal(goalType: .number)
            }
        }
    }
        
    private func filter(text: String) {
        if text.isEmpty {
            print("Will not filter")
        } else {
            print("Will filter: \(text)")
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = dataBase[indexPath.row]
        delegate?.detail(goal: goal)
    }
}

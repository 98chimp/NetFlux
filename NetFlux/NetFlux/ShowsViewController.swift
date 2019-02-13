//
//  ShowsViewController.swift
//  NetFlux
//
//  Created by Shahin on 2019-02-01.
//  Copyright © 2019 98%Chimp. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView

class ShowsViewController: UIViewController {

    @IBOutlet weak var showsTableView: UITableView!
    
    var stretchyHeader: GSKStretchyHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNotifications()
        title = "TV Shows"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        reloadShows()
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadShows), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    @objc func reloadShows() {
        DispatchQueue.main.async { [weak self] in
            self?.showsTableView.reloadData()
        }
    }
}

extension ShowsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = tabBarController?.selectedIndex == 0 ? PersistenceService.shared.shows?.count ?? 0 : PersistenceService.shared.shows?.filter({ $0.isFavourited == true }).count ?? 0
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifiers.Cells.showCell, for: indexPath) as? ShowTableViewCell else {
            return UITableViewCell()
        }
        let shows = tabBarController?.selectedIndex == 0 ? PersistenceService.shared.shows : PersistenceService.shared.shows?.filter({ $0.isFavourited == true })
        let show = shows?[indexPath.row]
        cell.configure(with: show)
        return cell
    }
}

extension ShowsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shows = tabBarController?.selectedIndex == 0 ? PersistenceService.shared.shows : PersistenceService.shared.shows?.filter({ $0.isFavourited == true })
        let show = shows?[indexPath.row]
        performSegue(withIdentifier: Constants.Identifiers.Segues.toShowDetail, sender: show)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shows = tabBarController?.selectedIndex == 0 ? PersistenceService.shared.shows : PersistenceService.shared.shows?.filter({ $0.isFavourited == true })
        if let show = shows?[indexPath.row] {
            let actionTitle = show.isFavourited ? Constants.ButtonTitles.delete : Constants.ButtonTitles.favourite
            let rowAction = UITableViewRowAction(style: .default, title: actionTitle) { (action, indexPath) in
                show.isFavourited = !show.isFavourited
                PersistenceService.shared.saveContext()
            }
            let actionColor = show.isFavourited ? UIColor.red : .green
            rowAction.backgroundColor = actionColor
            return [rowAction]
        }
        return nil
    }
}

extension ShowsViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.Segues.toShowDetail {
            let destinationVC = segue.destination as? ShowDetailViewController
            destinationVC?.show = sender as? Show
        }
    }
}

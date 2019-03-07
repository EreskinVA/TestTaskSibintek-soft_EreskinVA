//
//  ScheduleOfEventsTVC.swift
//  TestTaskSibintek-soft_EreskinVA
//
//  Created by Vladimir Ereskin on 06/03/2019.
//  Copyright © 2019 Vladimir Ereskin. All rights reserved.
//

import UIKit

struct Objects {  //Вспомогательная структура
    var sectionName : String!
    var sectionObjects : [Events]!
}

class ScheduleOfEventsTVC: UITableViewController {

    private var events = [Events]() // массив из .json
    private var eventsDict = [String: [Events]]()
    
    private var objectArray = [Objects]() // Источник данных
    
    private var filteredObjectArray = [Objects]()
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - ... User Methods
    
    func getJSON() {
        if let path = Bundle.main.path(forResource: "items", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path),
                                    options: .alwaysMapped)
                
                self.events = try JSONDecoder().decode([Events].self,
                                                       from: data)
                
            } catch let error {
                print(error)
            }
        }
    }
    
    func favoriteTapped(cell: EventsTableViewCell) {

        guard let indexPathTapped = tableView.indexPath(for: cell) else { return }

        objectArray[indexPathTapped.section].sectionObjects[indexPathTapped.row].favorite = !objectArray[indexPathTapped.section].sectionObjects[indexPathTapped.row].favorite!
        
        cell.favoriteButton.imageView?.image = objectArray[indexPathTapped.section].sectionObjects[indexPathTapped.row].favorite! ? UIImage(named: "star1") : UIImage(named: "star2")
        
        tableView.reloadRows(at: [indexPathTapped], with: .fade)
    }
    
    func setupInterface() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)]
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        title = objectArray[0].sectionObjects[0].dateStart
    }
    
    func setupArrays() {
        
        for index in 0...events.count - 1 {
            events[index].favorite = false
            events[index].dateStart = events[index].beginDate.formatedDate()
            events[index].timeStart = events[index].beginDate.formatedTime()
            events[index].timeEnd = events[index].endDate.formatedTime()
        }
        
        eventsDict = Dictionary(grouping: events, by: { $0.dateStart! })
        
        for (key, value) in eventsDict {
            objectArray.append(Objects(sectionName: key, sectionObjects: value))
        }
    }
    
    // MARK: - ... UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJSON()
        
        setupArrays()
        
        setupInterface()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return filteredObjectArray.count
        }
        return objectArray.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let indexPathFirstCell = tableView.indexPathsForVisibleRows?.first else { return }
        if isFiltering {
            title = filteredObjectArray[indexPathFirstCell.section].sectionObjects[indexPathFirstCell.row].dateStart
        } else {
            title = objectArray[indexPathFirstCell.section].sectionObjects[indexPathFirstCell.row].dateStart
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3202479482, green: 0.3034723103, blue: 0.2858663797, alpha: 1)
        
        let label = UILabel()
        label.backgroundColor = UIColor.orange
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        label.text = objectArray[section].sectionName
        label.frame = CGRect(x: tableView.center.x - 50, y: 0, width: 100, height: 20)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = label.font.withSize(12)
        
        view.addSubview(label)

        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredObjectArray[section].sectionObjects.count
        }
        return objectArray[section].sectionObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventsTableViewCell
        
        var event: Events
        
        if isFiltering {
            event = filteredObjectArray[indexPath.section].sectionObjects[indexPath.row]
        } else {
            event = objectArray[indexPath.section].sectionObjects[indexPath.row]
        }
        
        cell.link = self
        
        cell.favoriteButton.imageView?.image = event.favorite! ? UIImage(named: "star1") : UIImage(named: "star2")
        
        if let description = event.description {
            cell.descriptionLabel.isHidden = false
            cell.descriptionLabel.text = description
        } else {
            cell.descriptionLabel.isHidden = true
        }
        
        if let imageId = event.imageId {
            cell.imageName.isHidden = false
            cell.imageName.image = UIImage(named: "\(imageId)")
        } else {
            cell.imageName.isHidden = true
        }

        cell.date.text = "\(event.timeStart!) - \(event.timeEnd!)"
        cell.venue.text = "\(event.venue)"
        cell.name.text = "\(event.name)"

        guard (event.participant.first?.name) != nil else {
            cell.participantStackView.isHidden = true
            return cell
        }
        
        cell.participant.text = "\(event.participant.first!.surname!)" + " " +
            "\(String(event.participant.first!.name!).first!)" + "." +
            "\(String(event.participant.first!.patronyc!).first!)" + ".\n" +
            "\(event.participant.first!.position!)" + "\n" +
            "\(event.participant.first!.company!)"
        
        cell.participantStackView.isHidden = false
        
        cell.imageParticipant.image = UIImage(named: String(event.participant.first!.imageId!))
        
        return cell
    }
}

extension ScheduleOfEventsTVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredObjectArray.removeAll()
        for index in 0..<objectArray.count {
            filteredObjectArray.append(Objects(sectionName: objectArray[index].sectionName,
                                               sectionObjects: objectArray[index].sectionObjects.filter({ (events: Events) -> Bool in
                let searchString = "\(events.beginDate) \(events.endDate) \(events.name) \(events.description) \(events.participant.first?.name) \(events.participant.first?.surname) \(events.participant.first?.patronyc) \(events.participant.first?.position) \(events.participant.first?.company)"
                
                return searchString.lowercased().contains(searchText.lowercased())
            })))
        }
        
        filteredObjectArray = filteredObjectArray.filter({ $0.sectionObjects.isEmpty == false })
        
        tableView.reloadData()
    }
}


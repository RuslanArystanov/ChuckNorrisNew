//
//  SearchTableViewController.swift
//  ChuckNorrisFacts
//
//  Created by Руслан Арыстанов on 04.02.2025.
//

import UIKit

protocol SortDelegate {
    func sortSearchResult(sortedMethod: String)
    func toggleModalState(state: Bool)
}

class SearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SortDelegate{
    private var chuckNorrisFacts: [ChuckNorris] = []
    private var searchText: String?
    private var activityIndicator: UIActivityIndicatorView!
    private var search = UISearchController(searchResultsController: nil)
    private let tableView = UITableView()
    private let placeholderBackground = UIImageView()
    var isModalIsOpened = false
    var delegate: SearchTableViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openUnlockView()
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "arrow.up.and.down"),
            style: .plain,
            target: self,
            action: #selector(openSortView)
        )
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboardOrDismissView)
        )
        
        view.addGestureRecognizer(tapGesture)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        addElementsToSearchView()
        setupSearchController()
        refresh()
    }
    
    @objc func hideKeyboardOrDismissView(){
        if search.searchBar.isFirstResponder {
            search.searchBar.resignFirstResponder()
        } else if isModalIsOpened {
            delegate.closeSortView()
        }
    }
    
    @objc func openSortView(_ sender: Any) {
        if !isModalIsOpened && !search.searchBar.isFirstResponder {
            isModalIsOpened = true
            let viewControllerToPresent = SortViewController()
            viewControllerToPresent.delegate = self
            
            if let sheet = viewControllerToPresent.sheetPresentationController {
                sheet.detents = [.custom(resolver: { _ in
                    self.view.frame.height / 3
                })]
                sheet.largestUndimmedDetentIdentifier = .medium
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.prefersEdgeAttachedInCompactHeight = true
                sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                sheet.prefersGrabberVisible = true
            }
            
            present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chuckNorrisFacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        let chuckNorris = chuckNorrisFacts[indexPath.row]
        content.text = chuckNorris.value
        
        cell.contentConfiguration = content
        return cell
    }
    
    private func setupSearchController(){
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search..."
        search.hidesNavigationBarDuringPresentation = false
        search.automaticallyShowsCancelButton = false
        navigationItem.searchController = search
    }
    
    private func addElementsToSearchView(){
        activityIndicator = UIActivityIndicatorView(style: .large)
        placeholderBackground.image = UIImage(named: "search")
        tableView.frame = view.bounds
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        placeholderBackground.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        view.addSubview(placeholderBackground)
        tableView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -100),
            
            placeholderBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderBackground.heightAnchor.constraint(equalToConstant: 100),
            placeholderBackground.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func searchAnimation(animate: Bool){
        if animate == true {
            let animation = CASpringAnimation(keyPath: "position.x")
            animation.toValue = placeholderBackground.frame.origin.x + 50
            animation.fromValue = placeholderBackground.frame.origin.x - 50
            animation.duration = 3.0
            animation.repeatCount = .infinity
            animation.autoreverses = true
            animation.damping = 01.0
            animation.speed = 0.5
            animation.initialVelocity = 1

            placeholderBackground.layer.add(animation, forKey: "horizontalBounce")
        } else {
            placeholderBackground.layer.removeAnimation(forKey: "horizontalBounce")
        }
    }
    
    private func openUnlockView(){
        let vc = UnlockViewController()
        vc.modalPresentationStyle = .fullScreen

        present(vc, animated: false)
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text?.trimmingCharacters(in: .whitespaces)
        guard let textCount = searchBar.text?.count else {
            print("error")
            return
        }
        
        if textCount <= 3 {
            searchBar.text?.removeAll()
            showAlert(text: "Please enter more than 3 characters.")
        } else {
            placeholderBackground.isHidden = false
            chuckNorrisFacts.removeAll()
            tableView.reloadData()
            searchAnimation(animate: true)
            
            NetworkManager.share.fetchData(
                url: URLChuckNorris.searchURL.rawValue,
                searchText: searchText ?? "") { (chuckNorris: Result) in
                    
                    if !self.chuckNorrisFacts.isEmpty{
                        self.chuckNorrisFacts.removeAll()
                    }
                    
                    for result in chuckNorris.result {
                        self.chuckNorrisFacts.append(result)
                    }
                    
                    self.searchAnimation(animate: false)
                    self.placeholderBackground.isHidden = true
                    self.tableView.reloadData()
                    
                    if self.chuckNorrisFacts.isEmpty {
                        searchBar.text?.removeAll()
                        self.showAlert(text: "No results found. Please try a different search.")
                        self.placeholderBackground.isHidden = false
                    }
                }
            
            searchBar.resignFirstResponder()
        }
    }
    
    @objc private func fetchData(){
        let text = searchText ?? ""
        
        if text.count <= 3 {
            showAlert(text: "Please enter more than 3 characters.")
            tableView.refreshControl?.endRefreshing()
        } else {
            NetworkManager.share.fetchData(
                url: URLChuckNorris.searchURL.rawValue,
                searchText: text) { (chuckNorris: Result) in
                    self.chuckNorrisFacts.removeAll()
                    
                    for result in chuckNorris.result {
                        self.chuckNorrisFacts.append(result)
                    }
                    self.tableView.reloadData()
                    
                    if self.chuckNorrisFacts.isEmpty {
                        self.showAlert(text: "No results found. Please try a different search.")
                    }
                    
                    if self.tableView.refreshControl != nil{
                        self.tableView.refreshControl?.endRefreshing()
                    }
                }
        }
        
    }
    
    func sortSearchResult(sortedMethod: String) {
        switch sortedMethod {
        case "Sort by Length":
            chuckNorrisFacts.sort { $0.value.lowercased().count < $1.value.lowercased().count }
        case "Sort Alphabetically":
            chuckNorrisFacts.sort {$0.value.lowercased() < $1.value.lowercased()}
        default:
            print("Not sorted")
        }
        
        tableView.reloadData()
    }
    
    func toggleModalState(state: Bool) {
        isModalIsOpened = state
    }
    
    private func showAlert(text: String){
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func refresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        tableView.refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        
    }
}

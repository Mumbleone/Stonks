//
//  ViewController.swift
//  Stonks
//
//  Created by Adrian Devezin on 3/13/21.
//

import UIKit
import Combine

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var bindings: [AnyCancellable] = []
    private var slider: UISegmentedControl!
    private var tableView: UITableView!
    private var searchButton: UIButton!
    private var rows: [String] = []
    private let viewModel = ViewModel()
    var activityView: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        
        let cancellable = viewModel.$viewState.sink(receiveValue: { viewState in
            switch viewState {
            
            case .initial:
                print()
            case .loading:
                self.showActivityIndicator()
                // TODO step 1
            case let .results(data):
                self.hideActivityIndicator()
                self.setData(data: data)
                //TODO step 2
            case  let .error(message):
                self.hideActivityIndicator()
                self.showDialog(message)
            }
        })
        bindings.append(cancellable)
    }
    
    private func setData(data: [String]) {
        rows = data
        tableView.reloadData()
    }
    
    private func showDialog(_ message: String) {
        let dialog = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: { _ in }))
        present(dialog, animated: true, completion: nil)
    }

    private func createView() {
        createSlider()
        createButton()
        createTableView()
    }
    
    private func createSlider() {
        let items = Subreddit.allCases.map {
            "\($0)".uppercased()
        }
        slider = UISegmentedControl(items: items)
        slider.selectedSegmentIndex = 0
        slider.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(slider)
        
        slider.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func createButton() {
        searchButton = UIButton()
        searchButton.setTitle("Search", for: .normal)
        searchButton.addTarget(self, action: #selector(onSearchClick), for: .touchUpInside)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setTitleColor(UIColor.blue, for: .normal)
        
        let sliderGuide = UILayoutGuide()
        view.addSubview(searchButton)
        view.addLayoutGuide(sliderGuide)
        
        sliderGuide.bottomAnchor.constraint(equalTo: slider.bottomAnchor).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: sliderGuide.bottomAnchor, constant: 12).isActive = true
        
        searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func onSearchClick() {
        viewModel.onSearchClick(subreddit: Subreddit.allCases[slider.selectedSegmentIndex])
    }
    
    private func createTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        
        let searchButtonGuide = UILayoutGuide()
        view.addSubview(tableView)
        view.addLayoutGuide(searchButtonGuide)
        
        searchButtonGuide.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 12).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as? UITableViewCell else {
            fatalError("no cell")
        }
        cell.textLabel?.text = rows[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    

    func showActivityIndicator() {
        if activityView == nil {
            activityView = UIActivityIndicatorView(style: .large)
            activityView?.center = self.view.center
            activityView?.layer.cornerRadius = 8
            activityView?.backgroundColor = UIColor.black
            activityView?.hidesWhenStopped = true
            activityView?.alpha = 0.8
            view.addSubview(activityView!)
            activityView?.translatesAutoresizingMaskIntoConstraints = false
            activityView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            activityView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            activityView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            activityView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        }
        activityView?.startAnimating()
    }
    
    func hideActivityIndicator() {
        if (activityView != nil) {
            activityView?.stopAnimating()
        }
    }
}


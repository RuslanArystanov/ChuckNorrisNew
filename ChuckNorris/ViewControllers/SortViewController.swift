//
//  SortViewController.swift
//  ChuckNorrisFacts
//
//  Created by Руслан Арыстанов on 10.02.2025.
//

import UIKit

protocol SearchTableViewDelegate {
    func closeSortView()
}

class SortViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, SearchTableViewDelegate {
    private let picckerView = UIPickerView()
    private let successButton = UIButton()
    
    private let sortList = ["Sort by Length", "Sort Alphabetically"]
    var delegate: SortDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addElementsToSortView()
        picckerView.delegate = self
        picckerView.dataSource = self
        
        successButton.addTarget(self, action: #selector(applySort), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func applySort() {
        let index = picckerView.selectedRow(inComponent: 0)
        delegate?.sortSearchResult(sortedMethod: sortList[index])
        dismiss(animated: true)
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        sortList.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sortList[row]
    }
    
    private func addElementsToSortView(){
        picckerView.translatesAutoresizingMaskIntoConstraints = false
        successButton.setTitle("Apply", for: .normal)
        successButton.setTitleColor(.black, for: .normal)
        successButton.backgroundColor = .orange
        successButton.layer.cornerRadius = 5
        successButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(picckerView)
        view.addSubview(successButton)
        
        NSLayoutConstraint.activate([
            picckerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            picckerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            picckerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            successButton.topAnchor.constraint(equalTo: picckerView.bottomAnchor, constant: 10),
            successButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            successButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

extension SortViewController {
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.toggleModalState(state: false)
    }
    
    func closeSortView(){
        dismiss(animated: true)
    }
}

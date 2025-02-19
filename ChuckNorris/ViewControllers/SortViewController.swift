//
//  SortViewController.swift
//  ChuckNorrisFacts
//
//  Created by Руслан Арыстанов on 10.02.2025.
//

import UIKit

class SortViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let picckerView = UIPickerView()
    private let successButton = UIButton()
    
    private let sortList = ["Sort by Length", "Sort Alphabetically"]
    var delegate: SortDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        picckerView.delegate = self
        picckerView.dataSource = self
        picckerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(picckerView)
        
        successButton.setTitle("Apply", for: .normal)
        successButton.setTitleColor(.black, for: .normal)
        successButton.backgroundColor = .orange
        successButton.layer.cornerRadius = 5
        successButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(successButton)
        
        NSLayoutConstraint.activate([
            picckerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            picckerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            picckerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            successButton.topAnchor.constraint(equalTo: picckerView.bottomAnchor, constant: 20),
            successButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            successButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
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
}

extension SortViewController {
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.toggleModalState(state: false)
    }
}

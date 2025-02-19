//
//  RandomViewController.swift
//  ChuckNorrisFacts
//
//  Created by Руслан Арыстанов on 03.02.2025.
//

import UIKit

class RandomViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    private let categiriesPicker = UIPickerView()
    private let getFactButton = UIButton()
    
    private let shimmerImage = UIImageView()
    private let aboutChuckNorris = UILabel()
    
    private var categoriesChuck: [String] = ["random fact"]
    private var isCategory = false
    private var categoryName: String = ""
    
    private let shimmerLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addElementsToView()
        
        getCategories()
    
        categiriesPicker.delegate = self
        categiriesPicker.dataSource = self
        
        getFactButton.addTarget(self, action: #selector(getFact), for: .touchUpInside)
    }
    
    @objc func getFact() {
        aboutChuckNorris.text = ""
        setupShimmer()
        
        if isCategory == false {
            getRandomFact()
        } else {
            getFactFor(category: categoryName)
        }
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categoriesChuck.count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categoriesChuck[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if categoriesChuck[row] == categoriesChuck[0] {
            getFactButton.setTitle("Get \(categoriesChuck[0])", for: .normal)
            isCategory = false
        } else {
            categoryName = categoriesChuck[row]
            getFactButton.setTitle("Get fact from \(categoryName) category", for: .normal)
            isCategory = true
        }
    }
    
    private func addElementsToView(){
        aboutChuckNorris.text = "About Chuck Norris"
        aboutChuckNorris.textAlignment = .left
        aboutChuckNorris.numberOfLines = 10
        aboutChuckNorris.translatesAutoresizingMaskIntoConstraints = false
        
        getFactButton.setTitle("Get random", for: .normal)
        getFactButton.backgroundColor = .orange
        getFactButton.setTitleColor(.black, for: .normal)
        getFactButton.layer.cornerRadius = 10
        getFactButton.translatesAutoresizingMaskIntoConstraints = false
        
        categiriesPicker.translatesAutoresizingMaskIntoConstraints = false
        
        shimmerImage.image = UIImage(named: "shimmer dlya rusa")
        shimmerImage.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(aboutChuckNorris)
        view.addSubview(getFactButton)
        view.addSubview(shimmerImage)
        view.addSubview(categiriesPicker)
        
        NSLayoutConstraint.activate([
            aboutChuckNorris.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            aboutChuckNorris.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            aboutChuckNorris.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            aboutChuckNorris.heightAnchor.constraint(equalToConstant: 100),
            
            shimmerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            shimmerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            shimmerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            shimmerImage.heightAnchor.constraint(equalToConstant: 100),
            
            getFactButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            getFactButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            getFactButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categiriesPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categiriesPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categiriesPicker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
}

extension RandomViewController {
    private func getCategories(){
        NetworkManager.share.fetchData(url: URLChuckNorris.categoryURL.rawValue) { (categories: [String]) in
            for category in categories {
                self.categoriesChuck.append(category)
            }
            self.categiriesPicker.reloadAllComponents()
        }
    }
    
    private func getFactFor(category name: String){
        NetworkManager.share.fetchRandomData(url: URLChuckNorris.randomURL.rawValue,categoryName: name, isCategory: true) { ChuckNorris in
            self.stopShimmer()
            self.aboutChuckNorris.text = ChuckNorris.value
        }
    }
    
    private func getRandomFact(){
        NetworkManager.share.fetchRandomData(url: URLChuckNorris.randomURL.rawValue) { ChuckNorris in
            self.stopShimmer()
            self.aboutChuckNorris.text = ChuckNorris.value
        }
    }
    
    // MARK: - Shimmer settings
    private func setupShimmer() {
        shimmerImage.isHidden = false
        shimmerLayer.frame = shimmerImage.bounds
        shimmerLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.6).cgColor,
            UIColor.clear.cgColor
        ]
        shimmerLayer.locations = [0, 0.5, 1]
        shimmerLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer.endPoint = CGPoint(x: 1, y: 0.5)
        shimmerImage.layer.mask = shimmerLayer
        
        animateShimmer()
    }
    
    private func animateShimmer() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1, -0.5, 0]
        animation.toValue = [1, 1.5, 2]
        animation.duration = 2
        animation.repeatCount = .infinity
        shimmerLayer.add(animation, forKey: "shimmer")
    }
    
    private func stopShimmer() {
        shimmerImage.isHidden = true
        shimmerImage.layer.mask = .none
        shimmerLayer.removeAnimation(forKey: "shimmer")
    }
    
}

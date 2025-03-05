//
//  UnlockViewController.swift
//  ChuckNorris
//
//  Created by Руслан Арыстанов on 05.03.2025.
//

import UIKit

class UnlockViewController: UIViewController {
    
    private let unlockSlider = UISlider()
    private let sliderView = UIView()
    private let unlockLabel = UILabel()
    private let shimmerLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        unlockSlider.addTarget(self, action: #selector(closeUnlockView), for: .valueChanged)
        addElementsToUnlockView()
        setupShimmer()
    }
    
    @objc func closeUnlockView(){
        if unlockSlider.value == 100 {
            dismiss(animated: true)
        }
    }
    
    private func addElementsToUnlockView() {
        unlockLabel.text = "slide to unlock"
        unlockLabel.font = UIFont.systemFont(ofSize: 24)
        unlockLabel.translatesAutoresizingMaskIntoConstraints = false
        
        unlockSlider.minimumValue = 0.0
        unlockSlider.maximumValue = 100.0
        unlockSlider.value = 0.0
        unlockSlider.minimumTrackTintColor = UIColor(white: .zero, alpha: .zero)
        unlockSlider.maximumTrackTintColor = UIColor(white: .zero, alpha: .zero)
        unlockSlider.setThumbImage(UIImage(named: "chuck-norris"), for: .normal)
        unlockSlider.translatesAutoresizingMaskIntoConstraints = false
        
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 0.5)
        sliderView.layer.cornerRadius = 10
        sliderView.addSubview(unlockSlider)
        sliderView.addSubview(unlockLabel)
        
        view.addSubview(sliderView)
        view.addSubview(unlockSlider)
        
        NSLayoutConstraint.activate([
            sliderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sliderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sliderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            unlockLabel.centerXAnchor.constraint(equalTo: sliderView.centerXAnchor),
            unlockLabel.centerYAnchor.constraint(equalTo: sliderView.centerYAnchor),
            
            unlockSlider.leadingAnchor.constraint(equalTo: sliderView.leadingAnchor, constant: 5),
            unlockSlider.trailingAnchor.constraint(equalTo: sliderView.trailingAnchor, constant: -5),
            unlockSlider.topAnchor.constraint(equalTo: sliderView.topAnchor, constant: 5),
            unlockSlider.bottomAnchor.constraint(equalTo: sliderView.bottomAnchor, constant: -5)
        ])
    }
}

extension UnlockViewController {
    private func setupShimmer() {
        shimmerLayer.frame = unlockLabel.bounds
        shimmerLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.withAlphaComponent(0.6).cgColor,
            UIColor.clear.cgColor
        ]
        shimmerLayer.locations = [0, 0.5, 1]
        shimmerLayer.startPoint = CGPoint(x: 0, y: 0.5)
        shimmerLayer.endPoint = CGPoint(x: 1, y: 0.5)
        unlockLabel.layer.addSublayer(shimmerLayer)
        
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
}

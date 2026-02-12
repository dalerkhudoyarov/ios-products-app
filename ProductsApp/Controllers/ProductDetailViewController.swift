//
//  ProductDetailViewController.swift
//  ProductsApp
//
//  Created by Daler Xudoyarov on 13.12.2025.
//

import UIKit


class ProductDetailViewController: UIViewController {
    
    //MARK: - UI Components
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let mainTitle: UILabel = {
        let mainTitle = UILabel()
        mainTitle.font = .systemFont(ofSize: 22)
        mainTitle.textAlignment = .left
        mainTitle.numberOfLines = 2
        mainTitle.textColor = .black
        
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        return mainTitle
    }()
    
    let priceTitle: UILabel = {
        let priceTitle = UILabel()
        priceTitle.font = .systemFont(ofSize: 20, weight: .medium)
        priceTitle.textAlignment = .left
        priceTitle.textColor = .systemGreen
        
        priceTitle.translatesAutoresizingMaskIntoConstraints = false
        return priceTitle
    }()
    
    let detailsTitle: UILabel = {
        let detailsTitle = UILabel()
        detailsTitle.font = .systemFont(ofSize: 14)
        detailsTitle.textAlignment = .left
        detailsTitle.numberOfLines = 0
        detailsTitle.textColor = .black
        
        detailsTitle.translatesAutoresizingMaskIntoConstraints = false
        
        return detailsTitle
    }()
    
    let orderButton: UIButton = {
        let orderButton = UIButton()
        orderButton.setTitle("Заказать", for: .normal)
        orderButton.titleLabel?.textColor = .white
        orderButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        orderButton.backgroundColor = .systemCyan
        orderButton.layer.cornerRadius = 10
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        
        return orderButton
    }()
    
    
    var product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        configureData()
    }
    
    //MARK: - Private
    private func setupUI(){
        view.addSubview(imageView)
        view.addSubview(mainTitle)
        view.addSubview(priceTitle)
        view.addSubview(detailsTitle)
        view.addSubview(orderButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 400),
            
            
            mainTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            mainTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    
            priceTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 10),
            priceTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            
            
            detailsTitle.topAnchor.constraint(equalTo: priceTitle.bottomAnchor, constant: 15),
            detailsTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailsTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            detailsTitle.bottomAnchor.constraint(equalTo: orderButton.topAnchor, constant: -15),
                    
                    
            orderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orderButton.widthAnchor.constraint(equalToConstant: 150),
            orderButton.heightAnchor.constraint(equalToConstant: 50),
            orderButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            
                ])
        
        orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)

    }

    private func configureData() {
        
        mainTitle.text = product.title
        priceTitle.text = "$\(product.price)"
        detailsTitle.text = product.description

           if let url = URL(string: product.image) {
               Task {
                   do {
                       let (data, _) = try await URLSession.shared.data(from: url)
                       if let image = UIImage(data: data) {
                           DispatchQueue.main.async {
                               self.imageView.image = image
                           }
                       }
                   } catch {
                       print("Ошибка загрузки изображения:", error)
                   }
               }
           }
       }
    @objc func orderButtonTapped() {
        let alert = UIAlertController(title: "Заказ", message: "Товар заказан ✅", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default))
               present(alert, animated: true)
    }
}

//
//  ProductsViewController.swift
//  ProductsApp
//
//  Created by Daler Xudoyarov on 13.12.2025.
//

import UIKit

class ProductsViewController: UIViewController {

    //MARK: - UI Components
    let myTableView = UITableView()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .gray
        activityIndicator.style = .medium
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Ничего не найдено"
        label.textColor = .gray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    //MARK: - Variables
    var products: [Product] = []
    var filteredProducts: [Product] = []
    var isSearching: Bool = false
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Все товары"
        configureUI()
        
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        
        loadProducts()
        configureSearchController()
    }
    func configureSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Поиск товара"
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
            definesPresentationContext = true
        
    }

    func configureUI() {
        view.addSubview(myTableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyLabel)
        
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            myTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               emptyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150)

        ])
        
    }
    
    private func loadProducts() {
        activityIndicator.startAnimating()

        Task {
            do {
                let products = try await ProductService.shared.fetchProducts()
                self.products = products

                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.myTableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showErrorAlert()
                }
            }
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Не удалось загрузить товары",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }



}





//MARK: - Extension
extension ProductsViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return isSearching ? filteredProducts.count : products.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        let product = isSearching ? filteredProducts[indexPath.row] : products[indexPath.row]

        cell.titleLabel.text = product.title
        cell.priceLabel.text = "$\(product.price)"
        cell.productImageView.backgroundColor = .lightGray
        
       
        if let url = URL(string: product.image) {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            cell.productImageView.image = image
                        }
                    }
                } catch {
                    print("Ошибка загрузки изображения:", error)
                }
            }
        } else {
            cell.productImageView.image = nil
        }
        return cell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedProduct: Product

        if isSearching {
            selectedProduct = filteredProducts[indexPath.row]
        } else {
            selectedProduct = products[indexPath.row]
        }

        let detailVC = ProductDetailViewController(product: selectedProduct)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    }
    


extension ProductsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        
        if text.isEmpty {
            isSearching = false
            filteredProducts.removeAll()
        } else {
            isSearching = true
            filteredProducts = products.filter {
                
                $0.title.lowercased().contains(text.lowercased())
            }
                  }
        
        if isSearching && filteredProducts.isEmpty {
                   emptyLabel.isHidden = false
               } else {
                   emptyLabel.isHidden = true
               }
        
        myTableView.reloadData()
          
         
    }
    
    
}

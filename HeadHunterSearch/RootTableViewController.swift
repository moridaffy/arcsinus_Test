//
//  RootTableViewController.swift
//  HeadHunterSearch
//
//  Created by Максим Скрябин on 27/11/2018.
//  Copyright © 2018 MSKR. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var refresher: UIRefreshControl?
    
    var vacancies: [Vacancy] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationBar()
    }
    
    @objc func reloadVacancies() {
        view.endEditing(true)
        refresher?.beginRefreshing()
        
        APIManager.getVacancies(text: searchBar.text) { [weak self] (vacancies, error) in
            if let vacancies = vacancies {
                self?.vacancies = vacancies
            } else {
                self?.showAlertError(error: error, desc: "Не удалось загрузить список вакансий", critical: false)
            }
            
            DispatchQueue.main.async {
                self?.refresher?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func aboutButtonTapped() {
        let web = UIAlertAction(title: "Веб-сайт", style: .default, handler: { _ in
            let url = URL(string: "http://mskr.name")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        })
        showAlert(title: "О приложении", body: "Приложение было создано в кач-ве демонстрации кода компании Arcsinus.\n\nРазработчик: Скрябин Максим", button: "Ок", actions: [web])
    }
    
    @objc func sortButtonTapped() {
        var actions: [UIAlertAction] = []
        actions.append(UIAlertAction(title: "По убыванию ЗП", style: .default, handler: { _ in
            self.vacancies.sort(by: { ($0.price ?? 0) > ($1.price ?? 0) })
            self.tableView.reloadData()
        }))
        actions.append(UIAlertAction(title: "По возрастанию ЗП", style: .default, handler: { _ in
            self.vacancies.sort(by: { ($0.price ?? 0) < ($1.price ?? 0) })
            self.tableView.reloadData()
        }))
        
        showAlert(title: "Сортировать", body: "Выберите способ сортировки вакансий:", button: "Отмена", actions: actions)
    }
    
    func setupNavigationBar() {
        title = "Вакансии"
        
        searchBar.delegate = self
        let aboutButton = UIBarButtonItem(title: "О приложении", style: .done, target: self, action: #selector(aboutButtonTapped))
        navigationItem.leftBarButtonItem = aboutButton
        
        let sortButton = UIBarButtonItem(title: "Сортировать", style: .plain, target: self, action: #selector(sortButtonTapped))
        navigationItem.rightBarButtonItem = sortButton
    }
    
    func setupTableView() {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(reloadVacancies), for: .valueChanged)
        self.refresher = refresher
        tableView.refreshControl = self.refresher
        
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "PlaceholderTableViewCell", bundle: nil), forCellReuseIdentifier: "PlaceholderTableViewCell")
        tableView.register(UINib(nibName: "VacancyTableViewCell", bundle: nil), forCellReuseIdentifier: "VacancyTableViewCell")
    }
    
}

extension RootTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        reloadVacancies()
    }
    
}

extension RootTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vacancies.count == 0 {
            return 1
        } else {
            return vacancies.count
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if vacancies.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceholderTableViewCell") as! PlaceholderTableViewCell
            
            cell.titleLabel.text = "Введите поисковый запрос в поле выше и нажмите кнопку \"Поиск\" или просто потяните эту ячейку вниз, чтобы загрузить и отобразить доступные вакансии"
            
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VacancyTableViewCell") as! VacancyTableViewCell
            
            cell.nameLabel.text = vacancies[indexPath.row].name
            cell.employerLabel.text = vacancies[indexPath.row].employerName
            if let price = vacancies[indexPath.row].price {
                cell.priceLabel.text = "\(price) ₽"
            } else {
                cell.priceLabel.text = "ЗП не указана"
            }
            
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if vacancies.count != 0, let url = URL(string: vacancies[indexPath.row].alternateUrl) {
            let openUrl = UIAlertAction(title: "Открыть", style: .default, handler: { _ in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            showAlert(title: vacancies[indexPath.row].name, body: "Вы хотите открыть страницу этой вакансии на hh.ru?", button: "Отмена", actions: [openUrl])
        }
    }
}

//
//  ViewController.swift
//  ContentList
//
//  Created by Sagar Kumar on 12/08/20.
//  Copyright © 2020 Sagar Kumar. All rights reserved.
//

import UIKit
import SnapKit

class ContentsViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ContentCell.self, forCellReuseIdentifier: ContentCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    private var contents = [Content]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        configureAutoLayout()
        allContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = AppConstant.contents
    }
    
    private func configureAutoLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ContentsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentCell.identifier, for: indexPath) as! ContentCell
        
        let content = contents[indexPath.row]
        
        cell.idLabel.text = "\(content.id ?? "") (\(content.type ?? ""))"
        cell.dataLabel.text = content.data
        cell.dateLabel.text = content.date
        
        return cell
    }
}

extension ContentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contentDetailsController = ContentDetailsViewController()
        contentDetailsController.content = contents[indexPath.row]
        navigationController?.pushViewController(contentDetailsController, animated: false)
    }
}

class ContentCell: UITableViewCell {
    
    static let identifier: String = "content_cell_identifier"

    lazy var idLabel: UILabel = {
        let idLabel = UILabel(frame: .zero)
        idLabel.numberOfLines = 0
        idLabel.font = .boldSystemFont(ofSize: 16)
        return idLabel
    }()
    lazy var dataLabel: UILabel = {
        let dataLabel = UILabel(frame: .zero)
        dataLabel.numberOfLines = 0
        return dataLabel
    }()
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel(frame: .zero)
        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .right
        return dateLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    func configure() {
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        self.contentView.addSubview(idLabel)
        self.contentView.addSubview(dataLabel)
        self.contentView.addSubview(dateLabel)
        idLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-150)
            $0.top.equalToSuperview().offset(10)
        }
        dataLabel.snp.makeConstraints {
            $0.left.equalTo(idLabel.snp.left)
            $0.right.equalTo(dateLabel.snp.right)
            $0.top.equalTo(idLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().offset(-10)
        }
        dateLabel.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.width.equalTo(120)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ContentsViewController {
    
    private func allContent() {
        ContentListAPIManager.contents(success: { [weak self] response in
            guard let `self` = self, let contents = response as? [Content] else { return }
            DispatchQueue.global(qos: .background).async {
                RealmManager.addContents(contents)
            }
            self.reloadTable(contents)
        }) { [weak self] error in
            guard let `self` = self, let error = error else { return }
            switch (error as NSError).code {
            case NSURLErrorNotConnectedToInternet, NSURLErrorInternationalRoamingOff, 13:
                self.reloadTable(RealmManager.allContents())
            default:
                break
            }
        }
    }
    
    private func reloadTable(_ contents: [Content]) {
        self.contents = contents.sorted{($0.type ?? "") < ($1.type ?? "")}
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

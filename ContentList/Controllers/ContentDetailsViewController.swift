//
//  ContentDetailsViewController.swift
//  ContentList
//
//  Created by Sagar Kumar on 14/08/20.
//  Copyright © 2020 Sagar Kumar. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class ContentDetailsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(ContentDetailsCell.self, forCellReuseIdentifier: ContentDetailsCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    var content: Content?
    private lazy var contentDataArray: [(String, String)?] = {
        var dataArray = [(AppConstant.id, content?.id ?? ""), (AppConstant.type, content?.type ?? ""), (AppConstant.date, content?.date ?? "")]
        if content?.type ?? "" != "image" {
            dataArray.append((AppConstant.data, content?.data ?? ""))
        }
        return dataArray
    }()
    lazy var contentImageView: UIImageView = {
        var contentImageView = UIImageView(frame: .zero)
        contentImageView.contentMode = .scaleAspectFit
        return contentImageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(contentImageView)
        self.view.addSubview(tableView)
        configureAutoLayout()
        loadImageWithKingFisher(content?.data ?? "")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = AppConstant.contentDetails
    }
    
    func loadImageWithKingFisher(_ urlString: String = "") {
        guard let url = URL(string: urlString) else { return }
        contentImageView.kf.indicatorType = .activity
        contentImageView.kf.setImage(with: url)
    }
    
    private func configureAutoLayout() {
        let navigationHeight = (navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.size.height
        tableView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(contentImageView.snp.bottom)
        }
        contentImageView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview().offset(navigationHeight)
            $0.height.equalTo(content?.type ?? "" == "image" ? 250 : 0)
        }
    }
}

extension ContentDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentDataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentDetailsCell.identifier, for: indexPath) as! ContentDetailsCell
        
        let content = contentDataArray[indexPath.row]
        
        cell.contentTextLabel.text = content?.0
        cell.contentValueLabel.text = (content?.1 ?? "").isEmpty ? "N/A" : content?.1
        
        return cell
    }
}

extension ContentDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class ContentDetailsCell: UITableViewCell {
    
    static let identifier: String = "contentDetails_cell_identifier"

    lazy var contentTextLabel: UILabel = {
        var contentTextLabel = UILabel(frame: .zero)
        contentTextLabel.numberOfLines = 0
        contentTextLabel.font = .boldSystemFont(ofSize: 14)
        contentTextLabel.minimumScaleFactor = 8
        return contentTextLabel
    }()
    lazy var contentValueLabel: UILabel = {
        var contentValueLabel = UILabel(frame: .zero)
        contentValueLabel.textAlignment = .right
        contentValueLabel.numberOfLines = 0
        return contentValueLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configure()
    }

    func configure() {
        selectionStyle = .none
        self.contentView.addSubview(contentTextLabel)
        self.contentView.addSubview(contentValueLabel)
        contentTextLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(10)
            $0.width.equalTo(40)
        }
        contentValueLabel.snp.makeConstraints {
            $0.left.equalTo(contentTextLabel.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-20)
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

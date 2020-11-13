//
//  HomeViewController.swift
//  Example
//
//  Created by 蒋惠 on 2019/11/12.
//  Copyright © 2020 AnyImageProject.org. All rights reserved.
//

import UIKit

final class HomeViewController: UITableViewController {
    
    private var versionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        if let info = Bundle.main.infoDictionary, let version = info["CFBundleShortVersionString"] as? String {
            view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            view.text = "v"+version
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }
    
    private func setupNavigation() {
        navigationItem.title = "AnyImageKit"
    }
    
    private func setupView() {
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView(frame: .zero)
        
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section.allCases[section].allRowCase.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        let rowType = Section.allCases[indexPath.section].allRowCase[indexPath.row]
        cell.textLabel?.text = rowType.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowType = Section.allCases[indexPath.section].allRowCase[indexPath.row]
        navigationController?.pushViewController(rowType.controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].title
    }
}

// MARK: - Enum
extension HomeViewController {
    
    // MARK: - Section
    enum Section: Int, CaseIterable {
        case module
        case application
        
        var title: String {
            switch self {
            case .module:
                return "Module"
            case .application:
                return "Application"
            }
        }
        
        var allRowCase: [HomeRowTypeRule] {
            switch self {
            case .module:
                return ModuleRowType.allCases
            case .application:
                return ApplicationRowType.allCases
            }
        }
    }
    
    // MARK: - ModuleRowType
    enum ModuleRowType: CaseIterable, HomeRowTypeRule {
        case picker
        case editor
        case capture
        
        var title: String {
            switch self {
            case .picker:
                return "Picker"
            case .editor:
                return "Editor"
            case .capture:
                return "Capture"
            }
        }
        
        var controller: UIViewController {
            let style: UITableView.Style
            if #available(iOS 13.0, *) {
                style = .insetGrouped
            } else {
                style = .grouped
            }
            switch self {
            case .picker:
                return PickerConfigViewController(style: style)
            case .editor:
                return EditorConfigViewController(style: style)
            case .capture:
                return CaptureConfigViewController(style: style)
            }
        }
    }
    
    // MARK: - ApplicationRowType
    enum ApplicationRowType: CaseIterable, HomeRowTypeRule {
        case avatarPicker
        case preselectAsset
        
        var title: String {
            switch self {
            case .avatarPicker:
                return "Avatar Picker"
            case .preselectAsset:
                return "Preselect Asset"
            }
        }
        
        var controller: UIViewController {
            let style: UITableView.Style
            if #available(iOS 13.0, *) {
                style = .insetGrouped
            } else {
                style = .grouped
            }
            switch self {
            case .avatarPicker:
                return AvatarPickerController(style: style)
            case .preselectAsset:
                return PreselectAssetViewController()
            }
        }
    }
}

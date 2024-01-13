//
//  HomeSettingsViewController.swift
//  TokMarket
//
//  Created by KNG on 5.01.24.
//

import UIKit
import MessageUI

class HomeSettingsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var sections: [SettingSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupScreen()
    }
    
    func setupScreen() {
        self.sections = [
            SettingSection(rows: [
                SettingRow(titleName: "version".localized, type: .version),
                SettingRow(titleName: "terms_of_service".localized, type: .privacyPolicy),
                SettingRow(titleName: "privacy_policy".localized, type: .termsOfService)
            ], type: .about),
            SettingSection(rows: [
                SettingRow(titleName: "language".localized, type: .language),
                SettingRow(titleName: "currency".localized, type: .currency)
            ], type: .regional),
            SettingSection(rows: [
                SettingRow(titleName: "FAQ".localized, type: .faq),
                SettingRow(titleName: "contact_us".localized, type: .contactUs),
                SettingRow(titleName: "request_a_feature".localized, type: .requestAFeature)
            ], type: .help)
        ]
    }
    
    func setupDefaultCurrency() {
        var actions: [(String, UIAlertAction.Style)] = []
        actions.append(("\(DefaultCurrency.bgn.rawValue.uppercased())", .default))
        actions.append(("\(DefaultCurrency.eur.rawValue.uppercased())", .default))
        actions.append(("cancel".localized, .cancel))
        
        Alerts.showActionsheet(viewController: self, title: "currencies".localized, message: "select_default_currency".localized, actions: actions) { (index) in
            switch index{
            case 0:
                UserData.defaultCurrency = .bgn
            case 1:
                UserData.defaultCurrency = .eur
            default:
                return
            }
            self.setupScreen()
            self.tableView.reloadData()
        }
    }
    
    func setupDefaultLanguage() {
        var actions: [(String, UIAlertAction.Style)] = []
        actions.append(("\(DefaultLanguage.bulgarian.rawValue.uppercased())", .default))
        actions.append(("\(DefaultLanguage.english.rawValue.uppercased())", .default))
        actions.append(("cancel".localized, .cancel))
        
        Alerts.showActionsheet(viewController: self, title: "languages".localized, message: "select_default_language".localized, actions: actions) { (index) in
            switch index{
            case 0:
                UserData.defaultLanguage = .bulgarian
            case 1:
                UserData.defaultLanguage = .english
            default:
                return
            }
            self.setupScreen()
            self.tableView.reloadData()
        }
    }
}

extension HomeSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width, height: headerView.frame.height)
        label.text = self.sections[section].title
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = UIColor(named: "xdarkGray")
        label.backgroundColor = .clear

        headerView.addSubview(label)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var currentCell = UITableViewCell()
        let cellSection = self.sections[indexPath.section]
        let cellRow = cellSection.rows[indexPath.row]
        
        
        
        switch cellRow.type {
        
        case .version, .language, .currency, .termsOfService, .privacyPolicy, .faq, .contactUs, .requestAFeature:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSettingsTitleValueTableViewCell", for: indexPath) as? HomeSettingsTitleValueTableViewCell {
                cell.titleLabel.text = cellRow.titleName
                cell.valueLabel.isHidden = false
                switch cellRow.type {
                case .version:
                    cell.valueLabel.text = "\(Bundle.main.applicationVersion) (\(Bundle.main.applicationBuildVersion))"
                case .language:
                    cell.valueLabel.text = "\(UserData.defaultLanguage.rawValue.uppercased())"
                case .currency:
                    cell.valueLabel.text = "\(UserData.defaultCurrency.rawValue.uppercased())"
                default:
                    cell.valueLabel.isHidden = true
                }
                
                cell.accessoryType = .none
                currentCell = cell
            }
        }
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellSection = self.sections[indexPath.section]
        let cellRow = cellSection.rows[indexPath.row]
        
        switch cellRow.type {
        case .currency:
            self.setupDefaultCurrency()
        case .language:
            self.setupDefaultLanguage()
        case .contactUs:
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["rrr_ood@yahoo.com"])

                present(mail, animated: true)
            } else {
                if let url = URL(string: "mailto:rrr_ood@yahoo.com") {
                    UIApplication.shared.open(url)
                }
            }
        case .requestAFeature:
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["rrr_ood@yahoo.com"])
                mail.setSubject("[iOS] Request a feature")

                present(mail, animated: true)
            } else {
                if let url = URL(string: "mailto:rrr_ood@yahoo.com?subject=%5BiOS%5D%20Request%20a%20feature") {
                    UIApplication.shared.open(url)
                }
            }
        default:
            break
        }
    }
}

extension HomeSettingsViewController {
    struct SettingRow {
        enum RowType {
            case version
            case termsOfService
            case privacyPolicy
            case language
            case currency
            case faq
            case contactUs
            case requestAFeature
        }

        let titleName: String
        let type: RowType
    }
    
    struct SettingSection {
        enum SectionType: String {
            case about
            case regional
            case help
        
            var description: String {
                switch self {
                case .about:
                    return "about".localized
                case .regional:
                    return "regional".localized
                case .help:
                    return "help".localized
                }
            }
        }

        let rows: [SettingRow]
        let type: SectionType

        var title: String {
            return type.description
        }
    }
}

extension HomeSettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

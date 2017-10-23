//
//  BookmarkDetailVC.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/5/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import UIKit

class BookmarkDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var authentication: Authentication?
    var bookmarkModel: BookmarkVVO?
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    // MARK: - Helper Functions
    
    private func commonInit() {
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
    }
    
    private func formatLastMotifiedTime(timeString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let toDate = dateFormatter.date(from: timeString)
        
        if let date = toDate {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let formattedTime = dateFormatter.string(from: date)
            return formattedTime
        }
        
        return nil
    }
    
    // MARK: - TableViewDelegate Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkDetailCell", for: indexPath) as? BookmarkDetailCell,
            let model = self.bookmarkModel
        else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Title"
            if model.title == "" {
                cell.infoLabel.textColor = UIColor.lightGray
                cell.infoLabel.text = "Empty"
            } else {
                cell.infoLabel.text = model.title
                cell.infoLabel.textColor = UIColor.darkGray
            }
        case 1:
            cell.titleLabel.text = "URL"
            if model.url == "" {
                cell.infoLabel.textColor = UIColor.lightGray
                cell.infoLabel.text = "Empty"
            } else {
                cell.infoLabel.text = model.url
                cell.infoLabel.textColor = UIColor.darkGray
            }
        case 2:
            cell.titleLabel.text = "Description"
            if model.description == "" {
                cell.infoLabel.textColor = UIColor.lightGray
                cell.infoLabel.text = "Empty"
            } else {
                cell.infoLabel.text = model.description
                cell.infoLabel.textColor = UIColor.darkGray
            }
        case 3:
            cell.titleLabel.text = "Tags"
            if model.tags == "" {
                cell.infoLabel.textColor = UIColor.lightGray
                cell.infoLabel.text = "Empty"
            } else {
                cell.infoLabel.text = model.tags
                cell.infoLabel.textColor = UIColor.darkGray
            }
        case 4:
            cell.titleLabel.text = "Last modified"
            if model.lastModified == "" {
                cell.infoLabel.textColor = UIColor.lightGray
                cell.infoLabel.text = "Empty"
            } else {
                if let formattedTime = self.formatLastMotifiedTime(timeString: model.lastModified) {
                    cell.infoLabel.text = formattedTime
                    cell.infoLabel.textColor = UIColor.darkGray
                } else {
                    cell.infoLabel.textColor = UIColor.lightGray
                    cell.infoLabel.text = "Empty"
                }
            }
        default:
            break
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToBookmarkDetailVC(segue: UIStoryboardSegue) {
        guard let vc = segue.source as? AddBookmarkVC else { return }
//        if let model = vc.updateBookmarkModel {
            var json = vc.bookmarkJSON
            json["LastModified"] = self.bookmarkModel?.lastModified
            let bookmarkModel = BookmarkVVO(from: json)
            self.bookmarkModel = bookmarkModel
            self.tableView.reloadData()
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let vc = segue.destination as? AddBookmarkVC,
            let model = self.bookmarkModel
        else {
            return
        }
        let json: JSONObject = [
            "Title": model.title,
            "URL": model.url,
            "Description": model.description,
            "Tags": model.tags
        ]
        vc.title = "Edit"
        vc.parentVC = self
        vc.bookmarkJSON = json
        vc.authentication = self.authentication
    }
}

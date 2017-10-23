//
//  AddBookmarkVC.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/4/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import UIKit
import SPRingboard

class AddBookmarkVC: UITableViewController, AddBookmarkEditVCDelegate {

    var parentVC: UIViewController?
    var authentication: Authentication?
    var bookmarkJSON = JSONObject()
    var updateBookmarkModel: UpdateBookmarkVVO?
    var modifiedIndexPath: IndexPath?
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    // MARK: - Helper Functions
    
    private func callAddBookmarkCommand() {
        self.disableSaveBarButton()
        guard let authentication = self.authentication else { return }
        let request = AddBookmark(with: self.bookmarkJSON)
        let cmd = AddBookmarkCommand()
        cmd.execute(with: authentication, request: request).then { result in
            switch result {
            case .success:
                print("AddBookmarkCommand returned with success")
                if let _ = self.parentVC as? BookmarkDetailVC {
//                    self.updateBookmarkModel = model
                    NotificationCenter.default.post(name: bookmarksNeedsUpdate, object: nil)
                    self.performSegue(withIdentifier: "unwindToBookmarkDetailVC", sender: self)
                } else if let _ = self.parentVC as? BookmarksVC {
                    self.performSegue(withIdentifier: "unwindToBookmarksVC", sender: nil)
                }
            case .failure:
                break
            }
            self.enableSaveBarButton()
        }
    }
    
    private func callUpdateBookmarkCommand() {
        self.disableSaveBarButton()
        guard let authentication = self.authentication else { return }
        let request = AddBookmark(with: self.bookmarkJSON)
        let cmd = UpdateBookmarkCommand()
        cmd.execute(with: authentication, request: request).then { result in
            switch result {
            case .success(let model):
                print("UpdateBookmarkCommand returned with success")
                self.updateBookmarkModel = model
                self.performSegue(withIdentifier: "unwindToBookmarkDetailVC", sender: self)
            case .failure:
                break
            }
            self.enableSaveBarButton()
        }
    }
    
    private func commonInit() {
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.disableSaveBarButton()
    }
    
    private func disableSaveBarButton() {
        self.saveBarButton.tintColor = UIColor(red: 105/255, green: 182/255, blue: 116/255, alpha: 0.8)
        self.saveBarButton.isEnabled = false
    }
    
    private func enableSaveBarButton() {
        self.saveBarButton.tintColor = UIColor(red: 105/255, green: 182/255, blue: 116/255, alpha: 1)
        self.saveBarButton.isEnabled = true
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddBookmarkCell", for: indexPath) as? AddBookmarkCell
        else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Title"
            if let info = self.bookmarkJSON["Title"] as? String {
                cell.infoLabel.textColor = info == "" ? UIColor.lightGray : UIColor.darkGray
                cell.infoLabel.text = info == "" ? "Empty" : info
            }
        case 1:
            cell.titleLabel.text = "URL"
            if let info = self.bookmarkJSON["URL"] as? String {
                cell.infoLabel.textColor = info == "" ? UIColor.lightGray : UIColor.darkGray
                cell.infoLabel.text = info == "" ? "Empty" : info
            }
        case 2:
            cell.titleLabel.text = "Description"
            if let info = self.bookmarkJSON["Description"] as? String {
                cell.infoLabel.textColor = info == "" ? UIColor.lightGray : UIColor.darkGray
                cell.infoLabel.text = info == "" ? "Empty" : info
            }
        case 3:
            cell.titleLabel.text = "Tags"
            if let info = self.bookmarkJSON["Tags"] as? String {
                cell.infoLabel.textColor = info == "" ? UIColor.lightGray : UIColor.darkGray
                cell.infoLabel.text = info == "" ? "Empty" : info
            }
        default:
            break
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.modifiedIndexPath = indexPath
    }
    
    // MARK: - AddBookmarkEditVCDelegate Functions
    
    func updateContext(with context: String) {
        if let indexPath = self.modifiedIndexPath {
            guard
                let cell = self.tableView.cellForRow(at: indexPath) as? AddBookmarkCell,
                let key = cell.titleLabel.text
            else {
                return
            }
            self.bookmarkJSON[key] = context
            if context.characters.count > 0 {
                cell.infoLabel.text = context
                cell.infoLabel.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
            } else {
                cell.infoLabel.text = "Empty"
                cell.infoLabel.textColor = .lightGray
            }
            self.enableSaveBarButton()
        }
    }
    
    // MARK: - IBAction Functions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.callAddBookmarkCommand()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let vc = segue.destination as? AddBookmarkEditVC,
            let cell = sender as? AddBookmarkCell,
            let title = cell.titleLabel.text,
            let context = cell.infoLabel.text
        else {
            return
        }
        vc.title = title
        vc.context = context
        vc.delegate = self
    }
}

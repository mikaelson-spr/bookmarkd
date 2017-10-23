//
//  BookmarksVC.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/2/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import UIKit
import SPRingboard

class BookmarksVC: SPRTableViewController {

    var authentication: Authentication?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.addObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addObservers()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helper Functions
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            forName: bookmarksNeedsUpdate,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.setNeedsModelLoaded()
            }
        }
    }

    // MARK: - SPRTableViewController Functions
    
    override func loadObjectDataSource() -> FutureResult<ObjectDataSource<Any>> {
        let deferred = DeferredResult<ObjectDataSource<Any>>()
        
        guard let authentication = self.authentication else { return deferred }
        
        let cmd = FetchBookmarksCommand()
        cmd.execute(with: authentication).then { result in
            switch result {
            case .success(let array):
                let ods = ArrayObjectDataSource<Any>(objects: array)
                deferred.fill(value: ods)
            case .failure:
                break
            }
        }
        
        return deferred
    }
    
    override func renderCell(inTableView tableView: UITableView, withModel model: Any, at indexPath: IndexPath) throws -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as? BookmarkCell,
            let bookmarkModel = model as? BookmarkVVO
        else {
            return UITableViewCell()
        }
        cell.dataModel = bookmarkModel
        cell.titleLabel.text = bookmarkModel.title
        
        return cell
    }

    // MARK: - Navigation
    
    @IBAction func unwindToBookmarksVC(segue: UIStoryboardSegue) {
        self.setNeedsModelLoaded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else { return }
        
        if id == "bookmarksToBookmarkDetail" {
            guard
                let cell = sender as? BookmarkCell,
                let vc = segue.destination as? BookmarkDetailVC
            else {
                return
            }
            vc.bookmarkModel = cell.dataModel
            vc.authentication = self.authentication
            
        } else if id == "bookmarksToAddBookmark" {
            guard
                let vc = segue.destination as? AddBookmarkVC
            else {
                return
            }
            vc.title = "Add"
            vc.parentVC = self
            vc.authentication = self.authentication
        }
    }
}

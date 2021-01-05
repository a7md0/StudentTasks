//
//  CoursesTableViewController.swift
//  StudentTasks
//
//  Created by mobileProg on 12/22/20.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    var courseslist : [Course] = []
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        courseslist =  Course.findAll()
        
        tableView.tableFooterView = UIView(frame: .zero) // Hide unused cells
        tableView.keyboardDismissMode = .interactive // Support keyboard hide by swipe
        
        setupSearchBar()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.courseCreated), name: Constants.coursesNotifcations["created"]!, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.courseUpdated), name: Constants.coursesNotifcations["updated"]!, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.courseRemoved), name: Constants.coursesNotifcations["removed"]!, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courseslist.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCellIdentifier", for: indexPath) as! CoursesTableViewCell

        // Configure the cell...
        let course = courseslist[indexPath.row]
        cell.courseName.text = course.name
        
        if let color = course.color{
            cell.courseImg.backgroundColor = color.color
        }
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showCourseDetails",
           let courseDetailsView = segue.destination as? CourseDetailsViewController,
           let indexPathForSelectedRow = tableView.indexPathForSelectedRow?.row {
            
            let course = courseslist[indexPathForSelectedRow]
            courseDetailsView.course = course
        }
    }
    
    @IBAction func unwindToCourses(_ unwindSegue: UIStoryboardSegue) {
        _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    func showConfirmDelete(_ what: String, handler: ((Bool) -> Void)?) {
        let confirmAlert = UIAlertController(title: "Delete \"\(what)\"?", message: "Deleting this course will delete all related tasks.", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            handler?(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            handler?(false)
        }
        
        confirmAlert.addAction(okAction)
        confirmAlert.addAction(cancelAction)

        present(confirmAlert, animated: true, completion: nil)
    }
    
    func deleteItem(indexPath: IndexPath) {
        let course = courseslist[indexPath.row]
        
        courseslist.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        course.remove()
    }
}

extension CoursesTableViewController {
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let task = self.courseslist[indexPath.row]
            
            self.showConfirmDelete(task.name) { (delete) in
                completionHandler(true)
                
                if delete {
                    print("Delete \(indexPath.row + 1)")
                
                    self.deleteItem(indexPath: indexPath)
                }
            }
        }
        delete.image = UIImage(systemName: "trash")
        
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        
        return swipe
    }
}

// MARK: - Search
extension CoursesTableViewController: UISearchBarDelegate {
    func setupSearchBar() {
        searchBar.setImage(UIImage(systemName: "slider.horizontal.3"), for: .bookmark, state: .normal)
        searchBar.showsBookmarkButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //updateSearchQuery?(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        //updateSearchQuery?("")
        
        searchBar.endEditing(true)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        //performSegue(withIdentifier: "coursesFiltersSegue", sender: self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsBookmarkButton = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsBookmarkButton = true
    }
}

extension CoursesTableViewController {
    @objc private func courseCreated(notification: NSNotification) {
        guard let course = notification.object as? Course else { return }
        
        self.courseslist.append(course)
        tableView.reloadData()
    }
    
    @objc private func courseUpdated(notification: NSNotification) {
        guard let course = notification.object as? Course,
              let idx = self.courseslist.firstIndex(where: { $0 == course }) else { return }
        
        
        self.courseslist[idx] = course
        tableView.reloadData()
    }
    
    @objc private func courseRemoved(notification: NSNotification) {
        guard let course = notification.object as? Course,
              let idx = self.courseslist.firstIndex(where: { $0 == course }) else { return }
        
        self.courseslist[idx] = course
        tableView.reloadData()
    }
}


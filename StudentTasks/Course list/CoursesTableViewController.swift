//
//  CoursesTableViewController.swift
//  StudentTasks
//
//  Created by mobileProg on 12/22/20.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    
    var allCourses: [Course] = []
    var courses: [Course] = []
    var searchCourses: [Course] = []
    
    var isSearching = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var updateSearchQuery: Debounce<String>?
    
    var query: CoursesQuery = CoursesQuery.instance
    
    var reloadTableViewData: (() -> Void)?
    var ignoreNextUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        allCourses = Course.findAll()
        self.filterCourses()
        
        tableView.tableFooterView = UIView(frame: .zero) // Hide unused cells
        tableView.keyboardDismissMode = .interactive // Support keyboard hide by swipe
        
        setupSearchBar()
        
        updateSearchQuery = debounce(interval: 500, queue: DispatchQueue.main, action: { (searchText: String) in
            let searchQuery = searchText.count > 0 ? searchText : nil
            self.filterSearchResult(searchQuery: searchQuery)
        })
        
        reloadTableViewData = debounce(interval: 50, queue: DispatchQueue.main, action: {
            self.tableView.reloadData()
        })
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.courseCreated), name: Constants.coursesNotifcations["created"]!, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.courseUpdated), name: Constants.coursesNotifcations["updated"]!, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.courseRemoved), name: Constants.coursesNotifcations["removed"]!, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func filterCourses(reloadData: Bool = true) {
        DispatchQueue.global(qos: .background).async {
            guard self.ignoreNextUpdate == false else {
                self.ignoreNextUpdate = false
                return
            }
            self.filterSortCourses()

            if reloadData {
                DispatchQueue.main.async {
                    self.reloadTableViewData?()
                }
            }
        }
    }
    
    func filterSortCourses() {
        self.courses = allCourses.sorted(by: {
            if self.query.sortBy.courseName == .descending {
                return $0.name > $1.name
            } else {
                return $0.name < $0.name
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearching ? searchCourses.count : courses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCellIdentifier", for: indexPath) as! CoursesTableViewCell

        // Configure the cell...
        let course = self.isSearching ? searchCourses[indexPath.row] : courses[indexPath.row]
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
            
            let course = courses[indexPathForSelectedRow]
            courseDetailsView.course = course
        } else if segue.identifier == "coursesFiltersSegue",
                  let coursesFilters = segue.destination as? CoursesFiltersTableViewController {
            
            coursesFilters.query = query
        }
    }
    
    @IBAction func unwindToCourses(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        if unwindSegue.identifier == "coursesViewUnwindSegue",
           let coursesFilters = sourceViewController as? CoursesFiltersTableViewController {

            self.query = coursesFilters.query
            self.filterCourses()
        }
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
        let course = courses[indexPath.row]
        
        courses.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
        
        self.ignoreNextUpdate = true
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
            let task = self.courses[indexPath.row]
            
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
        updateSearchQuery?(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        updateSearchQuery?("")
        
        searchBar.endEditing(true)
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        performSegue(withIdentifier: "coursesFiltersSegue", sender: self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsBookmarkButton = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsBookmarkButton = true
    }
    
    func filterSearchResult(searchQuery: String?) {
        DispatchQueue.global(qos: .background).async {
            if let searchQuery = searchQuery {
                self.isSearching = true
                
                self.searchCourses = self.courses.filter({ (course: Course) -> Bool in
                    var result = false
                    
                    let searchKeywords = searchQuery.lowercased().split(separator: " ")
                    searchKeywords.forEach { (keyword) in
                        if course.name.lowercased().contains(keyword) || course.code?.lowercased().contains(keyword) ?? false || course.abberivation?.lowercased().contains(keyword) ?? false || course.lecturerName?.contains(keyword) ?? false {
                            result = true
                            return // break loop
                        }
                    }
                    
                    return result
                })
            } else {
                self.isSearching = false
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

extension CoursesTableViewController {
    @objc private func courseCreated(notification: NSNotification) {
        guard let course = notification.object as? Course else { return }
        
        self.allCourses.append(course)
        self.filterCourses()
    }
    
    @objc private func courseUpdated(notification: NSNotification) {
        guard let course = notification.object as? Course,
              let idx = self.courses.firstIndex(where: { $0 == course }) else { return }
        
        
        self.allCourses[idx] = course
        self.filterCourses()
    }
    
    @objc private func courseRemoved(notification: NSNotification) {
        guard let course = notification.object as? Course,
              let idx = self.courses.firstIndex(where: { $0 == course }) else { return }
        
        self.allCourses.remove(at: idx)
        self.filterCourses()
    }
}


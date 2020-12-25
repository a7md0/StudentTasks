//
//  TasksViewController.swift
//  StudentTasks
//
//  Created by Ahmed Naser on 12/16/20.
//

import UIKit

class TasksViewController: UIViewController {
    @IBOutlet weak var tabScrollView: ACTabScrollView!
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterButton: UIButton!
    
    var labels: [UILabel] = []
    var contentViews: [TasksTableViewController] = []
    var currentTabViewIdx: Int = 0
    
    var courses: [Course] = []
    
    var sort: TasksSort?
    var filters: TasksFilter?
    
    var searchQuery: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        courses = Course.findAll()

        // Do any additional setup after loading the view.
        sort = TasksSort()
        filters = TasksFilter()
        
        setupSearchBar()
        setupTabScrollView()
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        if segue.identifier == "tasksFiltersSegue",
           let destinationNavigationController = segue.destination as? UINavigationController,
           let tasksFiltersController = destinationNavigationController.topViewController as? TasksFiltersTableViewController {
            tasksFiltersController.sort = sort
            tasksFiltersController.filters = filters
        }
    }
    
    @IBAction func unwindToTasksView(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        if unwindSegue.identifier == "tasksViewUnwindSegue" {
            
        }
    }
}

// MARK: - Search
extension TasksViewController: UISearchBarDelegate {
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        Debounce<String>.input(searchText, comparedAgainst: searchBar.text ?? "") {
            self.searchQuery = $0.count > 0 ? searchText : nil
            self.contentViews[self.currentTabViewIdx].filterResults(searchQuery: self.searchQuery)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(false)
    }
}

// MARK: - Tab view
extension TasksViewController: ACTabScrollViewDelegate, ACTabScrollViewDataSource {
    func setupTabScrollView() {
        // all the following properties are optional
        /*tabScrollView.defaultPage = 3
        tabScrollView.arrowIndicator = true
        tabScrollView.tabSectionHeight = 40
        tabScrollView.tabSectionBackgroundColor = UIColor.white
        tabScrollView.contentSectionBackgroundColor = UIColor.white
        tabScrollView.tabGradient = true
        tabScrollView.pagingEnabled = true
        tabScrollView.cachedPageLimit = 3*/
        
        tabScrollView.tabSectionBackgroundColor = .systemGray6
        tabScrollView.tabSectionHeight = 48
        
        tabScrollView.arrowIndicator = true
        tabScrollView.contentSectionScrollEnabled = false
        
        tabScrollView.delegate = self
        tabScrollView.dataSource = self
        
        prepareTabs()
    }
    
    // MARK: ACTabScrollViewDelegate
    func tabScrollView(_ tabScrollView: ACTabScrollView, didChangePageTo index: Int) {
        currentTabViewIdx = index
        contentViews[currentTabViewIdx].filterResults(searchQuery: searchQuery)
    }
        
    func tabScrollView(_ tabScrollView: ACTabScrollView, didScrollPageTo index: Int) {
        currentTabViewIdx = index
        contentViews[currentTabViewIdx].filterResults(searchQuery: searchQuery)
    }
        
    // MARK: ACTabScrollViewDataSource
    func numberOfPagesInTabScrollView(_ tabScrollView: ACTabScrollView) -> Int {
        return contentViews.count
    }
        
    func tabScrollView(_ tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView {
        let label = labels[index]

        return label
    }
        
    func tabScrollView(_ tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
        return contentViews[index].view
    }
    
    func prepareTabs() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let allCoursesTabTableView = storyboard.instantiateViewController(withIdentifier: "TasksTableViewController") as! TasksTableViewController
        allCoursesTabTableView.sort = self.sort
        allCoursesTabTableView.setTasks(tasks: Task.findAll())
        
        self.addChild(allCoursesTabTableView)
        contentViews.append(allCoursesTabTableView)
        createTabLabel("All")
        
        for course in Course.findAll() {
            let tabTableView = storyboard.instantiateViewController(withIdentifier: "TasksTableViewController") as! TasksTableViewController
            
            tabTableView.sort = self.sort
            tabTableView.setTasks(tasks: course.tasks)
            
            addChild(tabTableView) // don't forget, it's very important
            contentViews.append(tabTableView)
            
            createTabLabel(course.name)
        }
    }
    
    private func createTabLabel(_ text: String) {
        // create a label
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        
        // if the size of your tab is not fixed, you can adjust the size by the following way.
        label.sizeToFit() // resize the label to the size of content
        label.frame.size = CGSize(
            width: label.frame.size.width + 28,
            height: label.frame.size.height + 36
        ) // add some paddings
        
        labels.append(label)
    }
}

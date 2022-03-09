import UIKit
import RealmSwift
import ChameleonFramework


class TodoListViewController: SwipeTableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        tableView.separatorStyle = .none
        loadItems()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colourHex =  selectedCategory?.bgColor{
        
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {
                fatalError("Navigation controller does not exist.")}
            
            if let navBarColour = UIColor(hexString: colourHex){
                
                navBar.backgroundColor = navBarColour
                navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
                
                //searchBar.barTintColor = navBarColour
            }
        }
    }

    //MARK - Tableview Datasource Methods
    
    //Function returns number of rows in array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //Setting ReusableCell Values goes Over Here Setting ReusableCell Values goes Over Here
    //Setting ReusableCell Values goes Over Here Setting ReusableCell Values goes Over Here
    //Setting ReusableCell Values goes Over Here Setting ReusableCell Values goes Over Here
    //Setting ReusableCell Values goes Over Here Setting ReusableCell Values goes Over Here
    //Setting ReusableCell Values goes Over Here Setting ReusableCell Values goes Over Here
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
         //Done/Undone Settings
            // Ternary operator ==>value = conditions ? valueIfTrue : valueIfFalse
                cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
    //Cell Color setting
    if let colour = UIColor(hexString: selectedCategory?.bgColor ?? "1d9bf6")?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
         cell.backgroundColor = colour
         cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
        tableView.rowHeight = 250.0 //80.0
        tableView.separatorStyle = .none
        }
            
        return cell
    }
    
    
    //MARK - TableView Delegate Methods  _ will run when row is selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems? [indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }

        self.tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)

        }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the add Item button on our UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.imageURL = "NA"
                    newItem.dateCreated = Date()
                    
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

    func loadItems()
    {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    
    
    
    
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {

        if let item = self.todoItems? [indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error deleting Todo list Item \(error)")
            }
        }
    }
}

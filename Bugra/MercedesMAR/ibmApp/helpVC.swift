import UIKit

class HelpVC: UIViewController,UITableViewDataSource
{
    let list1 = ["Brian", "Rachel","Jack", "Mike", "Hanna", "Jane"]
    let list2 = ["aasdf", "bsafads", "csadfadf", "dgfgdfg", "csadfdfgfgadf", "dgfgd"]
    

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return errorComments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")! //1.
        cell.textLabel?.font = UIFont(name:"Avenir", size:12)

        let text = "\(errorNames[indexPath.row]): \(errorComments[indexPath.row])" //2.
        
        cell.textLabel?.text = text //3.
        
        return cell //4.
    }
    
   
    
}

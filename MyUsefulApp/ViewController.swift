//
//  ViewController.swift
//  MyUsefulApp
//
//  Created by amooyts on 25.09.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, DataEnteredDelegate {
    
    func userEnterInfo(info1: String, info2: String, info3: String) {
        moviesArray.append(Movie(title: info1, year: info3, type: info2))
        filteredMoviesArray.append(Movie(title: info1, year: info3, type: info2))
        tableView.reloadData()
        
       //let movieObject = NSEntityDescription.insertNewObject(forEntityName: "Movie", into: context)
      //  movieObject.setValue(info1, forKey: "title")
      //  movieObject.setValue(info2, forKey: "type")
     //   movieObject.setValue(info3, forKey: "year")
      //  do {
      //      try context.save()
      //      print("saved")
      //  } catch  {
      //      print("failed saving :(")
       // }
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //let context = (UIApplication.shared.delegate as! //AppDelegate).persistentContainer.viewContext
    
    var moviesArray: [Movie] = []
    var filteredMoviesArray: [Movie] = []
    var alertEmptySearch: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        moviesArray = parseFileAndCreateArray()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        filteredMoviesArray = moviesArray
        alertEmptySearch = UIAlertController(title: "Alert", message: "Nothing is found!", preferredStyle: UIAlertController.Style.alert)
        alertEmptySearch.addAction(UIAlertAction(title: "Click", style: .cancel, handler: nil))
        
        // hide keyboard while scrolling UITableView
        tableView.keyboardDismissMode = .onDrag
        
        // save data to Core Data
        
    }
    
    /* Keyboard dismiss */
    func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    /* Keyboard dismiss */
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CellsDetailsViewController.moviePressed = filteredMoviesArray[indexPath.row]
        performSegue(withIdentifier: "toDescribingInfo", sender: nil)
        view.endEditing(true)
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie_movie = filteredMoviesArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        cell.addMovie(movie: movie_movie)
        for i in 0...filteredMoviesArray.count {
            if indexPath.row == i {
                cell.accessoryType = .disclosureIndicator
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            _, indexPath in
            /*
            for objectToDeleteFromMoviesArray in self.moviesArray {
                if objectToDeleteFromMoviesArray.title! == self.filteredMoviesArray[indexPath.row].title! {
                    self.moviesArray.removeAll(where: { $0.})
                }
            }*/
            
            let varTemp: String = self.filteredMoviesArray[indexPath.row].title!
            
            /*print("FILTERED")
            for i in self.filteredMoviesArray {
                print(i.title!)
                print()
            }
            print(self.filteredMoviesArray.count)
            print("DELETING NEXT ELEMENT")
            print(self.filteredMoviesArray[indexPath.row].title!)*/
            
            self.filteredMoviesArray.remove(at: indexPath.row)
            
            
            /*print("MOVIES")
            for i in self.moviesArray {
                print()
                print(i.title!)
                print()
            }
            
            print(self.moviesArray.count)
            print()
            print("DELETENIG NEXT ELEMNT")
            print(self.moviesArray[indexPath.row].title!)
            print("uuuuuuu")
            print(varTemp)*/
            self.moviesArray.removeAll(where: { $0.title == varTemp})
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            
            /*print("FILTERED")
            for i in self.filteredMoviesArray {
                print(i.title!)
                print()
            }
            print("MOVIES")
            for i in self.moviesArray {
                print(i.title!)
                print()
            }*/
        }
        return [deleteAction]
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMoviesArray = moviesArray
            tableView.reloadData()
        } else {
            func filterTableView(text:String) {
                let search = text.lowercased()
                filteredMoviesArray = moviesArray.filter({ (mod) -> Bool in return mod.title!.lowercased().contains(search)})
                self.tableView.reloadData()
                if filteredMoviesArray.count == 0 {
                    self.present(alertEmptySearch, animated: true, completion: nil)
                }
            }
            filterTableView(text: searchText)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddingMovie" {
            let secondViewController = segue.destination as! AddingMovieViewController
            secondViewController.delegate = self
        }
    }
    
    func saveData() {
        
    }
    
    func loadData() {
        
    }
    
    func parseFileAndCreateArray() -> [Movie] {
        var moviesArray: [Movie] = []
        
        let path = Bundle.main.url(forResource: "MoviesList", withExtension: "txt")
        let data = try? Data(contentsOf: path!)
        
        struct MoviesParsed: Decodable {
            var title: String
            var year: String
            var type: String
            var poster: String
            var imdbID: String
            	
            enum CodingKeys: String, CodingKey {
                case Title
                case Year
                case type = "Type"
                case Poster
                case imdbID
            }
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(title, forKey: .Title)
                try container.encode(year, forKey: .Year)
                try container.encode(type, forKey: .type)
                try container.encode(poster, forKey: .Poster)
                try container.encode(imdbID, forKey: .imdbID)
            }
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                title = try container.decode(String.self, forKey: .Title)
                year = try container.decode(String.self, forKey: .Year)
                type = try container.decode(String.self, forKey: .type)
                poster = try container.decode(String.self, forKey: .Poster)
                imdbID = try container.decode(String.self, forKey: .imdbID)
            }
        }
        
        struct MoviesListResponse: Decodable {
            enum CodingKeys: String, CodingKey {
                case Search
            }
            let Search: [MoviesParsed]
        }
        
        
        let parsedResult: MoviesListResponse = try! JSONDecoder().decode(MoviesListResponse.self, from: data!)
        
        for i in parsedResult.Search {
            var imageFromAssets: UIImage
            if i.poster.count == 0 {
                moviesArray.append(Movie(title: i.title, year: i.year, type: i.type, imdbID: i.imdbID))
            }
            else {
                imageFromAssets = UIImage(named: "\(i.poster)")!
                moviesArray.append(Movie(title: i.title, year: i.year, type: i.type, poster: imageFromAssets, imdbID: i.imdbID))
            }
        }
        return moviesArray
    }
}

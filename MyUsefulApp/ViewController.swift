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
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nothingIsFoundView: UIView!
    var activityIndicator = UIActivityIndicatorView()
    
    var moviesArray: [Movie] = []
    var filteredMoviesArray: [Movie] = []
    //var alertEmptySearch: UIAlertController!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //moviesArray = parseFileAndCreateArray()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        //searchMovies()
        print("JJJ:")
        print(moviesArray.count)
        filteredMoviesArray = moviesArray
        //alertEmptySearch = UIAlertController(title: "Alert", message: "Nothing is found!", preferredStyle: UIAlertController.Style.alert)
        //alertEmptySearch.addAction(UIAlertAction(title: "Click", style: .cancel, handler: nil))
        
        // hide keyboard while scrolling UITableView
        tableView.keyboardDismissMode = .onDrag
        //tableView.isHidden = moviesArray.isEmpty ? true : false
        tableView.isHidden = true
        nothingIsFoundView.isHidden = false
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
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
        return self.filteredMoviesArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CellsDetailsViewController.moviePressed = filteredMoviesArray[indexPath.row]
        performSegue(withIdentifier: "toDescribingInfo", sender: nil)
        view.endEditing(true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let movie_movie = filteredMoviesArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        cell.movieTitleLabel.text = self.filteredMoviesArray[indexPath.row].title
        cell.typeLabel.text = self.filteredMoviesArray[indexPath.row].type
        cell.movieYearLabel.text = self.filteredMoviesArray[indexPath.row].year
        
        let imageUrl = self.filteredMoviesArray[indexPath.row].posterURL
        let url = URL(string: imageUrl!)
        let data = try? Data(contentsOf: url!)
        if data == nil {
            cell.moviePosterView.image = UIImage()
        } else {
            cell.moviePosterView.image = UIImage(data: data!)
        }
        
        for i in 0...self.filteredMoviesArray.count {
            if indexPath.row == i {
                cell.accessoryType = .disclosureIndicator
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            _, indexPath in
            
            let varTemp: String = self.filteredMoviesArray[indexPath.row].title!
            
            self.filteredMoviesArray.remove(at: indexPath.row)
            
            self.moviesArray.removeAll(where: { $0.title == varTemp})
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            
        }
        return [deleteAction]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchMovies(findStr: String) {
        self.moviesArray = []
        self.filteredMoviesArray = []
        let findStrS = findStr.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "http://www.omdbapi.com/?apikey=7e9fe69e&s=\(findStrS)&page=1")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print("Error")
            }
            else {
                if let content = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject
                        if let search = myJson["Search"] as? [NSDictionary] {
                            print("ssss")
                            for result in search {
                                print(result["Title"]!)
                                print(result["Type"]!)
                                print(result["Poster"]!)
                                print(result["Year"]!)
                                let auxName = result["Title"]
                                let auxType = result["Type"]
                                let auxPoster = result["Poster"]
                                let auxYear = result["Year"]
                                let auxImdbID = result["imdbID"]
                                self.moviesArray.append(Movie(title: auxName as! String, year: auxYear as! String, type: auxType as! String, posterURL: auxPoster as! String, imdbID: auxImdbID as! String))
                                self.filteredMoviesArray.append(Movie(title: auxName as! String, year: auxYear as! String, type: auxType as! String, posterURL: auxPoster as! String, imdbID: auxImdbID as! String))
                                
                            }
                        }
                    }
                    catch {
                        print("Error in JSONSerialization")
                    }
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
                if self.moviesArray.isEmpty || self.filteredMoviesArray.isEmpty {
                    self.tableView.isHidden = true
                    self.nothingIsFoundView.isHidden = false
                }
            }
        }
        task.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText.count < 3 {
            filteredMoviesArray.removeAll()
            tableView.reloadData()
            tableView.isHidden = true
            nothingIsFoundView.isHidden = false
            print("Search less than 3")
        } else {
            /*func filterTableView(text: String) {
                let search = text.lowercased()
                filteredMoviesArray = moviesArray.filter({ (mod) -> Bool in return mod.title!.lowercased().contains(search)})
                self.tableView.reloadData()
                tableView.isHidden = false
                nothingIsFoundView.isHidden = true
                if filteredMoviesArray.count == 0 {
                    tableView.isHidden = true
                    nothingIsFoundView.isHidden = false
                    //self.present(alertEmptySearch, animated: true, completion: nil)
                }
            }
            filterTableView(text: searchText)*/
            tableView.isHidden = true
            activityIndicator.startAnimating()
            func foundMovieFromAPI(text: String) {
                let search = text.lowercased()
                searchMovies(findStr: search)
                self.tableView.reloadData()
                tableView.isHidden = false
                nothingIsFoundView.isHidden = true
                
            }
            print("----Before func searchMovies-----")
            print("Search greater than 3")
            print("Filtered :")
            print(filteredMoviesArray)
            print("MoviesAr :")
            print(moviesArray)
            print("---------")
            
            foundMovieFromAPI(text: searchText)
        
            print("----After func searchMovies-----")
            print("Search greater than 3")
            print("Filtered :")
            print(filteredMoviesArray)
            print("MoviesAr :")
            print(moviesArray)
            print("---------")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddingMovie" {
            let secondViewController = segue.destination as! AddingMovieViewController
            secondViewController.delegate = self
        }
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

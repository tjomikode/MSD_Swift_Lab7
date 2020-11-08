//
//  ViewController.swift
//  MyUsefulApp
//
//  Created by amooyts on 25.09.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var moviesArray: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moviesArray = parseFileAndCreateArray()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie_movie = moviesArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as! MovieTableViewCell
        cell.addMovie(movie: movie_movie)
        return cell
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
            	
            enum CodingKeys: String, CodingKey {
                case Title
                case Year
                case type = "Type"
                case Poster
            }
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(title, forKey: .Title)
                try container.encode(year, forKey: .Year)
                try container.encode(type, forKey: .type)
                try container.encode(poster, forKey: .Poster)
            }
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                title = try container.decode(String.self, forKey: .Title)
                year = try container.decode(String.self, forKey: .Year)
                type = try container.decode(String.self, forKey: .type)
                poster = try container.decode(String.self, forKey: .Poster)
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
                imageFromAssets = UIImage(named: "Poster_00")!
            }
            else {
                imageFromAssets = UIImage(named: "\(i.poster)")!
            }
            moviesArray.append(Movie(title: i.title, year: i.year, type: i.type, poster: imageFromAssets))
        }
        return moviesArray
    }
}

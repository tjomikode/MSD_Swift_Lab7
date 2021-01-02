//
//  CellsDetailsViewController.swift
//  MyUsefulApp
//
//  Created by amooyts on 16.11.2020.
//

import Foundation
import UIKit

class CellsDetailsViewController: UIViewController {
    
    @IBOutlet weak var describeImage: UIImageView!
    @IBOutlet weak var describeTitle: UILabel!
    @IBOutlet weak var describeYear: UILabel!
    @IBOutlet weak var describeGenre: UILabel!
    @IBOutlet weak var describeDirector: UILabel!
    @IBOutlet weak var describeActors: UILabel!
    @IBOutlet weak var describeCountry: UILabel!
    @IBOutlet weak var describeLanguage: UILabel!
    @IBOutlet weak var describeProduction: UILabel!
    @IBOutlet weak var describeReleased: UILabel!
    @IBOutlet weak var describeRuntime: UILabel!
    @IBOutlet weak var describeAwards: UILabel!
    @IBOutlet weak var describeRating: UILabel!
    @IBOutlet weak var describePlot: UILabel!
    @IBOutlet weak var awardsText: UILabel!
    
    static var moviePressed: Movie?
    //var movieObjDescription: Movie?
    var activityIndicator = UIActivityIndicatorView()
    
    var imageMovieDetailsUrl: String!
    var titleMovieDetails: String!
    var plotMovieDetails: String!
    var yearMovieDetails: String!
    var genreMovieDetails: String!
    var directorMovieDetails: String!
    var actorsMovieDetails: String!
    var countryMovieDetails: String!
    var languageMovieDetails: String!
    var productionMovieDetails: String!
    var releasedMovieDetails: String!
    var runtimeMovieDetails: String!
    var awardsMovieDetails: String!
    var ratingMovieDetails: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        loadMovieDetailsAPI()
        /*let tempVar = CellsDetailsViewController.moviePressed
        print(tempVar?.title as Any)
        print(tempVar?.type as Any)
        print(tempVar?.year as Any)
        print(tempVar?.awards as Any)
        movieObjDescription = parseImdbIDandCreateObjectMovie()
        describeImage.image = tempVar?.poster
        describeTitle.text = tempVar?.title
        describeYear.text = tempVar?.year
        describeGenre.text = movieObjDescription?.genre
        describeDirector.text = movieObjDescription?.director
        describeActors.text = movieObjDescription?.actors
        describeCountry.text = movieObjDescription?.country
        describeLanguage.text = movieObjDescription?.language
        describeProduction.text = movieObjDescription?.production
        describeReleased.text = movieObjDescription?.released
        describeRuntime.text = movieObjDescription?.runtime
        describeAwards.text = movieObjDescription?.awards
        describeRating.text = movieObjDescription?.imdbRating
        describePlot.text = movieObjDescription?.plot*/
    }

    /*func parseImdbIDandCreateObjectMovie() -> Movie {
        let movie: Movie = Movie()
        if CellsDetailsViewController.moviePressed?.imdbID == "" {
            return Movie()
        }
        let path = Bundle.main.url(forResource: "\(String(describing: CellsDetailsViewController.moviePressed!.imdbID!))", withExtension: "txt")
        let data = try? Data(contentsOf: path!)
        
        struct MoviesParsed: Decodable {
            var genre: String
            var director: String
            var actors: String
            var country: String
            var language: String
            var production: String
            var released: String
            var runtime: String
            var awards: String
            var rating: String
            var plot: String
            
            enum CodingKeys: String, CodingKey {
                case Genre
                case Director
                case Actors
                case Country
                case Language
                case Production
                case Released
                case Runtime
                case Awards
                case imdbRating
                case Plot
            }
            func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encode(genre, forKey: .Genre)
                try container.encode(director, forKey: .Director)
                try container.encode(actors, forKey: .Actors)
                try container.encode(country, forKey: .Country)
                try container.encode(language, forKey: .Language)
                try container.encode(production, forKey: .Production)
                try container.encode(released, forKey: .Released)
                try container.encode(runtime, forKey: .Runtime)
                try container.encode(awards, forKey: .Awards)
                try container.encode(rating, forKey: .imdbRating)
                try container.encode(plot, forKey: .Plot)
            }
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                genre = try container.decode(String.self, forKey: .Genre)
                director = try container.decode(String.self, forKey: .Director)
                actors = try container.decode(String.self, forKey: .Actors)
                country = try container.decode(String.self, forKey: .Country)
                language = try container.decode(String.self, forKey: .Language)
                production = try container.decode(String.self, forKey: .Production)
                released = try container.decode(String.self, forKey: .Released)
                runtime = try container.decode(String.self, forKey: .Runtime)
                awards = try container.decode(String.self, forKey: .Awards)
                rating = try container.decode(String.self, forKey: .imdbRating)
                plot = try container.decode(String.self, forKey: .Plot)
            }
        }
        let parsedResult: MoviesParsed = try! JSONDecoder().decode(MoviesParsed.self, from: data!)
        movie.genre = parsedResult.genre
        movie.director = parsedResult.director
        movie.actors = parsedResult.actors
        movie.country = parsedResult.country
        movie.language = parsedResult.language
        movie.production = parsedResult.production
        movie.released = parsedResult.released
        movie.runtime = parsedResult.runtime
        movie.awards = parsedResult.awards
        movie.imdbRating = parsedResult.rating
        movie.plot = parsedResult.plot
        return movie
    }*/
    
    public func loadMovieDetailsAPI() {
        let movieID: String = CellsDetailsViewController.moviePressed!.imdbID!
        let urlApi = "http://www.omdbapi.com/?apikey=7e9fe69e&i=\(movieID)"
        let url = URL(string: urlApi)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error")
            } else {
                if let content = data {
                    do {
                        let myJson = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
                        if let poster = myJson["Poster"] {
                            self.imageMovieDetailsUrl = String(describing: poster)
                        }
                        if let title = myJson["Title"] {
                            self.titleMovieDetails = String(describing: title)
                        }
                        if let plot = myJson["Plot"] {
                            self.plotMovieDetails = String(describing: plot)
                        }
                        if let year = myJson["Year"] {
                            self.yearMovieDetails = String(describing: year)
                        }
                        if let genre = myJson["Genre"] {
                            self.genreMovieDetails = String(describing: genre)
                        }
                        if let director = myJson["Director"] {
                            self.directorMovieDetails = String(describing: director)
                        }
                        if let actors = myJson["Actors"] {
                            self.actorsMovieDetails = String(describing: actors)
                        }
                        if let country = myJson["Country"] {
                            self.countryMovieDetails = String(describing: country)
                        }
                        if let language = myJson["Language"] {
                            self.languageMovieDetails = String(describing: language)
                        }
                        if let production = myJson["Production"] {
                            self.productionMovieDetails = String(describing: production)
                        }
                        if let released = myJson["Released"] {
                            self.releasedMovieDetails = String(describing: released)
                        }
                        if let runtime = myJson["Runtime"] {
                            self.runtimeMovieDetails = String(describing: runtime)
                        }
                        if let awards = myJson["Awards"] {
                            self.awardsMovieDetails = String(describing: awards)
                        }
                        if let rating = myJson["Rating"] {
                            self.ratingMovieDetails = String(describing: rating)
                        }
                        
                        let imageUrl = self.imageMovieDetailsUrl
                        let url = URL(string: imageUrl!)
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            self.describeImage.image = UIImage(data: data!)
                            self.describeTitle.text = self.titleMovieDetails
                            self.describePlot.text = self.plotMovieDetails
                            self.describeYear.text = self.yearMovieDetails
                            self.describeGenre.text = self.genreMovieDetails
                            self.describeDirector.text = self.directorMovieDetails
                            self.describeActors.text = self.actorsMovieDetails
                            self.describeCountry.text = self.countryMovieDetails
                            self.describeLanguage.text = self.languageMovieDetails
                            self.describeProduction.text = self.productionMovieDetails
                            self.describeReleased.text = self.releasedMovieDetails
                            self.describeRuntime.text = self.runtimeMovieDetails
                            self.describeAwards.text = self.awardsMovieDetails
                            self.describeRating.text = self.ratingMovieDetails
                        }
                    }
                    catch {
                        print("Error in JSONSerialization")
                    }
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
}

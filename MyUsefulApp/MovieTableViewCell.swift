//
//  MovieTableViewCell.swift
//  MyUsefulApp
//
//  Created by amooyts on 07.11.2020.
//

import Foundation
import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var moviePosterView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func addMovie(movie: Movie) {
        moviePosterView.image = movie.poster
        movieTitleLabel.text = movie.title
        movieYearLabel.text = movie.year
        typeLabel.text = movie.type
    }
}

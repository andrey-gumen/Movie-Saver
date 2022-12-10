import Combine

final class DetailsViewModel {
    
    let moviewSubject = CurrentValueSubject<Movie?, Never>(nil)
    
    init(movie: Movie?) {
        moviewSubject.value = movie
    }
    
}

import CoreData
import UIKit

final class CoreDataManager {
    static let instance = CoreDataManager()
    
    private init() {}
    
    func save(movie: Movie) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: managedContext) {
            
            let storage = NSManagedObject(entity: entity, insertInto: managedContext)
            storage.setValue(movie.title, forKey: "title")
            storage.setValue(movie.releaseDate, forKey: "releaseDate")
            storage.setValue(movie.rating, forKey: "rating")
            storage.setValue(movie.youtubeLink, forKey: "youtubeLink")
            storage.setValue(movie.poster?.pngData(), forKey: "poster")
            storage.setValue(movie.notes, forKey: "notes")
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print(error)
            }
            
        } else {
            print("ERROR")
        }
    }
    
    func getMovies() -> [Movie] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "MovieEntity")

        do {
            let objects = try managedContext.fetch(fetchRequest)
            var movies = [Movie]()
            for object in objects {
                let poster = object.value(forKey: "poster") as? Data
                
                let movie = Movie(
                    poster: poster != nil ? UIImage(data: poster!) : nil,
                    title: object.value(forKey: "title") as? String,
                    releaseDate: object.value(forKey: "releaseDate") as? Date,
                    rating: object.value(forKey: "rating") as? Float,
                    youtubeLink: object.value(forKey: "youtubeLink") as? URL,
                    notes: object.value(forKey: "title") as? String
                )
                movies.append(movie)
            }
            return movies
        } catch let error as NSError {
            print(error)
        }

        return []

    }
}

//
//  CoreDataManager.swift
//  Comer na Rua
//
//  Created by Lucas Oliveira on 04/09/21.
//

import CoreData

struct CoreDataManager {
    static var shared: CoreDataManager = {
        let instance = CoreDataManager()
        return instance
    }()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "ComerNaRuaModel")
        
        container.loadPersistentStores {
            (storeDesc, error) in
            print("Error ao carregar o Core Data (\(error)")
        }
    }
    
    func addReview(_ item: ReviewItem) {
        let review = Review(context: container.viewContext)
        review.name = item.name
        review.title = item.title
        review.date = Date()
        
        if let rating = item.rating {
            review.rating = rating
        }
        
        review.customerReview = item.customerReview
        review.uuid = item.uuid
        
        if let id = item.restaurantID {
            review.restaurantID = Int32(id)
            save()
        }
    }
    
    func addPhoto(_ item: RestaurantPhotoItem) {
        let photo = RestaurantPhoto(context: container.viewContext)
        photo.date = Date()
        photo.photo = item.photoData
        photo.uuid = item.uuid
        
        if let id = item.restaurantID {
            photo.restaurantID = Int32(id)
            save()
        }
    }
    
    func fetchReview(by identifier: Int) -> [ReviewItem] {
        let moc = container.viewContext
        
        let request: NSFetchRequest<Review> = Review.fetchRequest()
        let predicate = NSPredicate(format: "restaurantID = %i", Int32(identifier))
        
        request.predicate = predicate
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
        
        var items: [ReviewItem] = []
        
        moc.performAndWait {
            do {
                for review in try moc.fetch(request) {
                    items.append(ReviewItem(review: review))
                }
            } catch {
                fatalError("Falha ao buscar as avaliações: \(error)")
            }
        }
        
        return items
    }
    
    func fetchPhotos(by identifier: Int) -> [RestaurantPhotoItem] {
        let moc = container.viewContext
        
        let request: NSFetchRequest<RestaurantPhoto> = RestaurantPhoto.fetchRequest()
        let predicate = NSPredicate(format: "restaurantID = %i", Int32(identifier))
        
        request.predicate = predicate
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
        
        var items: [RestaurantPhotoItem] = []
        
        moc.performAndWait {
            do {
                for restaurantPhoto in try moc.fetch(request) {
                    items.append(RestaurantPhotoItem(restaurantPhoto: restaurantPhoto))
                }
            } catch {
                fatalError("Falha ao buscar as fotos: \(error)")
            }
        }
        
        return items
    }
    
    private func save() {
        container.viewContext.performAndWait {
            do {
                if container.viewContext.hasChanges {
                    try container.viewContext.save()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

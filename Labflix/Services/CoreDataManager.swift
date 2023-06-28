//
//  CoreDataManager.swift
//  Labflix
//
//  Created by Glenn Ludszuweit on 28/06/2023.
//

import Foundation
import CoreData
import Combine
import SwiftUI

protocol CoreDataProtocol {
    associatedtype Entity: NSManagedObject
    func saveData(data: [Entity]) -> AnyPublisher<Void, Error>
    func fetchData() -> AnyPublisher<[Entity], Error>
}

class CoreDataManager<T: NSManagedObject>: CoreDataProtocol {
    typealias Entity = T
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveData(data: [Entity]) -> AnyPublisher<Void, Error> {
        let subject = PassthroughSubject<Void, Error>()
        
        context.perform {
            do {
//                try self.deleteData()
                data.forEach { item in
                    let entity = T(context: self.context)
                    entity.setValues(from: item)
                }
                try self.context.save()
                subject.send()
                subject.send(completion: .finished)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    func fetchData() -> AnyPublisher<[Entity], Error> {
        let subject = PassthroughSubject<[Entity], Error>()
        
        context.perform {
            do {
                let fetchRequest: NSFetchRequest<T> = T.fetchRequest() as! NSFetchRequest<T>
                let data = try self.context.fetch(fetchRequest)
                subject.send(data)
                subject.send(completion: .finished)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        
        return subject.eraseToAnyPublisher()
    }
    
    private func deleteData() throws {
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest() as! NSFetchRequest<T>
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        try context.execute(deleteRequest)
    }
}

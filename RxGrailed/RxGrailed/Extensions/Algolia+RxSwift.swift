//
//  Algolia+RxSwift.swift
//  RxGrailed
//
//  Created by DJ Mitchell on 2/25/17.
//  Copyright © 2017 Killectro. All rights reserved.
//

import Foundation
import RxSwift
import AlgoliaSearch
import Mapper

enum MappingError: Error {
    case jsonMapping
}

extension ObservableType where E == JSONObject {

    func mapObject<T: Mappable>(_ type: T.Type, keyPath: String? = nil) -> Observable<T> {
        guard let keyPath = keyPath else {
            return mapObject(type)
        }

        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { element -> Observable<T> in
                let dictionary = element as NSDictionary

                guard
                    let objectDictionary = dictionary.value(forKeyPath: keyPath) as? NSDictionary,
                    let object = T.from(objectDictionary) else {
                        throw MappingError.jsonMapping
                }

                return Observable.just(object)
            }
            .observeOn(MainScheduler.instance)
    }

    func mapObject<T: Mappable>(_ type: T.Type) -> Observable<T> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { element -> Observable<T> in
                let dictionary = element as NSDictionary

                guard let object = T.from(dictionary) else {
                    throw MappingError.jsonMapping
                }

                return Observable.just(object)
            }
            .observeOn(MainScheduler.instance)
    }

    func mapArray<T: Mappable>(_ type: T.Type, keyPath: String) -> Observable<[T]> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { element -> Observable<[T]> in
                let dictionary = element as NSDictionary

                guard
                    let objectDictionary = dictionary.value(forKeyPath: keyPath) as? NSArray,
                    let objects = T.from(objectDictionary) else {
                        throw MappingError.jsonMapping
                }

                return Observable.just(objects)
            }
            .observeOn(MainScheduler.instance)
    }
}

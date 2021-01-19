//
//  VidatecMockService.swift
//  Vidatec
//
//  Created by Olgu SIRMAN on 10/01/2021.
//

import Foundation
import Combine
import SwiftUI

public class VidatecMockService: VidatecService {
    
    func stubbedResponse(_ filename: String) -> Data! {
        let path = Bundle.module.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
    
    public override func getRooms() -> AnyPublisher<[Room], VidatecService.Error> {
        return Just(stubbedResponse("rooms"))
            .delay(for: 2.0, scheduler: RunLoop.main)
            .tryMap { data in
                if let data = data {
                    return data
                } else {
                    throw VidatecService.Error.stubData
                }
            }
            .decode(type: [Room].self, decoder: self.decoder)
            .mapError { error in
                switch error {
                case is DecodingError:
                    return VidatecService.Error.decoding
                default:
                    if let error = error as? VidatecService.Error {
                        return error
                    }
                    return VidatecService.Error.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    public override func getPeoples() -> AnyPublisher<[Person], VidatecService.Error> {
        return Just(stubbedResponse("people"))
            .delay(for: 2.0, scheduler: RunLoop.main)
            .tryMap { data in
                if let data = data {
                    return data
                } else {
                    throw VidatecService.Error.stubData
                }
            }
            .decode(type: [Person].self, decoder: self.decoder)
            .mapError { error in
                switch error {
                case is DecodingError:
                    return VidatecService.Error.decoding
                default:
                    if let error = error as? VidatecService.Error {
                        return error
                    }
                    return VidatecService.Error.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
}

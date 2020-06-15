//
//  JSONService.swift
//  Task
//
//  Created by Азизбек on 08.06.2020.
//  Copyright © 2020 Azizbek Ismailov. All rights reserved.
//

import Foundation

class JSONService {

    static let shared = JSONService()

    private let jsonFilePath = Bundle.main.path(forResource: "Lists", ofType: "json")
    private let backgroudQueue = DispatchQueue(label: "ru.azizbek.DownloadData", qos: .userInteractive, attributes: .concurrent)

    private func readFromFile( compliton:@escaping (Data?, Error?) -> Void ) {
        guard let path = jsonFilePath else { return }
        let fileURL = URL(fileURLWithPath: path)

        do {
            let dataJson = try Data(contentsOf: fileURL, options: .mappedIfSafe)
            //            let json = try JSONSerialization.jsonObject(with: dataJson, options: [])
            print(dataJson)
            compliton(dataJson, nil)
        } catch {
            compliton(nil, error)
            print(error.localizedDescription)
        }

    }

    func parse( completion: @escaping (_ decodeData: ListsOfItems?, _ error: Error?) -> Void) {

        backgroudQueue.async {
            self.readFromFile { (data, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    completion(nil, error)
                } else {
                    do {
                        guard let unwraptedData = data else {return}
                        let decodedData = try JSONDecoder().decode(ListsOfItems.self, from: unwraptedData)
                        completion(decodedData, nil)

                    } catch {
                        print("decode error")
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

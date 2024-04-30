//
//  HomeViewModel.swift
//  DemoProject
//
//  Created by Appscrip 3Embed on 30/04/24.
//

import UIKit

class HomeViewModel {
    
    var imageResponseData: [ImageResponseModel] = []
    var page: Int = 1
    var pageSize = 10
    
    func fetchImages() async throws {
        
        let url = "\(AppConstants.BASE_URL)/photos?page=\(page)"
        
        // begining signpost
        let signpostID = SignpostLog.startSignPost(name: "fetchImages")
        
        do {
            let header = ["Authorization": "Client-ID \(AppConstants.ACCESS_KEY)"]
            let responseData = try await NetworkManager.shared.fetchData(from: url, responseType: [ImageResponseModel].self, header: header)
            
            // increment page only if pageSize is full
            if responseData.count.isMultiple(of: pageSize) {
                page += 1
            }
            
            // aggregate response
            imageResponseData.append(contentsOf: responseData)
            
            // ending signpost on success
            SignpostLog.endSignPost(name: "fetchImages", signpostID: signpostID)
            
        } catch {
            
            // ending signpost on error
            SignpostLog.endSignPost(name: "fetchImages", signpostID: signpostID)
            
            throw error
        }
        
    }
    
    func generateRandomColor() -> UIColor {
        let randomRed = CGFloat.random(in: 0...1)
        let randomGreen = CGFloat.random(in: 0...1)
        let randomBlue = CGFloat.random(in: 0...1)
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}

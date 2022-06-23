//
//  DessertListView.swift
//  FetchDesertReward
//
//  Created by Bill Calkins on 6/21/22.
//

import SwiftUI

struct DessertListView: View {
    
    @Environment(\.presentationMode) var prsentationMode
    
    var givenDesserts: [Meal] = Desserts.desertPlaceHolder.meals
    
    var body: some View {
        NavigationView {
            List(givenDesserts){ dessert in
                NavigationLink(destination: DessertDetailView(dessert: dessert)) {
                    DessertCellView(givenDessert: dessert)
                }
            }
            .navigationTitle("Desserts")
        }
    }
}

struct DessertCellView: View {
    
    let givenDessert: Meal
    
    var body: some View {
        HStack(alignment: .center, spacing: 20.0) {
            AsyncImage(url: self.givenDessert.thumbNailURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50, alignment: .leading)
            } placeholder: {
                ProgressView()
            }
            Text(givenDessert.strMeal)
        }
    }
}


// MARK: - Previews
struct DessertListView_Previews: PreviewProvider {
    static var previews: some View {
        DessertListView()
    }
}

//
//  ReviewRowView.swift
//  TapPlease!
//
//  Created by George Sigety on 4/19/23.
//

import SwiftUI

struct ReviewRowView: View {
    @State var review: Review
    var body: some View {
        VStack(alignment: .leading) {
            Text(review.title)
                .lineLimit(1)
            HStack {
                StarsSelectionView(rating: $review.rating, interactive: false, font: .callout)
                Text(review.body)
                    .font(.callout)
                    .lineLimit(1)
            }
        }
    }
}

struct ReviewRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewRowView(review: Review(title: "fantastic dish", body: "Great dish. the food is delectable.", rating: 4))
    }
}

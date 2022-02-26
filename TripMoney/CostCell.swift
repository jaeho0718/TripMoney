//
//  CostCell.swift
//  TripMoney
//
//  Created by Lee Jaeho on 2022/02/26.
//

import SwiftUI

struct CostCell: View {
    var cost: Cost

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(String(cost.cost)) 원")
                .font(.body.weight(.semibold))
            Text(cost.title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CostCell_Previews: PreviewProvider {
    static var previews: some View {
        CostCell(cost: .example)
    }
}

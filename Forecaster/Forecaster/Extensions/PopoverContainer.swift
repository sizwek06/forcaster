//
//  PopoverContainer.swift
//  Forecaster
//
//  Created by Sizwe Khathi on 2025/05/24.
//

import SwiftUICore
import UIKit

struct PopoverContainer: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard subviews.count == 1 else {
            fatalError("You need to implement your layout!")
        }
        var p = proposal
        p.width = p.width ?? UIScreen.main.bounds.width - 70
        p.height = p.height ?? UIScreen.main.bounds.height / 2

        return subviews[0].sizeThatFits(p)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        // entrusts default
    }
}

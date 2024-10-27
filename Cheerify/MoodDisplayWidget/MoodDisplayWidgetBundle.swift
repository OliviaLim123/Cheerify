//
//  MoodDisplayWidgetBundle.swift
//  MoodDisplayWidget
//
//  Created by Hang Vu on 27/10/2024.
//

import WidgetKit
import SwiftUI

@main
struct MoodDisplayWidgetBundle: WidgetBundle {
    var body: some Widget {
        MoodDisplayWidget()
        MoodDisplayWidgetControl()
    }
}

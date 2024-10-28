//
//  testFont.swift
//  Cheerify
//
//  Created by Hang Vu on 28/10/2024.
//

import SwiftUI

struct testFont: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .font(.custom("MontserratAlternates-SemiBold", size: 20))
        //  MontserratAlternates-Medium
        //  MontserratAlternates-SemiBold
        //  MontserratAlternates-Bold
        //  MontserratAlternates-Regular
        
        Text("Hi there")
            .font(.custom("FiraMono-Bold", size: 20))
        //  FiraMono-Medium
        //  FiraMono-Regular
    }
    
    //  MARK: INITALISE FONT
    init() {
        for familyName in UIFont.familyNames {
            print(familyName)
            
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("")
                print("-----🐣 \(fontName)")
            }
        }
    }
}

#Preview {
    testFont()
}

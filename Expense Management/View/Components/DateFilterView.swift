//
//  DateFilterVIew.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 13/10/24.
//

import SwiftUI

struct DateFilterView: View {
    @State var start: Date
    @State var end: Date
    
    var onSubmit: (Date, Date) -> Void
    var onClose: () -> Void
    
    var body: some View {
        VStack {
            DatePicker("Start Date", selection: $start, displayedComponents: [.date])
            DatePicker("End Date" , selection: $end, in: start..., displayedComponents: [.date])
            
            HStack(spacing: 16) {
                Button("Cancel") {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 8))
                .tint(.red)
                
                Button("Filter") {
                    onSubmit(start, end)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 8))
                .tint(appTint)
            }
            .padding(.top, 8)
        }
        .padding(16)
        .background(.bar, in: .rect(cornerRadius: 12))
        .padding(.horizontal, 32)
    }
}

#Preview {
    DateFilterView(start: .now, end: .now) { start, end in
        
    } onClose: {
        
    }

}

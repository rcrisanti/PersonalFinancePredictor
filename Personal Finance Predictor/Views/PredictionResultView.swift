//
//  PredictionResultView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/27/21.
//

import SwiftUI
import SwiftUICharts

struct PredictionResultView: View {
    @ObservedObject var viewModel: PredictionViewModel
    
    var body: some View {
        VStack {
            RangedLineChart(chartData: viewModel.chartData)
                .pointMarkers(chartData: viewModel.chartData)
                .touchOverlay(chartData: viewModel.chartData)
                .frame(height: 100)
            
            Spacer()
        }
        .navigationTitle("Chart")
    }
}

struct PredictionResultView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PredictionResultView(viewModel: .init())
        }
    }
}

//
//  StepLineChartView.swift
//  Personal Finance Predictor
//
//  Created by Ryan Crisanti on 6/27/21.
//

import SwiftUI

struct StepLineChartView: View {
    @StateObject var viewModel: StepLineChartViewModel
    
    init(dataSet: DataSet) {
        _viewModel = StateObject(wrappedValue: StepLineChartViewModel(dataSet: .init(dataSet: dataSet)))
    }
    
    var body: some View {
        VStack {
            GeometryReader { geom in
                if viewModel.isPlottable {
                    // MARK: Draw the main value line
                    Path { path in
                        var currentX = viewModel.mainLineInitial.x * Double(geom.size.width)
                        var lastY = viewModel.mainLineInitial.y * Double(geom.size.height)
                        var currentY = lastY
                        
                        path.move(to: CGPoint(x: currentX, y: currentY))
                        
                        for point in viewModel.mainLinePoints {
                            currentX = point.x * Double(geom.size.width)
                            currentY = point.y * Double(geom.size.height)
                            
                            path.addLine(to: CGPoint(x: currentX, y: lastY))
                            path.addLine(to: CGPoint(x: currentX, y: currentY))
                            
                            lastY = currentY
                        }
                    }
                    .stroke()
                    
                    Path { path in
                        // MARK: Draw the range shape top
                        path.move(to: CGPoint(x: viewModel.rangeInitial.x * Double(geom.size.width), y: viewModel.rangeInitial.y  * Double(geom.size.height)))
                        
                        for point in viewModel.rangePointsTop {
                            let currentX = point.x * Double(geom.size.width)
                            
                            path.addLine(to: CGPoint(x: currentX, y: point.lastY * Double(geom.size.height)))
                            path.addLine(to: CGPoint(x: currentX, y: point.y * Double(geom.size.height)))
                        }
                        
                        for point in viewModel.rangePointsBottom {
                            let currentY = point.nextY * Double(geom.size.height)

                            path.addLine(to: CGPoint(x: point.x * Double(geom.size.width), y: currentY))
                            path.addLine(to: CGPoint(x: point.nextX * Double(geom.size.width), y: currentY))
                        }
                        
                        path.addLine(to: CGPoint(x: viewModel.rangeInitial.x * Double(geom.size.width), y: viewModel.rangeInitial.y * Double(geom.size.height)))
                    }
//                    .stroke()
                    .foregroundColor(.red.opacity(0.4))
                } else {
                    Text("Cannot plot data with only \(viewModel.normalizedData.count) point(s)")
                }
            }
            .padding()
        }
    }
}

struct StepLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        StepLineChartView(
            dataSet: DataSet(
                data: [
                    DataPoint(
                        date: Date(),
                        value: 1,
                        minRange: -1,
                        maxRange: 3
                    ),
                    DataPoint(
                        date: Date(timeInterval: 123, since: Date()),
                        value: 2,
                        minRange: 1.4,
                        maxRange: 3
                    ),
                    DataPoint(
                        date: Date(timeInterval: 150, since: Date()),
                        value: 5,
                        minRange: 4,
                        maxRange: 7
                    ),
                    DataPoint(
                        date: Date(timeInterval: 163, since: Date()),
                        value: 3,
                        minRange: 1,
                        maxRange: 7
                    ),
                    DataPoint(
                        date: Date(timeInterval: 184, since: Date()),
                        value: 6,
                        minRange: 4,
                        maxRange: 8
                    ),
                    DataPoint(
                        date: Date(timeInterval: 199, since: Date()),
                        value: 2,
                        minRange: 0,
                        maxRange: 9
                    )
                ]
            )
        )
    }
}

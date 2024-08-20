//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Anil Reddy on 19/08/24.
//

import XCTest
@testable import Weather

final class WeatherTests: XCTestCase {
    var viewModel: WeatherViewModel?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = WeatherViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testExampleWeatherApi() {
        viewModel?.getWeather(location: "Frisco")
        XCTAssertEqual(viewModel?.weatherDetails?.cod ?? 200, 200)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

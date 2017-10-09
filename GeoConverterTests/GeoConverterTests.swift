//
//  GeoConverterTests.swift
//  GeoConverterTests
//
//  Created by SangwooLee on 2017. 7. 27..
//  Copyright © 2017년 sangwoo. All rights reserved.
//

import XCTest
@testable import GeoConverter

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

func FEATURE(_ message: String) {
    print(message)
}

func SCENARIO(_ message: String) {
    print(message)
}

func GIVEN(_ message: String) {
    print(message)
}

func WHEN(_ message: String) {
    print(message)
}

func THEN(_ message: String) {
    print(message)
}


class GeoConverterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConvertWGS84ToTM() {
        SCENARIO("WGS84 좌표를 TM 좌표로 변환한다.")
        GIVEN("Geo 좌표가 x: 127, y: 38 이다.")
        let convert = GeoConverter()
        let geoPoint = GeographicPoint(x: 127, y: 38)

        WHEN("TM 좌표로 변환했을 때")
        let tmPoint = convert.convert(sourceType: .WGS_84, destinationType: .TM, geoPoint: geoPoint)
        
        THEN("변환된 좌표가 x: 199934.8753709018, y: 499702.5110405184 과 소숫점 8자리까지 일치해야 한다.")
        XCTAssertNotNil(tmPoint)
        if let point = tmPoint {
            XCTAssertEqual(point.x, 199934.8753709018)
            XCTAssertEqual(point.y.roundTo(places: 8), 499702.5110405184.roundTo(places: 8))
        }
    }
    
    func testConvertTMToKatec() {
        SCENARIO("TM 좌표를 Katec 좌표로 변환한다.")
        GIVEN("Tm 좌표 x: 199934.8753709018, y: 499702.5110405184 이다.")
        let convert = GeoConverter()
        let tmPoint = GeographicPoint(x: 199934.8753709018, y: 499702.5110405184)
        
        WHEN("Katec 좌표로 변환했을 때")
        let katecPoint = convert.convert(sourceType: .TM, destinationType: .KATEC, geoPoint: tmPoint)
        
        THEN("변환된 좌표가 x: 312371.2593699103, y: 600172.3353855787 과 소숫점 8자리까지 일치해야 한다.")
        XCTAssertNotNil(katecPoint)
        if let point = katecPoint {
            XCTAssertEqual(point.x.roundTo(places: 8), 312371.2593699103.roundTo(places: 8))
            XCTAssertEqual(point.y.roundTo(places: 8), 600172.3353855787.roundTo(places: 8))
        }
    }
    
    func testConvertKatecToWGS84() {
        SCENARIO("Katec 좌표를 WGS84 좌표로 변환한다.")
        GIVEN("Katec 좌표 x: 312371.2593699103, y: 600172.3353855787 이다.")
        let convert = GeoConverter()
        let katecPoint = GeographicPoint(x: 312371.2593699103, y: 600172.3353855787)
        
        WHEN("Katec 좌표로 변환했을 때")
        let geoPoint = convert.convert(sourceType: .KATEC, destinationType: .WGS_84, geoPoint: katecPoint)
        
        THEN("변환된 좌표가 x: 127.00000003159674, y: 38.000000111014 과 소숫점 8자리까지 일치해야 한다.")
        XCTAssertNotNil(geoPoint)
        if let point = geoPoint {
            XCTAssertEqual(point.x.roundTo(places: 8), 127.00000003159674.roundTo(places: 8))
            XCTAssertEqual(point.y.roundTo(places: 8), 38.000000111014.roundTo(places: 8))
        }
    }
    
    func testCalculationWGS84Distance() {
        SCENARIO("2개의 WGS84 좌표간 거리를 구한다.")
        GIVEN("Geo 좌표 A(x: 127, y: 38)와 Geo 좌표 B(x:128, y: 38)이 있다.")
        let convert = GeoConverter()
        let geoPointA = GeographicPoint(x: 127, y: 38)
        let geoPointB = GeographicPoint(x: 128, y: 38)
        
        WHEN("두 좌표간의 거리를 구했을 때")
        let distance = convert.getDistanceByWGS84(from: geoPointA, to: geoPointB)
        
        THEN("계산된 거리가 87.69801962758204 과 소숫점 8자리까지 일치해야 한다.")
        XCTAssertEqual(distance.roundTo(places: 8), 87.69801962758204.roundTo(places: 8))
    }
    
    func testWGS84ToGrid() {
        SCENARIO("WGS84 좌표를 Grid 좌표로 변환한다.")
        GIVEN("WGS84 좌표 x: 126.98935225645432, y: 37.579871128849334 와")
        GIVEN("WGS84 좌표 x: 129.02478725562108, y: 35.101148844565955 와")
        GIVEN("WGS84 좌표 x: 126.54663058817043, y: 33.500946412305076 이 있다.")
        let convert = GeoConverter()
        let wgs84Point1 = GeographicPoint(x: 126.98935225645432, y: 37.579871128849334)
        let wgs84Point2 = GeographicPoint(x: 129.02478725562108, y: 35.101148844565955)
        let wgs84Point3 = GeographicPoint(x: 126.54663058817043, y: 33.500946412305076)
        
        WHEN("Grid 좌표로 변환했을 때")
        let gridPoint1 = convert.wgs84ToGrid(wgs84Point1)
        let gridPoint2 = convert.wgs84ToGrid(wgs84Point2)
        let gridPoint3 = convert.wgs84ToGrid(wgs84Point3)
        
        THEN("계산된 좌표가 x: 60, y: 127 과")
        THEN("계산된 좌표가 x: 97, y: 74 과")
        THEN("계산된 좌표가 x: 53, y: 38 이어야 한다.")
        XCTAssertNotNil(gridPoint1)
        if let point = gridPoint1 {
            XCTAssertEqual(point.x, 60)
            XCTAssertEqual(point.y, 127)
        }
        XCTAssertNotNil(gridPoint2)
        if let point = gridPoint2 {
            XCTAssertEqual(point.x, 97)
            XCTAssertEqual(point.y, 74)
        }
        XCTAssertNotNil(gridPoint3)
        if let point = gridPoint3 {
            XCTAssertEqual(point.x, 53)
            XCTAssertEqual(point.y, 38)
        }
    }
}

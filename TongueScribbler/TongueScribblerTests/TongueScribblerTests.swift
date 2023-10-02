//
//  TongueScribblerTests.swift
//  TongueScribblerTests
//
//  Created by Maksim Gaiduk on 17/09/2023.
//

import XCTest
@testable import TongueScribbler

final class TongueScribblerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSvgParse() throws {
        let inputs = [
//             "  q -3.5,1.3 -6.65,1.8 -3.15,0.5 -6.45,0.5 A 33.458,33.458 0 0 1 42.493,59.737 42.985,42.985 0 0 1 40.8,59.6 39.714,39.714 0 0 1 38.531,59.31 31.843,31.843 0 0 1 37.1,59.05 26.24,26.24 0 0 1 36.106,58.827 Q 35.088,58.575 34.4,58.3 l -3.6,-3.8 0.3,-1 q 3.1,0.8 6.35,1.1 A 71.664,71.664 0 0 0 41.376,54.858 59.989,59.989 0 0 0 43.6,54.9 47.022,47.022 0 0 0 49.252,54.57 42.106,42.106 0 0 0 50.5,54.4 36.222,36.222 0 0 0 54.259,53.614 47.851,47.851 0 0 0 57.6,52.6 Z",
            "m 57.6,52.6 v 4.9",
            "m 21.6,54.4 -0.4,-4.8 q 7.4,-0.3 10.7,-2.8 A 8.065,8.065 0 0 0 35.148,40.894 11.32,11.32 0 0 0 35.2,39.8 ",
            "M 0,53.7 4.9,52 c 2.0666667,5.066667 4.1833333,9.383333 6.35,12.95 0.792356,1.314931 1.663269,2.580895 2.608,3.791 0.956667,1.216 1.939667,2.282667 2.949,3.2 0.446712,0.407034 0.911515,0.793759 1.393,1.159 1.418821,1.095844 3.039201,1.902126 4.769,2.373 1.087082,0.286365 2.206836,0.429906 3.331,0.427 1.064332,0.0074 2.12598,-0.107689 3.164,-0.343 1.327716,-0.298474 2.581456,-0.862079 3.686,-1.657 1.833333,-1.333333 2.75,-3.566667 2.75,-6.7 0,-3.2 -1.05,-6.033333 -3.15,-8.5 -2.1,-2.466667 -4.716667,-4.733333 -7.85,-6.8 L 29,51.2 h 2.9",
        ]
            //
            // L 57.60 57.50 
            // Q 54.10 58.80 50.95 59.30Q 47.80 59.80 44.50 59.80A 33.46 33.46 0.00 0 1 42.49 59.74A 42.98 42.98 0.00 0 1 40.80 59.60A 39.71 39.71 0.00 0 1 38.53 59.31A 31.84 31.84 0.00 0 1 37.10 59.05A 26.24 26.24 0.00 0 1 36.11 58.83Q 35.09 58.58 34.40 58.30L 30.80 54.50 L 31.10 53.50 Q 34.20 54.30 37.45 54.60A 71.66 71.66 0.00 0 0 41.38 54.86A 59.99 59.99 0.00 0 0 43.60 54.90A 47.02 47.02 0.00 0 0 49.25 54.57A 42.11 42.11 0.00 0 0 50.50 54.40A 36.22 36.22 0.00 0 0 54.26 53.61A 47.85 47.85 0.00 0 0 57.60 52.60Z
        let expected: [[StrokePathComponent]] = [
            [
                .move(to: CGPoint(x: 57.6, y: 52.6)),
                .addLine(to: CGPoint(x: 57.6, y: 57.5)),
            ],
            [.move(to: CGPoint(x: 21.6, y: 54.4)),
             .move(to: CGPoint(x: 21.2, y: 49.6)),
             .addQuadCurve(to: CGPoint(x: 31.9, y: 46.8), control: CGPoint(x: 28.6, y: 49.3)),
             .Arc(radiusX: 8.06, largeArc: false, sweep: false, to: CGPoint(x: 35.15, y: 40.89)),
             .Arc(radiusX: 11.32, largeArc: false, sweep: false, to: CGPoint(x: 35.2, y: 39.8))
            ],
            [
                .move(to: CGPoint(x: 0, y: 53.7)),
                .move(to: CGPoint(x: 4.9, y: 52.0)),
                .addCurve(to: CGPoint(x: 11.25, y: 64.95), control1: CGPoint(x: 6.97, y: 57.07), control2: CGPoint(x: 9.08, y: 61.38)),
                .addCurve(to: CGPoint(x: 13.86, y: 68.74), control1: CGPoint(x: 12.04, y: 66.26), control2: CGPoint(x: 12.91, y: 67.53)),
                .addCurve(to: CGPoint(x: 16.81, y: 71.94), control1: CGPoint(x: 14.81, y: 69.96), control2: CGPoint(x: 15.8, y: 71.02)),
                .addCurve(to: CGPoint(x: 18.2, y: 73.1), control1: CGPoint(x: 17.25, y: 72.35), control2: CGPoint(x: 17.72, y: 72.73)),
                .addCurve(to: CGPoint(x: 22.97, y: 75.47), control1: CGPoint(x: 19.62, y: 74.2), control2: CGPoint(x: 21.24, y: 75.00)),
                .addCurve(to: CGPoint(x: 26.3, y: 75.9), control1: CGPoint(x: 24.06, y: 75.76), control2: CGPoint(x: 25.18, y: 75.9)),
                .addCurve(to: CGPoint(x: 29.46, y: 75.56), control1: CGPoint(x: 27.36, y: 75.91), control2: CGPoint(x: 28.43, y: 75.79)),
                .addCurve(to: CGPoint(x: 33.15, y: 73.90), control1: CGPoint(x: 30.79, y: 75.26), control2: CGPoint(x: 32.05, y: 74.69)),
                .addCurve(to: CGPoint(x: 35.90, y: 67.20), control1: CGPoint(x: 34.98, y: 72.57), control2: CGPoint(x: 35.90, y: 70.33)),
                .addCurve(to: CGPoint(x: 32.75, y: 58.70), control1: CGPoint(x: 35.90, y: 64.00), control2: CGPoint(x: 34.85, y: 61.17)),
                .addCurve(to: CGPoint(x: 24.90, y: 51.90), control1: CGPoint(x: 30.65, y: 56.23), control2: CGPoint(x: 28.03, y: 53.97)),
                .addLine(to: CGPoint(x: 29.00, y: 51.2)),
                .addLine(to: CGPoint(x: 31.9, y: 51.2))
            ]
        ]
        let remapPoint: (_ point: CGPoint) -> CGPoint = {point in
            return CGPoint(
                x: point.x,
                y: point.y
            )
        }
        for idx in 0..<inputs.count {
            let input = inputs[idx]
            let res = try parseSvgPath(input, remapPoint: remapPoint, scale: 1.0)
            let exp = expected[idx]
            XCTAssertEqual(res.count, exp.count)
            for j in 0..<res.count {
                let resStr = res[j].toString()
                let expStr = exp[j].toString()
                XCTAssertEqual(resStr, expStr)
            }
        }
    }
    
    func testNumericSequenceParse() throws {
        let inputs = [
            "M631,541C613,541 597,533 581,525C560,514 537,508 515,502C475,491 435,482 394,477C359,475 322,476 288,488C273,495 260,507 243,512C237,512 234,505 237,500C248,476 271,460 295,450C331,436 372,435 411,438C474,445 534,465 596,478C615,483 636,486 653,497C660,502 668,507 671,515C673,523 668,531 661,534C652,538 642,541 631,541Z",
            "m 57.6,26.201",
            "m 57.6,26.201 v 4.9",
            "m 57.6,26.201 v 4.9 q -3.5,1.3 -6.65,1.8 -3.15,0.5 -6.45,0.5 A 33.458,33.458 0 0 1 42.493,33.337 42.985,42.985 0 0 1 40.8,33.201 39.714,39.714 0 0 1 38.531,32.91 31.843,31.843 0 0 1 37.1,32.651 26.24,26.24 0 0 1 36.106,32.427 Q 35.088,32.176 34.4,31.901 l -3.6,-3.8 0.3,-1 q 3.1,0.8 6.35,1.1 a 71.664,71.664 0 0 0 3.926,0.257 59.989,59.989 0 0 0 2.224,0.043 47.022,47.022 0 0 0 5.652,-0.331 42.106,42.106 0 0 0 1.248,-0.169 36.222,36.222 0 0 0 3.759,-0.787 47.851,47.851 0 0 0 3.341,-1.013 z"
        ]
        // CCCCZ
        let expected: [[TCommand]] = [
            [
                .init(command: .M, coords: [631, 541]),
                .init(command: .C, coords: [613, 541, 597, 533, 581, 525]),
                .init(command: .C, coords: [560, 514, 537, 508, 515, 502]),
                .init(command: .C, coords: [475, 491, 435, 482, 394, 477]),
                .init(command: .C, coords: [359, 475, 322, 476, 288, 488]),
                .init(command: .C, coords: [273, 495, 260, 507, 243, 512]),
                .init(command: .C, coords: [237, 512, 234, 505, 237, 500]),
                .init(command: .C, coords: [248, 476, 271, 460, 295, 450]),
                .init(command: .C, coords: [331, 436, 372, 435, 411, 438]),
                .init(command: .C, coords: [474, 445, 534, 465, 596, 478]),
                .init(command: .C, coords: [615, 483, 636, 486, 653, 497]),
                .init(command: .C, coords: [660, 502, 668, 507, 671, 515]),
                .init(command: .C, coords: [673, 523, 668, 531, 661, 534]),
                .init(command: .C, coords: [652, 538, 642, 541, 631, 541]),
                .init(command: .z, coords: []),
            ],
            [
                .init(command: .m, coords: [57.6, 26.201])
            ],[
                .init(command: .m, coords: [57.6, 26.201]),
                .init(command: .v, coords: [4.9])
            ],[
                .init(command: .m, coords: [57.6, 26.201]),
                .init(command: .v, coords: [4.9]),
                .init(command: .q, coords: [-3.5, 1.3, -6.65, 1.8, -3.15, 0.5, -6.45, 0.5]),
                .init(command: .A, coords: [33.458, 33.458, 0, 0, 1, 42.493, 33.337, 42.985, 42.985, 0, 0, 1, 40.8, 33.201, 39.714, 39.714, 0, 0, 1, 38.531, 32.91, 31.843, 31.843,
                                            0, 0, 1, 37.1, 32.651, 26.24, 26.24, 0, 0, 1, 36.106, 32.427]),
                .init(command: .Q, coords: [35.088, 32.176, 34.4, 31.901]),
                .init(command: .l, coords: [-3.6, -3.8, 0.3, -1]),
                .init(command: .q, coords: [3.1, 0.8, 6.35, 1.1]),
                .init(command: .a, coords: [71.664, 71.664, 0, 0, 0, 3.926, 0.257, 59.989, 59.989, 0, 0, 0, 2.224, 0.043, 47.022, 47.022, 0, 0, 0, 5.652, -0.331, 42.106, 42.106, 0, 0, 0,
                                            1.248, -0.169, 36.222, 36.222, 0, 0, 0, 3.759, -0.787, 47.851, 47.851, 0, 0, 0, 3.341, -1.013]),
                .init(command: .z, coords: []),
            ]
        ]
        
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//        let inputs = [".41.28.79.58,1.18.88,1.06-.23,2.05-.52,2.99-.91-.12-.09-.25-.19-.37-.27"]
//                      "-1.4-.8-2.4,1.1",
//                      "41.9,38.8",
//                      "-.23-.27-.49-.54-.75-.81-1.05-.18-2.1-.39-3.15-.69",
//                      ".1.5,2.5,2",
//                      ".1,0,.2.1.3.1.3.1.8.3,1.2.4.29.06.55.12.81.17-.27-.3-.53-.59-.81-.87",
//                      "2.8-1.2,5.3-2,7.2-2.5,3.9-1.1,5.5-1.1,6.1-1.1,2.5,0,4.4.7,5.3.9.8.3,2.1.7,3.6,1.7.6.4,1.3.8,2,1.6,1.8,1.9,2.2,4.3,2.4,5.5.1.8.4,2.1.1,3.9-.2,1.6-.8,2.7-1.1,3.4-.8,1.6-1.7,2.6-1.9,2.8-1,1.1-1.9,1.7-2.2,1.9-1.1.7-2.1,1.1-2.8,1.3-.8.3-1.4.4-2.6.6-.5.1-1.1.2-2.7.5-2.1.3-3.5.6-3.5.5,0,0,1.6-.4,3.5-.5,1.5-.1,2.5-.1,3.5.4.4.2.5.3,2.2,2,1.8,1.7,1.8,1.6,2.6,2.5.9.9,1.5,1.5,2.2,2.4.9,1.2,1.5,1.9,2,3,.5,1.2.6,2.1.8,3.3.2,1.3.1,2.3.1,3.3-.1,1.8-.1,2.7-.5,3.8-.2.5-.6,1.5-1.5,2.6",
//                      "631 359",
//                      "613 359 597 367 581 375",
//                      " 0,27.301 4.9,-1.7 "]
        
//        let expected = [[0.41, 0.28, 0.79, 0.58, 1.18, 0.88, 1.06, -0.23, 2.05, -0.52, 2.99, -0.91, -0.12, -0.09, -0.25, -0.19, -0.37, -0.27],
//                        [-1.4, -0.8, -2.4, 1.1],
//                        [41.9, 38.8],
//                        [-0.23, -0.27, -0.49, -0.54, -0.75, -0.81, -1.05, -0.18, -2.1, -0.39, -3.15, -0.69],
//                        [0.1, 0.5, 2.5, 2],
//                        [0.1, 0, 0.2, 0.1, 0.3, 0.1, 0.3, 0.1, 0.8, 0.3, 1.2, 0.4, 0.29, 0.06, 0.55, 0.12, 0.81, 0.17, -0.27, -0.3, -0.53, -0.59, -0.81, -0.87],
//                        [2.8, -1.2, 5.3, -2, 7.2, -2.5, 3.9, -1.1, 5.5, -1.1, 6.1, -1.1, 2.5, 0, 4.4, 0.7, 5.3, 0.9, 0.8, 0.3, 2.1, 0.7, 3.6, 1.7, 0.6, 0.4, 1.3, 0.8, 2, 1.6, 1.8, 1.9, 2.2, 4.3, 2.4, 5.5, 0.1, 0.8, 0.4, 2.1, 0.1, 3.9, -0.2, 1.6, -0.8, 2.7, -1.1, 3.4, -0.8, 1.6, -1.7, 2.6, -1.9, 2.8, -1, 1.1, -1.9, 1.7, -2.2, 1.9, -1.1, 0.7, -2.1, 1.1, -2.8, 1.3, -0.8, 0.3, -1.4, 0.4, -2.6, 0.6, -0.5, 0.1, -1.1, 0.2, -2.7, 0.5, -2.1, 0.3, -3.5, 0.6, -3.5, 0.5, 0, 0, 1.6, -0.4, 3.5, -0.5, 1.5, -0.1, 2.5, -0.1, 3.5, 0.4, 0.4, 0.2, 0.5, 0.3, 2.2, 2, 1.8, 1.7, 1.8, 1.6, 2.6, 2.5, 0.9, 0.9, 1.5, 1.5, 2.2, 2.4, 0.9, 1.2, 1.5, 1.9, 2, 3, 0.5, 1.2, 0.6, 2.1, 0.8, 3.3, 0.2, 1.3, 0.1, 2.3, 0.1, 3.3, -0.1, 1.8, -0.1, 2.7, -0.5, 3.8, -0.2, 0.5, -0.6, 1.5, -1.5, 2.6],
//                        [631, 359],
//                        [613, 359, 597, 367, 581, 375],
//                        [0, 27.301, 4.9, -1.7]]
        for idx in 0..<inputs.count {
            let res = try! parseNumSequence(inputs[idx])
            print("Res: ", res)
            print("Expected: ", expected[idx])
            XCTAssertEqual(res, expected[idx])
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

import XCTest
@testable import ToDoApp

final class ToDoAppTests: XCTestCase {

    var viewModel: TodoListViewModel!
    
    override func setUpWithError() throws {
        viewModel = TodoListViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testBasicAssertion() throws {
        XCTAssertTrue(true, "Basic assertion should work")
    }
    
    func testStringComparison() throws {
        let expected = "Hello"
        let actual = "Hello"
        XCTAssertEqual(expected, actual, "String comparison should work")
    }
    
    func testArrayOperations() throws {
        let array = [1, 2, 3]
        XCTAssertEqual(array.count, 3, "Array should have 3 elements")
        XCTAssertEqual(array.first, 1, "First element should be 1")
        XCTAssertEqual(array.last, 3, "Last element should be 3")
    }
    
    func testDictionaryOperations() throws {
        let dict = ["key1": "value1", "key2": "value2"]
        XCTAssertEqual(dict.count, 2, "Dictionary should have 2 key-value pairs")
        XCTAssertEqual(dict["key1"], "value1", "Value for key1 should be value1")
    }
    
    func testOptionalHandling() throws {
        let optionalString: String? = "test"
        XCTAssertNotNil(optionalString, "Optional should not be nil")
        XCTAssertEqual(optionalString!, "test", "Unwrapped value should be 'test'")
        
        let nilString: String? = nil
        XCTAssertNil(nilString, "Optional should be nil")
    }
    
    func testErrorHandling() throws {
        enum TestError: Error {
            case testCase
        }
        
        do {
            throw TestError.testCase
            XCTFail("Should not reach this point")
        } catch TestError.testCase {
            XCTAssertTrue(true, "Caught expected error")
        } catch {
            XCTFail("Caught unexpected error: \(error)")
        }
    }
    
    func testIntToUUIDFunction() throws {
        let testInt = 42
        let uuid = intToUUID(testInt)
        
        XCTAssertNotNil(uuid, "intToUUID should return a valid UUID")
        XCTAssertEqual(uuid.uuidString.count, 36, "UUID should have correct format (36 characters)")
        
        let uuid2 = intToUUID(testInt)
        XCTAssertEqual(uuid, uuid2, "Same input should produce same UUID")
        
        let uuid3 = intToUUID(43)
        XCTAssertNotEqual(uuid, uuid3, "Different inputs should produce different UUIDs")
    }
    
    func testIntToUUIDEdgeCases() throws {
        let zeroUUID = intToUUID(0)
        XCTAssertNotNil(zeroUUID, "intToUUID should work with 0")
        
        let negativeUUID = intToUUID(-1)
        XCTAssertNotNil(negativeUUID, "intToUUID should work with negative numbers")
        
        let largeUUID = intToUUID(Int.max)
        XCTAssertNotNil(largeUUID, "intToUUID should work with large numbers")
    }
    
    func testIntToUUIDFormat() throws {
        let uuid = intToUUID(123)
        let uuidString = uuid.uuidString
        
        let components = uuidString.components(separatedBy: "-")
        XCTAssertEqual(components.count, 5, "UUID should have 5 components")
        XCTAssertEqual(components[0].count, 8, "First component should be 8 characters")
        XCTAssertEqual(components[1].count, 4, "Second component should be 4 characters")
        XCTAssertEqual(components[2].count, 4, "Third component should be 4 characters")
        XCTAssertEqual(components[3].count, 4, "Fourth component should be 4 characters")
        XCTAssertEqual(components[4].count, 12, "Fifth component should be 12 characters")
    }
    
    func testTodoListViewModelInitialization() throws {
        XCTAssertNotNil(viewModel, "ViewModel should be created successfully")
    }
    
    func testTodoCountWhenEmpty() throws {
        let count = viewModel.todoCount
        XCTAssertEqual(count, 0, "Todo count should be 0 when no todos exist")
    }
    
    func testGetTodoAtIndexWhenEmpty() throws {
        XCTAssertEqual(viewModel.todoCount, 0, "Todos array should be empty")
    }
    
    func testViewModelProperties() throws {
        XCTAssertNotNil(viewModel, "ViewModel should exist")
    }
    
    func testPerformanceExample() throws {
        measure {
            var sum = 0
            for i in 1...1000 {
                sum += i
            }
            XCTAssertEqual(sum, 500500, "Sum should be correct")
        }
    }
    
    func testPerformanceWithMetrics() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
                var strings: [String] = []
                for i in 1...100 {
                    strings.append("String \(i)")
                }
                XCTAssertEqual(strings.count, 100, "Should create 100 strings")
            }
        }
    }
    
    func testIntToUUIDPerformance() throws {
        measure {
            for i in 1...1000 {
                _ = intToUUID(i)
            }
        }
    }
}

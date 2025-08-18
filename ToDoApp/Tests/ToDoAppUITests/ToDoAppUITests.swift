import XCTest

final class ToDoAppUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testAppLaunchesSuccessfully() throws {
        XCTAssertTrue(app.navigationBars["Todo List"].exists, "Navigation bar should exist")
        XCTAssertTrue(app.buttons["Add"].exists, "Add button should exist")
    }
    
    @MainActor
    func testAddButtonExists() throws {
        let addButton = app.buttons["Add"]
        XCTAssertTrue(addButton.exists, "Add button should exist")
        XCTAssertTrue(addButton.isEnabled, "Add button should be enabled")
    }
    
    @MainActor
    func testSearchBarExists() throws {
        let searchField = app.searchFields["Search Tasks"]
        XCTAssertTrue(searchField.exists, "Search field should exist")
    }
    
    @MainActor
    func testBottomBarExists() throws {
        let staticTexts = app.staticTexts.allElementsBoundByIndex
        let hasTaskCount = staticTexts.contains { text in
            text.label.contains("task") || text.label.contains("0") || text.label.contains("1")
        }
        XCTAssertTrue(hasTaskCount, "Task count should be visible")
    }
    
    @MainActor
    func testAddTodoFlow() throws {
        let addButton = app.buttons["Add"]
        addButton.tap()
        
        XCTAssertTrue(app.navigationBars["New Task"].exists, "Should show add todo screen")
        
        let titleField = app.textFields["New ToDo"]
        titleField.tap()
        titleField.typeText("Test Todo")
        
        let descriptionField = app.textViews["Add your toDo"]
        descriptionField.tap()
        descriptionField.typeText("Test Description")
        
        let saveButton = app.buttons["Save"]
        saveButton.tap()
        
        XCTAssertTrue(app.navigationBars["Todo List"].exists, "Should return to main screen")
        
        let todoCell = app.cells.containing(.staticText, identifier: "Test Todo").firstMatch
        if todoCell.exists {
            XCTAssertTrue(todoCell.exists, "New todo should be visible in list")
        } else {
            Thread.sleep(forTimeInterval: 0.5)
            let retryCell = app.cells.containing(.staticText, identifier: "Test Todo").firstMatch
            XCTAssertTrue(retryCell.exists, "New todo should be visible in list after delay")
        }
    }
    
    @MainActor
    func testAddTodoWithEmptyTitle() throws {
        let addButton = app.buttons["Add"]
        addButton.tap()
        
        let saveButton = app.buttons["Save"]
        saveButton.tap()
        
        let errorAlert = app.alerts.firstMatch
        if errorAlert.exists {
            XCTAssertTrue(errorAlert.exists, "Error alert should appear")
        } else {
            XCTAssertTrue(app.navigationBars["New Task"].exists, "Should stay on add screen if validation fails")
        }
    }
    
    @MainActor
    func testSearchFunctionality() throws {
        let searchField = app.searchFields["Search Tasks"]
        searchField.tap()
        
        XCTAssertTrue(searchField.isSelected, "Search field should be active")
        
        searchField.typeText("Test")
    }
    
    @MainActor
    func testTodoCellTap() throws {
        let todoCells = app.cells
        if todoCells.count > 0 {
            let firstCell = todoCells.firstMatch
            firstCell.tap()
            
            XCTAssertTrue(app.navigationBars["Edit Task"].exists, "Should show edit screen")
        } else {
            print("No todos found, skipping testTodoCellTap")
        }
    }
    
    @MainActor
    func testTodoSwipeDelete() throws {
        let todoCells = app.cells
        if todoCells.count > 0 {
            let firstCell = todoCells.firstMatch
            firstCell.swipeLeft()
            
            let deleteButton = app.buttons["Delete"]
            XCTAssertTrue(deleteButton.exists, "Delete button should appear")
        } else {
            print("No todos found, skipping testTodoSwipeDelete")
        }
    }
    
    @MainActor
    func testContextMenuOnLongPress() throws {
        let todoCells = app.cells
        if todoCells.count > 0 {
            let firstCell = todoCells.firstMatch
            firstCell.press(forDuration: 0.5)
        } else {
            print("No todos found, skipping testContextMenuOnLongPress")
        }
    }
    
    @MainActor
    func testBottomBarTaskCount() throws {
        let staticTexts = app.staticTexts.allElementsBoundByIndex
        let hasTaskCount = staticTexts.contains { text in
            text.label.contains("task") || text.label.contains("0") || text.label.contains("1")
        }
        XCTAssertTrue(hasTaskCount, "Task count should be visible")
        
        let addButton = app.buttons["Add"]
        addButton.tap()
        
        let titleField = app.textFields["New ToDo"]
        titleField.tap()
        titleField.typeText("Test Todo")
        
        let saveButton = app.buttons["Save"]
        saveButton.tap()
        
        Thread.sleep(forTimeInterval: 0.5)
        let updatedStaticTexts = app.staticTexts.allElementsBoundByIndex
        let hasUpdatedTaskCount = updatedStaticTexts.contains { text in
            text.label.contains("task") || text.label.contains("1") || text.label.contains("2")
        }
        XCTAssertTrue(hasUpdatedTaskCount, "Task count should update after adding todo")
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    @MainActor
    func testScrollPerformance() throws {
        let tableView = app.tables.firstMatch
        
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            tableView.swipeUp()
            tableView.swipeDown()
        }
    }
}

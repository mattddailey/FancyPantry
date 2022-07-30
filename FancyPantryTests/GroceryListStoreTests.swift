//
//  GroceryListStoreTests.swift
//  FancyPantryTests
//
//  Created by Matt Dailey on 7/30/22.
//
import Combine
import XCTest
@testable import FancyPantry

class GroceryListStoreTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []
    private var mockApiClient: MockAPICLient!
    private var groceryListStore: GroceryListStore!

    @MainActor override func setUpWithError() throws {
        self.mockApiClient = MockAPICLient()
        self.groceryListStore = GroceryListStore(apiClient: mockApiClient)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        cancellables.removeAll()
        self.groceryListStore = nil
        try super.tearDownWithError()
    }

    func testFetchGroceries_Success_ReturnsGroceries() async {
        // GIVEN the expectation that the fetchGroceries function of the apiClient will be called
        let fetchExpectation = XCTestExpectation(description: "mockAPIClient fetch called")
        mockApiClient.fetchGroceriesExeuction = {
            fetchExpectation.fulfill()
        }
        
        // and GIVEN the expectation the groceries variable should be updated
        let groceriesUpdatedExpectation = XCTestExpectation(description: "groceries updated")
        await groceryListStore.$groceries
            .dropFirst()
            .sink { groceries in
                XCTAssertEqual(groceries.count, 2)
                XCTAssertEqual(groceries, [
                    Grocery(id: 1,
                            title: "Eggs",
                            active: 0),
                    Grocery(id: 2,
                            title: "Apples",
                            active: 1)
                ])
                groceriesUpdatedExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // WHEN the fetchGroceries call is made
        await groceryListStore.fetchGroceries()
        
        // THEN the expectations should be fulfilled
        wait(for: [fetchExpectation, groceriesUpdatedExpectation], timeout: 0.5)
    }
    
    func testFetchGroceries_ThrowsAPIError_PresentsAlert() async {
        // GIVEN the expectation that the apiClient will throw an APIError
        mockApiClient.apiError = .invalidURL
        
        // and GIVEN the expectation that the fetchGroceries function of the apiClient will be called
        let fetchExpectation = XCTestExpectation(description: "mockAPIClient fetch called")
        mockApiClient.fetchGroceriesExeuction = {
            fetchExpectation.fulfill()
        }
        
        // and GIVEN the expectation the appError value will be set
        let appErrorExpectation = XCTestExpectation(description: "appError updated")
        await groceryListStore.$appError
            .dropFirst()
            .sink { appError in
                XCTAssertEqual(appError?.error, .invalidURL)
                appErrorExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // and GIVEN the expectation the presentAlert value will be set
        let presentAlertExpectation = XCTestExpectation(description: "presentAlert set to true")
        await groceryListStore.$presentAlert
            .dropFirst()
            .sink { presentAlert in
                XCTAssertTrue(presentAlert)
                presentAlertExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        
        // WHEN the fetchGroceries call is made
        await groceryListStore.fetchGroceries()
        
        // THEN the expectations should be fulfilled
        wait(for: [fetchExpectation, appErrorExpectation, presentAlertExpectation], timeout: 0.5)
    }
    
    func testUpdateGrocery_Success_ReturnsGroceries() async {
        // GIVEN the expectation that the updateGrocery function of the apiClient will be called
        let updateExpectation = XCTestExpectation(description: "mockAPIClient update called")
        mockApiClient.updateGroceryExecution = { grocery in
            XCTAssertEqual(grocery, Grocery(id: 1,
                                            title: "Eggs",
                                            active: 1))
            updateExpectation.fulfill()
        }
        
        // and GIVEN the expectation the groceries variable should be updated
        let groceriesUpdatedExpectation = XCTestExpectation(description: "groceries updated")
        await groceryListStore.$groceries
            .dropFirst()
            .sink { groceries in
                XCTAssertEqual(groceries.count, 2)
                XCTAssertEqual(groceries, [
                    Grocery(id: 1,
                            title: "Eggs",
                            active: 1),
                    Grocery(id: 2,
                            title: "Apples",
                            active: 1)
                ])
                groceriesUpdatedExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // WHEN the updateGroceryActive call is made
        await groceryListStore.updateGroceryActive(grocery: Grocery(id: 1,
                                                                    title: "Eggs",
                                                                    active: 0))
        
        // THEN the expectations should be fulfilled
        wait(for: [updateExpectation, groceriesUpdatedExpectation], timeout: 0.5)
    }
    
    func testUpdateGrocery_ThrowsAPIError_PresentsAlert() async {
        // GIVEN the expectation that the apiClient will throw an APIError
        mockApiClient.apiError = .invalidURL
        
        // GIVEN the expectation that the updateGrocery function of the apiClient will be called
        let updateExpectation = XCTestExpectation(description: "mockAPIClient update called")
        mockApiClient.updateGroceryExecution = { grocery in
            XCTAssertEqual(grocery, Grocery(id: 1,
                                            title: "Eggs",
                                            active: 1))
            updateExpectation.fulfill()
        }
        
        // and GIVEN the expectation the appError value will be set
        let appErrorExpectation = XCTestExpectation(description: "appError updated")
        await groceryListStore.$appError
            .dropFirst()
            .sink { appError in
                XCTAssertEqual(appError?.error, .invalidURL)
                appErrorExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // and GIVEN the expectation the presentAlert value will be set
        let presentAlertExpectation = XCTestExpectation(description: "presentAlert set to true")
        await groceryListStore.$presentAlert
            .dropFirst()
            .sink { presentAlert in
                XCTAssertTrue(presentAlert)
                presentAlertExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // WHEN the updateGroceryActive call is made
        await groceryListStore.updateGroceryActive(grocery: Grocery(id: 1,
                                                                    title: "Eggs",
                                                                    active: 0))
        
        // THEN the expectations should be fulfilled
        wait(for: [updateExpectation, appErrorExpectation, presentAlertExpectation], timeout: 0.5)
    }
}

import Foundation
import XCTest
import Nimble
@testable import teferi

class DateExtensionsTests : XCTestCase
{
    //MARK: Fields
    private var calendar : Calendar = Calendar.current
    
    //MARK: Test lifecycle
    override func setUp()
    {
        calendar = Calendar.current
    }
    
    //MARK: Tests
    func testTheAddDaysMethodAddsNDaysToTheCurrentDate()
    {
        var components = DateComponents()
        components.day = 10
        components.month = 10
        components.year = 2016
        let octoberTen = calendar.date(from: components)!
        let octoberThirteen = octoberTen.add(days: 3)
        
        let newComponents = (calendar as Calendar).dateComponents([.day], from: octoberThirteen)
        expect(newComponents.day).to(equal(13))
    }
    
    func testTheAddDaysMethodRemovesDaysFromTheCurrentDateIfTheParameterIsNegative()
    {
        var components = DateComponents()
        components.day = 10
        components.month = 10
        components.year = 2016
        let octoberTen = calendar.date(from: components)!
        let octoberEight = octoberTen.add(days: -2)
        
        let newComponents = (calendar as Calendar).dateComponents([.day], from: octoberEight)
        expect(newComponents.day).to(equal(8))
    }
    
    func testTheAddDaysMethodWorksEvenOnTheEndOfMonth()
    {
        var components = DateComponents()
        components.day = 31
        components.month = 10
        components.year = 2016
        let halloween = calendar.date(from: components)!
        let novemberFirst = halloween.add(days: 1)
        
        let newComponents = (calendar as Calendar).dateComponents([.day, .month], from: novemberFirst)
        
        expect(newComponents.day).to(equal(1))
        expect(newComponents.month).to(equal(11))
    }
    
    func testTheIgnoreTimeComponentsMethodReturnOnlyTheDatePortionOfADate()
    {
        var components = DateComponents()
        components.day = 31
        components.month = 10
        components.year = 2016
        components.hour = 12
        let date = calendar.date(from: components)!
        
        var components2 = DateComponents()
        components2.day = 31
        components2.month = 10
        components2.year = 2016
        components.hour = 13
        let date2 = calendar.date(from: components2)!
        
        expect(date.ignoreTimeComponents()).to(equal(date2.ignoreTimeComponents()))
    }
}

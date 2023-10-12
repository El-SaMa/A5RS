*** Settings ***
Library    SeleniumLibrary
Library    BuiltIn
Library    String

*** Test Cases ***
Go to Blazedemo webpage
    # Go to the page http://blazedemo.com/
    Open Browser    http://blazedemo.com
    ...    Chrome    options=add_experimental_option("detach", True)

    Sleep    1
    Maximize Browser Window
    Sleep    1
    # Check that the page says "Welcome to the Simple Travel Agency!"
    Page Should Contain    Welcome to the Simple Travel Agency!

    Sleep    2

*** Test Cases ***
Choose your departure and destination
    # Select "Boston" as the starting city
    Click Element    name:fromPort
    ${depart}=    Select From List By Value    name:fromPort    Boston
    ${depart}=    Get Selected List Value    name:fromPort
    Set Suite Variable    ${departure}    ${depart}
   
    # Select "Cairo" as the destination
    Click Element    name:toPort
    ${destin}=    Select From List By Value    name:toPort    Cairo
    ${destin}=    Get Selected List Value    name:toPort
    Set Suite Variable   ${destination}    ${destin}

    Log To Console    Departure: ${departure}, Destination: ${destination}

*** Test Cases ***
"Find Flights" button is usable
    # Check that the "Find Flights" button is selectable
    Page Should Contain Button    xpath://html/body/div[3]/form/div/input
    # Click the "Find Flights" button
    Click Button    xpath://input[@value='Find Flights']

    Sleep    1

*** Test Cases ***
Check the results and pick your flight
    # Check that the page says "Flights from Boston to Cairo:" (using the created variables for city names)
    Page Should Contain    Flights from ${departure} to ${destination}

    # Check that at least one flight choice is visible
    Page Should Contain Element    xpath://html/body/div[2]/table/tbody/tr[1]/td[1]    # Grid cell element (or row) works
    
    # Select one of the flights and store the price, number, and airline of that flight in separate variables
    ${price}=    Get Text    xpath:/html/body/div[2]/table/tbody/tr[5]/td[6]    # xpath
    ${price}=    Set Variable    ${price}

    ${company}=    Get Text    xpath:/html/body/div[2]/table/tbody/tr[5]/td[3]    # xpath
    ${company}=    Set Variable    ${company}

    ${flightno}=    Get Text    xpath:/html/body/div[2]/table/tbody/tr[5]/td[2]    # xpath
    ${flightno}=    Set Variable    ${flightno}

    Log To Console    Price: ${price}, Company: ${company}, Flight no:${flightno}

    Click Button    xpath://html/body/div[2]/table/tbody/tr[5]/td[1]/input    # Full xpath

*** Test Cases ***
Check that flight info is found on the new page and save the full price as a variable
    # Check that the price, airline, and flight number you stored in variables are found on the page
    ${bookedprice}=    Get Text    xpath://html/body/div[2]/p[3]
    Set Variable    ${bookedprice}

    ${bookedcompany}=    Get Text    xpath://html/body/div[2]/p[1]
    Set Variable    ${bookedcompany}

    ${bookedflightno}=    Get Text    xpath://html/body/div[2]/p[2]
    Set Variable    ${bookedflightno}
    
    Run Keyword And Continue On Failure    Should Be Equal    ${price}    ${bookedprice}
    Run Keyword And Continue On Failure    Should Be Equal    ${company}    ${bookedcompany}
    Run Keyword And Continue On Failure    Should Be Equal    ${flightno}    ${bookedflightno}

    # Save the total flight price to a variable
    ${fullprice}=    Get Text    xpath://html/body/div[2]/p[5]/em
    Set Suite Variable    ${fullprice}

*** Test Cases ***
Fill out the traveler name and address
    # Fill out passenger information on the form
    Click Element    id:inputName
    Input Text    id:inputName    Mari Malli

    Click Element    id:address
    Input Text    id:address    Katu 12

    Click Element    id:city
    Input Text    id:city    Oulu

    Click Element    id:state
    Input Text    id:state    Suomi

    Click Element    id:zipCode
    Input Text    id:zipCode    32100

*** Test Cases ***
Fill out the credit card info
    # Choose Diner's Club as your credit card
    Click Element    id:cardType
    Select From List By Value    id:cardType    dinersclub

    Click Element    id:creditCardNumber
    Input Text    id:creditCardNumber    1234567890

    # Set the card month and year as global variables
    Click Element    id:creditCardMonth
    Input Text    id:creditCardMonth    7
    ${cardMonth}=    Get Value    id:creditCardMonth
    Set Global Variable    ${cardMonth}    ${cardMonth}

    Log To Console    Month: ${cardMonth}

    Click Element    id:creditCardYear
    Input Text    id:creditCardYear    2025
    ${cardYear}=    Get Value    id:creditCardYear
    Set Global Variable    ${cardYear}    ${cardYear}

    Log To Console    Year: ${cardYear}

    Click Element    id:nameOnCard
    Input Text    id:nameOnCard    Mari Malli

    # Click "Remember me"
    Select Checkbox    id:rememberMe

    # Click "Purchase Flight"
    Click Button    xpath:/html/body/div[2]/form/div[11]/div/input

    Sleep    1

*** Test Cases ***
The booking confirmation page
    # Check that the page contains "Thank you for your purchase today!"
    Page Should Contain    Thank you for your purchase today!

    # Check that the expiration time is correct
    ${cardExpires}=    Get Text    xpath://html/body/div[2]/div/table/tbody/tr[5]/td[2]
    Set Variable    ${cardExpires}

    Log To Console    New variable: ${cardExpires}

    Run Keyword And Continue On Failure    Should Be Equal    ${cardMonth}, ${cardYear}    ${cardExpires}

    # Check that the total price is correct
    ${totalPrice}=    Get Text    xpath://html/body/div[2]/div/table/tbody/tr[3]/td[2]
    Set Variable    ${totalPrice}

    Log To Console    New variable: ${totalPrice}

    Run Keyword And Continue On Failure    Should Be Equal    ${fullprice}    ${totalPrice}

    # Close the browser
    Close Browser
# Elsayed Mahmoud
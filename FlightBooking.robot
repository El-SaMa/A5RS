*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
# Open the Blazedemo website
Go to Blazedemo webpage
    Open Browser    http://blazedemo.com    Chrome
    Maximize Browser Window
    # Verify the welcome message
    Page Should Contain    Welcome to the Simple Travel Agency!

# Select departure and destination
Choose your departure and destination
    # Select departure city as "Boston"
    Click Element    name:fromPort
    ${depart}=    Select From List By Value    name:fromPort    Boston
    ${depart}=    Get Selected List Value    name:fromPort
    Set Suite Variable    ${departure}    ${depart}

    # Select destination city as "Cairo"
    Click Element    name:toPort
    ${destin}=    Select From List By Value    name:toPort    Cairo
    ${destin}=    Get Selected List Value    name:toPort
    Set Suite Variable   ${destination}    ${destin}
    Log To Console    Departure: ${departure}, Destination: ${destination}

# Check and click "Find Flights" button
"Find Flights" button is usable
    Page Should Contain Button    xpath://input[@value='Find Flights']
    Click Button    xpath://input[@value='Find Flights']

# Check flight search results and choose a flight
Check the results and pick your flight
    # Verify the search results page
    Page Should Contain    Flights from ${departure} to ${destination}
    Page Should Contain Element    xpath://html/body/div[2]/table/tbody/tr[1]/td[1]

    # Get flight details
    ${price}=    Get Text    xpath:/html/body/div[2]/table/tbody/tr[5]/td[6]
    Set Suite Variable    ${price}    ${price}

    ${company}=    Get Text    xpath:/html/body/div[2]/table/tbody/tr[5]/td[3]
    Set Suite Variable    ${company}    ${company}

    ${flightno}=    Get Text    xpath:/html/body/div[2]/table/tbody/tr[5]/td[2]
    Set Suite Variable    ${flightno}    ${flightno}

    # Log flight details
    Log To Console    Price: ${price}, Company: ${company}, Flight no: ${flightno}

    # Choose the flight
    Click Button    xpath://html/body/div[2]/table/tbody/tr[5]/td[1]/input

# Check flight info on the new page and save the full price as a variable
Check that flight info is found on the new page and save the full price as a variable
    # Get flight info from the new page
    ${price}=    Get Text    xpath://html/body/div[2]/p[3]
    ${company}=    Get Text    xpath://html/body/div[2]/p[1]
    ${flightno}=    Get Text    xpath://html/body/div[2]/p[2]

    # Check if the price variable exists
    Run Keyword If    '${price}' == 'None'    Fail    Variable '${price}' not found.

    # Set variables for flight info
    Set Variable    ${price}    ${price}
    Set Variable    ${company}    ${company}
    Set Variable    ${flightno}    ${flightno}

    # Log flight info
    Log To Console    Price: ${price}, Company: ${company}, Flight no: ${flightno}

    # Get the full price from the new page
    ${fullprice}=    Get Text    xpath://html/body/div[2]/p[5]/em
    Set Suite Variable    ${fullprice}    ${fullprice}

# Fill out traveler name and address
Fill out the traveller name and address
    Click Element    id:inputName
    Input Text    id:inputName    Pekka Pouta

    Click Element    id:address
    Input Text    id:address   Mäenpääntie 1

    Click Element    id:city
    Input Text    id:city    Riksu

    Click Element    id:state
    Input Text    id:state    Suomi

    Click Element    id:zipCode
    Input Text    id:zipCode    11223

# Fill out credit card info
Fill out the credit card info
    Select From List By Value    id:cardType    dinersclub

    Input Text    id:creditCardNumber    1234567890

    Input Text    id:creditCardMonth    8

    Input Text    id:creditCardYear    2027

    Input Text    id:nameOnCard    Pekka Pouta

    Select Checkbox    id:rememberMe

    Click Button    xpath:/html/body/div[2]/form/div[11]/div/input

# Confirm the booking
The booking confirmation page
    Wait Until Page Contains    Thank you for your purchase today!

    Close Browser     # Done

# Elsayed Mahmoud

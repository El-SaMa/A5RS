*** Settings ***
Documentation   Flight booking tests
Library         SeleniumLibrary

*** Variables ***
${START_CITY}   Boston
${DESTINATION}  Cairo
${CARD_MONTH}   12
${CARD_YEAR}    2022

*** Test Cases ***
Flight Booking Test
    Open Browser    http://blazedemo.com/    chrome
    Maximize Browser Window
    Wait Until Page Contains    Welcome to the Simple Travel Agency!
    Page Should Contain    Welcome to the Simple Travel Agency!
    Select From List By Value    name:fromPort    ${START_CITY}
    ${selected_start_city} =    Get Selected List Value    name:fromPort
    Select From List By Value    name:toPort    ${DESTINATION}
    ${selected_destination} =    Get Selected List Value    name:toPort
    Page Should Contain Element    css:input.btn.btn-primary
    Click Button    css:input.btn.btn-primary
    Wait Until Page Contains    Flights from ${START_CITY} to ${DESTINATION}:
    Page Should Contain    Flights from ${START_CITY} to ${DESTINATION}:
    Page Should Contain Element    css:input.btn.btn-small
    ${flight_info} =    Get Text    css:table.table tbody tr:nth-child(1)
    ${flight_price} =    Get Text    css:table.table tbody tr:nth-child(1) td:nth-child(6)
    Click Element    css:table.table tbody tr:nth-child(1) td:nth-child(1) input[type='submit']
    Wait Until Page Contains    Your flight from ${START_CITY} to ${DESTINATION} has been reserved.
    ${flight_number} =    Get Text    css:table.table tbody tr:nth-child(2) td:nth-child(2)
    ${flight_airline} =    Get Text    css:table.table tbody tr:nth-child(2) td:nth-child(3)
    ${flight_price} =    Get Text    css:table.table tbody tr:nth-child(2) td:nth-child(6)
    ${total_price} =    Get Text    css:table.table tbody tr:nth-child(4) td:nth-child(2)
    Input Text    id:inputName    John Doe
    Input Text    id:address    123 Main St
    Input Text    id:city    Anytown
    Input Text    id:state    CA
    Input Text    id:zipCode    12345
    Select From List By Value    id:cardType    dinersclub
    Input Text    id:creditCardNumber    1234567890
    Select From List By Value    id:creditCardMonth    ${CARD_MONTH}
    Select From List By Value    id:creditCardYear    ${CARD_YEAR}
    Click Checkbox    id:rememberMe
    Click Button    css:input.btn.btn-primary
    Wait Until Page Contains    Thank you for your purchase today!
    Page Should Contain    Thank you for your purchase today!
    ${expiration} =    Get Text    css:table tbody tr:nth-child(1) td:nth-child(2)
    Should Be Equal As Strings    ${flight_number}    ${flight_info.split()[0]}
    Should Be Equal As Strings    ${flight_airline}    ${flight_info.split()[1]}
    Should Be Equal As Strings    ${flight_price}    ${total_price}
    Close Browser

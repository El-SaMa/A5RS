*** Settings ***
Library    SeleniumLibrary
Library    BuiltIn
Library    String

*** Test Cases ***
Go to Blazedemo webpage
    Open Browser    http://blazedemo.com    Chrome    options=add_experimental_option("detach", True)
    Maximize Browser Window
    Wait Until Page Contains    Welcome to the Simple Travel Agency!    20s

Choose your departure and destination
    Wait Until Element Is Visible    name:fromPort    20s
    Select From List By Value    name:fromPort    Boston
    ${departure}=    Get Selected List Value    name:fromPort

    Wait Until Element Is Visible    name:toPort    20s
    Select From List By Value    name:toPort    Cairo
    ${destination}=    Get Selected List Value    name:toPort
    Set Suite Variable    ${departure}
    Set Suite Variable    ${destination}

Find Flights button functionality
    Wait Until Element Is Visible    xpath://input[@value='Find Flights']    20s
    Click Button    xpath://input[@value='Find Flights']

Verify results and select flight
    Wait Until Page Contains    Flights from ${departure} to ${destination}    20s
    Wait Until Element Is Visible    xpath://html/body/div[2]/table/tbody/tr[1]/td[1]    20s
    
    ${price}=    Get Text    xpath:/html/body/div[2]/table/tbody/tr[5]/td[6]
    ${company}=    Get Text    xpath:/html/body/div[2]/table/tbody/tr[5]/td[3]
    ${flightno}=    Get Text    xpath:/html/body/div[2]/table/tbody/tr[5]/td[2]
    
    Click Button    xpath://html/body/div[2]/table/tbody/tr[5]/td[1]/input    

Verify selected flight on new page
    Wait Until Page Contains    ${price}    20s
    Wait Until Page Contains    ${company}    20s
    Wait Until Page Contains    ${flightno}    20s
    
    ${fullprice}=    Get Text    xpath://html/body/div[2]/p[5]/em
    Set Suite Variable    ${fullprice}

Fill traveler info
    Input Text    id:inputName    Mari Malli
    Input Text    id:address    Katu 12
    Input Text    id:city    Oulu
    Input Text    id:state    Suomi
    Input Text    id:zipCode    32100

Fill credit card info
    Wait Until Element Is Visible    id:cardType    20s
    Select From List By Value    id:cardType    dinersclub

    Input Text    id:creditCardNumber    1234567890

    Input Text    id:creditCardMonth    7
    ${cardMonth}=    Get Value    id:creditCardMonth
    Set Global Variable    ${cardMonth}

    Input Text    id:creditCardYear    2025
    ${cardYear}=    Get Value    id:creditCardYear
    Set Global Variable    ${cardYear}

    Input Text    id:nameOnCard    Mari Malli

    Select Checkbox    id:rememberMe
    Wait And Click Button    xpath:/html/body/div[2]/form/div[11]/div/input

Booking confirmation and verification
    Wait Until Page Contains    Thank you for your purchase today!    20s
    ${cardExpires}=    Get Text    xpath://html/body/div[2]/div/table/tbody/tr[5]/td[2]
    Run Keyword And Continue On Failure    Should Be Equal    ${cardMonth}/${cardYear}    ${cardExpires}

    ${totalPrice}=    Get Text    xpath://html/body/div[2]/div/table/tbody/tr[3]/td[2]
    Run Keyword And Continue On Failure    Should Be Equal    ${fullprice}    ${totalPrice}

    Close Browser

*** Keywords ***
Wait And Click Button
    [Arguments]    ${locator}
    Wait Until Element Is Visible    ${locator}    20s
    Click Button    ${locator}

*** Settings ***
Variables   /work/Robot_HW_PP/HW_Robot/Data.yml
Variables   /work/Robot_HW_PP/HW_Robot/price.yml
Library     OperatingSystem
Library     Collections
Library     String
Library     CSVLibrary
Library     SeleniumLibrary

Test Template    test case

*** Test Cases ***    csv

E   /work/Robot_HW_PP/HW_Robot/Paeng.csv

*** Keywords ***
Test case
    [Arguments]    ${userCSV}
    ${USER_CSV_FILE}    Set Variable    ${userCSV}
    ${USER_DATA_CSV}    Read Csv File To Associative    ${USER_CSV_FILE}
    ${user}    Set Variable    ${USER_DATA_CSV}[0]    # standard

    Open Browser    ${url}    ${browser}
    Verify Login page
    Input Text    //*[@id="user-name"]    ${user}[username]  
    Input Text    //*[@id="password"]     ${user}[password]  
    Click Button    //*[@id="login-button"]
    
    Verify Shopping Page
    Add to cart    ${products.p1}
    Add to cart    ${products.p3}
    Add to cart    ${products.p6}

    Click Element    //a[@class="shopping_cart_link fa-layers fa-fw"]

    Verify Cart Page
    Click Element    //a[contains(text(),"CHECKOUT")]

    Verify Checkout page
    Input Text    //*[@id="first-name"]    ${user}[fname]  
    Input Text    //*[@id="last-name"]    ${user}[lname]
    Input Text    //*[@id="postal-code"]    00001
    
    Click Element    //input[@value="CONTINUE"]
    
    Verify Preview page
    Click Element    //a[contains(text(),"FINISH")]

    Verify Finish page
    Wait Until Element Is Visible    //h2[contains(text(),"THANK YOU FOR YOUR ORDER")]    timeout=5s
    

Add to cart
    [Arguments]    ${product}
    Click Element    //div[contains(text(),"${product.name}")]
    Verify Product page
    Verify Product price with    ${product.price}
    Click Button    //*[@class="btn_primary btn_inventory"]
    Click Button    //*[@class="inventory_details_back_button"]

Verify Shopping Page
    Wait Until Element Is Visible    //div[contains(text(),"Products")]    timeout=5s

Verify Login page
    Wait Until Element Is Visible    //*[@id="login_credentials"]    timeout=5s

Verify Product page
    Wait Until Element Is Visible    //*[@class="inventory_details"]    timeout=5s

Verify Cart page
    Wait Until Element Is Visible    //div[contains(text(),"Your Cart")]    timeout=5s

Verify Checkout page
    Wait Until Element Is Visible    //div[contains(text(),"Checkout: Your Information")]    timeout=5s

Verify Preview page
    Wait Until Element Is Visible    //div[contains(text(),"Checkout: Overview")]    timeout=5s

Verify Finish page
    Wait Until Element Is Visible    //div[contains(text(),"Finish")]    timeout=5s

Verify Product price with
    [Arguments]    ${price}
    Verify Product page
    ${displayPrice}    Get Text    //div[@class="inventory_details_price"]
    Run Keyword If    '${displayPrice}' != '$${price}'    Fail    "Test Failed: Invalid price."

*** Settings ***
Library    AppiumLibrary    
*** Variables ***
${REMOTE_URL}     http://127.0.0.1:4723/wd/hub
${PLATFORM_NAME}    Android
${PLATFORM_VERSION}    10.0
${DEVICE_NAME}    GA75PVQ8WKMNZDMZ
${Activity_NAME}        com.pajk.login.ui.JKLogoActivity
${PACKAGE_NAME}     com.pajk.idpersonaldoc

*** Keywords ***
Open goodDoctor
  Open Application   ${REMOTE_URL}
  ...        platformName=${PLATFORM_NAME}
  ...    platformVersion=${PLATFORM_VERSION}
  ...   deviceName=${DEVICE_NAME}
  ...   automationName=UiAutomator2
    ...    newCommandTimeout=2500
    ...    appActivity=${Activity_NAME}
    ...    appPackage=${PACKAGE_NAME}

Allow location access
  [Arguments]
  Click Element    id=com.pajk.idpersonaldoc:id/positive
  Wait Until Page Contains Element  id=com.android.permissioncontroller:id/permission_allow_foreground_only_button
  Click Element    id=com.android.permissioncontroller:id/permission_allow_foreground_only_button

Tap button slider screen
  [Arguments]
  Wait Until Page Contains Element  id=com.pajk.idpersonaldoc:id/go_btn
  Click Element    id=com.pajk.idpersonaldoc:id/go_btn

Uncheck termCondition
  [Arguments]
  Wait Until Page Contains Element  id=com.pajk.idpersonaldoc:id/login_select_agree_image
  Click Element    id=com.pajk.idpersonaldoc:id/login_select_agree_image

Input phone number
  [Arguments]  ${phonenumber}
  Wait Until Page Contains Element  id=com.pajk.idpersonaldoc:id/phone_number_edit
  Click Element    id=com.pajk.idpersonaldoc:id/phone_number_edit
  Input Text       id=com.pajk.idpersonaldoc:id/phone_number_edit  ${phonenumber}


Verify button is clickable
  [Arguments]  ${query}  ${query2}
  Element Attribute Should Match  id=com.pajk.idpersonaldoc:id/login_btn  ${query}  ${query2}

Tap Lanjutkan button
  [Arguments]
  Click Element    id=com.pajk.idpersonaldoc:id/login_btn

Verify phone number page
  [Arguments]
  Element Should Be Visible  id=com.pajk.idpersonaldoc:id/phone_number_edit  INFO

Verify OTP Page
  [Arguments]  ${phonenumber}
  Wait Until Page Contains Element  id=com.pajk.idpersonaldoc:id/text_sms_status
  Element Should Be Visible  id=com.pajk.idpersonaldoc:id/text_sms_status  INFO
  Element Should Contain Text  com.pajk.idpersonaldoc:id/manual_layout_title  +62 ${phonenumber}

Invalid OTP input
#keycode yang di pakai di sini adalah Constant Value dari nativenya. 
# e.g Constant Value: 144 (lihat di dokumentasi android nativenya)
  [Arguments]
  Press Keycode    145
  Press Keycode    146
  Press Keycode    147
  Press Keycode    148
  Press Keycode    149
  Press Keycode    150
  Click Element    id=com.pajk.idpersonaldoc:id/login_btn

Tap Resend OTP
  [Arguments]
  Wait Until Element Is Visible  id=com.pajk.idpersonaldoc:id/text_sms_status  None  None
  Wait Until Page Contains  Minta kode verifikasi lagi.  61
  Click Element    id=com.pajk.idpersonaldoc:id/text_sms_status

*** Test Cases ***
"Lanjutkan" button in register/login page should be disabled if phone number empty
    Open goodDoctor
    Allow location access
    Tap button slider screen
    Uncheck termCondition
    Verify button is clickable  clickable  False

Phone number filled but T&C is uncheck, "Lanjutkan" button in register/login page should be disabled
    Input phone number  82227239963
    Verify button is clickable  clickable  False

Phone number filled and T&C is checked, "Lanjutkan" button in register/login page should be enabled
    Uncheck termCondition
    Input phone number  82227239963
    Verify button is clickable  clickable  True

Phone number using invalid format e.g "082227239963" or "751236489" and T&C is checked will give toast error
    Input phone number  082227239963
    Tap Lanjutkan button
    Verify phone number page

Input valid phone number and T&C is checked, will be directed to OTP page
    Input phone number  82227239963
    Verify button is clickable  clickable  True
    Tap Lanjutkan button
    Verify OTP Page  82227239963

Input invalid OTP code at the OTP page
    Invalid OTP input
    Verify OTP Page  82227239963

wait for 1 minute and then tap "resend otp" button
    Verify OTP Page  82227239963
    Tap Resend OTP
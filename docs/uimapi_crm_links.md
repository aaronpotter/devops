## UIMAPI (http)

Below are UIMAPI http calls in PHP programs.

Endpoints used:
- [rest/crm/getUserProfile](http://uimapi.awsprd.univision.com/rest/crm/getUserProfile?userId=XXX&appId=XXX&hashCheck=XXX&hash=XXX)
- [rest/crm/isEmailExists](http://uimapi.awsprd.univision.com/rest/crm/isEmailExists?client=1&email=XXX&hashCheck=false&hash=XXX)
- [rest/crm/isEmailExists](http://uimapi.awsprd.univision.com/rest/crm/isEmailExists?client=1&hashCheck=false&hash=XXX&email=XXX)
- [rest/crm/getUserProfile](http://uimapi.awsprd.univision.com/rest/crm/getUserProfile?client=1&userId=XXX&hashCheck=false&hash=XXX)

Internal crm app calls are all in http protocol. See the configuration file below specifying all crm apis and the url for internal load balancer to call crm application

    <crm>
      <serverUrl>http://miembros-int.awsprd.univision.com</serverUrl>
      <loginApiOldUri>/crm/login/api</loginApiOldUri>
      <loginApiUri>/crm/login/loginByAPI</loginApiUri>
      <registrationApiUri>/crm/registration/registerByAPI</registrationApiUri>
      <linkAccountsUri>/crm/sn/linkAccountsByAPI</linkAccountsUri>
      <registerAndLinkAccountsUri>/crm/sn/registerAndLinkAccountsByAPI</registerAndLinkAccountsUri>
      <authenticateLinkedAccountUri>/crm/sn/loginByAPI</authenticateLinkedAccountUri>
      <isEmailExistsUri>/crm/sn/checkEmailByAPI</isEmailExistsUri>
      <isAliasNameExistsUri>/crm/sn/checkAliasNameByAPI</isAliasNameExistsUri>
      <sendPasswordByEmailUri>/crm/password/handleForgotPasswordByAPI</sendPasswordByEmailUri>
      <getUserProfileUri>/crm/userAPI/getUserDetailsByAPI</getUserProfileUri>
      <getUserPartnerDetailsForAPI>/crm/login/getUserPartnerDetailsForAPI</getUserPartnerDetailsForAPI>
      <privateKey>XXX</privateKey>
    </crm>

### WCM NJ3, aka BrightSpot

Accessed from UIMAPI via this URI (note: HTTP via VPN)
- [http://10.200.0.105/wcm/api/http/endpoint.php](http://10.200.0.105/wcm/api/http/endpoint.php)

### MySQL - UGC database

Connected to vis PHP MySQL module with db connection string:

- [ugcmysql.awsprd.univision.com:3306](ugcmysql.awsprd.univision.com:3306)


## CRM (https)

#### CRM endpoints:
1. [crm/registration](https://miembros.awsprd.univision.com/crm/registration) endpoint, origin list
  - portal
  - foro
  - nbl (Nuestra Belleza Latina)
  - nfl(NFL)
  - photoupload
  - video upload
  - facebook, you need to go to site/login page rather than from url
  - Twitter, you need to go to site/login page rather than from url
2. [crm/login](https://miembros.awsprd.univision.com/crm/login) endpoint, origin list
  - portal
  - foro
  - nbl (Nuestra Belleza Latina)
  - nfl(NFL)
  - photoupload
  - video upload
  - facebook
  - Twitter
3. [crm/forgotPasswordPopup](https://miembros.awsprd.univision.com/crm/forgotPasswordPopup) endpoint.
4. [crm/accMaintain/popup](https://miembros.awsprd.univision.com/crm/accMaintain/popup) endpoint.
5. [crm/password/changePasswordForm](https://miembros.awsprd.univision.com/crm/password/changePasswordForm) endpoint.
6. [crm/logout](https://miembros.awsprd.univision.com/crm/logout) endpoint.
7. --device authentication--
8. [crm/conf/confirmRegistration](https://miembros.awsprd.univision.com/crm/conf/confirmRegistration) endpoint.
9. [crm/newsletterRegistration](https://miembros.awsprd.univision.com/crm/newsletterRegistration) endpoint.
10. [crm/registration/emailOptOut](https://miembros.awsprd.univision.com/crm/registration/emailOptOut) endpoint.

CRM partner endpoints:
1. Samsung TV
  - [crm/device/authenticate](https://miembros.awsprd.univision.com/crm/device/authenticate) endpoint.
  - [crm/device/getMappingDetails](https://miembros.awsprd.univision.com/crm/device/getMappingDetails) endpoint.
2. Xbox
  - [crm/xbox/authenticateToken](https://miembros.awsprd.univision.com/crm/xbox/authenticateToken) endpoint.
  - [crm/xbox/verifyUserAuthenticationStatus](https://miembros.awsprd.univision.com/crm/xbox/verifyUserAuthenticationStatus) endpoint.
  - [crm/xbox/validateUserCode](https://miembros.awsprd.univision.com/crm/xbox/validateUserCode) endpoint.

#### CRM JBoss direct access points:
1. Socialnetworking partners, Gigya-Facebook/Twitter  
Gigya component - GSJavaSDK.jar  
Make request with stored Keys (gigya.apikey and gigya.secretKey) + user info to Gigya site  
once successful, drop cookies that created by gigya to client browsers
2. Foro/Lithium partner  
CRM app via lithium component SSOClient-1.5.4.jar, drop the cookie named as "lithiumSSO:univision" with univision\_cookie\_key+userinformation (userid, email, alias)  
and then connect users to foro


## Quova (http)

Quova is used for Geilocation data and is accessed via this endpoint:
- [geodirectory/v1/ipinfo/#.#.#.#](http://geodds7-int.awsprd.univision.com/geodirectory/v1/ipinfo/#.#.#.#)


# OAuth2.0 and OIDC

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [OAuth2.0 and OIDC](#oauth20-and-oidc)
    - [OIDC](#oidc)
      - [1.token claims](#1token-claims)
      - [2.OIDC Token Validation Process](#2oidc-token-validation-process)
      - [3.how does OIDC work](#3how-does-oidc-work)
    - [Overview](#overview)
      - [1.OAuth2.0 vs OIDC](#1oauth20-vs-oidc)
      - [2.Setting up OAuth 2.0](#2setting-up-oauth-20)
      - [3.OIDC discovery document](#3oidc-discovery-document)
      - [4.Auth2.0 implementation (web server application i.e. `response_type=code`)](#4auth20-implementation-web-server-application-ie-response_typecode)
        - [(1) create an state token](#1-create-an-state-token)
        - [(2) Authentication Request](#2-authentication-request)
        - [(3) Response is sent to the `redirect_uri`](#3-response-is-sent-to-the-redirect_uri)
        - [(4) Exchange code for access token and ID token](#4-exchange-code-for-access-token-and-id-token)
        - [(5) Validate and Obtain user information from the ID token](#5-validate-and-obtain-user-information-from-the-id-token)
        - [(6) My APP to authenticate the user](#6-my-app-to-authenticate-the-user)
    - [Demo](#demo)

<!-- /code_chunk_output -->

### OIDC

#### 1.token claims

Mike (subject) sends a token issued by Google (issuer) to AWS (audience)

* **issuer** (work with **signature**)
    * indicate who sign the token and which public key should be used to verify
* **subject**
    * Who is making the request? (GitHub repository, branch, workflow)
* **audience**
    * Who is the intended audience? (AWS STS)


#### 2.OIDC Token Validation Process

[ref](#5-validate-and-obtain-user-information-from-the-id-token)

|Step|Verification|Prevents
|-|-|-|
|1. Check Signature|use the public key of the issuer to verify the signature|Fake OIDC tokens
|2. Check Issuer (iss)|ensures the token came from a trusted Identity provider|Tokens from other providers
|3. Check Audience (aud)|ensures that the token is intended for your application and not for some other application|Token Theft (Token Replay Attack)
|4. Check Subject (sub)|verify who make the request and sub is set by the provider so users can't change it|impersonating another person
|5. Check Expiration (exp)|Token must be valid|Expired tokens

#### 3.how does OIDC work

* e.g. github:
    * [ref](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/about-security-hardening-with-openid-connect#getting-started-with-oidc)

***

### Overview

#### 1.OAuth2.0 vs OIDC

modern OAuth2.0 implementations include OIDC such as google OAuth 2.0 implementation, which can be used for both **authentication and authorization**

| Feature         | OAuth 2.0             | OpenID Connect (OIDC)              |
| --------------- | --------------------- | ---------------------------------- |
| Protocol Type   | Authorization         | Authentication + Authorization     |
| Returns         | Access Token          | Access Token + ID Token            |
| Token Type      | Opaque or JWT         | JWT (for ID Token)                 |
| Who it's for    | APIs wanting data     | Apps wanting to log users in       |
| User Identity   | Not provided          | Provided via ID Token & UserInfo   |
| Standard Scopes | `read`, `write`, etc. | `openid`, `profile`, `email`, etc. |

#### 2.Setting up OAuth 2.0

* client ID
* client secret
* redirect URI
    * The redirect URI that you set in the Cloud Console determines **where Google sends responses** to your authentication requests

#### 3.OIDC discovery document
* a well-known location containing key-value pairs which provide details about the OpenID Connect provider's configuration
    * google: https://accounts.google.com/.well-known/openid-configuration

#### 4.Auth2.0 implementation (web server application i.e. `response_type=code`)

[Google OAuth2.0 Ref1](https://developers.google.com/identity/protocols/oauth2)
[Google OAuth2.0 Ref2](https://developers.google.com/identity/openid-connect/openid-connect)

![](./imgs/oo_01.png)

##### (1) create an state token
* authentication request with the state token
    * user is redirected to google OAuth2.0 service to login in

* The response is sent to the `redirect_uri` including
    * the state token (verify that the user is making the request)
    * code
    * ...

* python code
```python
from authlib.integrations.requests_client import OAuth2Session
client = OAuth2Session(client_id, client_secret, scope=scope)

# the uri is google OAuth2.0 service where to request token
uri, state = client.create_authorization_url(authorization_endpoint, redirect_uri="https://localhost:8080")

print(uri)
```
```python
def create_authorization_url(self, url, state=None, code_verifier=None, **kwargs):
    if state is None:
        state = generate_token()
        ...
```

##### (2) Authentication Request

[more parameters](https://developers.google.com/identity/openid-connect/openid-connect#authenticationuriparameters)

<table>
    <thead>
      <tr>
        <th>Parameter</th>
        <th>Required</th>
        <th>Description</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code translate="no" dir="ltr">client_<wbr>id</code></td>
        <td>(Required)</td>
        <td>The client ID string that you obtain from the
          Cloud Console
          <a href="https://console.developers.google.com/auth/clients">Clients page</a>, as described in
          <a href="#getcredentials">Obtain OAuth 2.0 credentials</a>.</td>
      </tr>
      <tr id="nonce-param">
        <td><code translate="no" dir="ltr">nonce</code></td>
        <td>(Required)</td>
        <td>A random value generated by your app that enables replay protection.</td>
      </tr>
      <tr id="response-type">
        <td><code translate="no" dir="ltr">response_<wbr>type</code></td>
        <td>(Required)</td>
        <td>If the value is <code translate="no" dir="ltr">code</code>, launches a
          <a href="https://openid.net/specs/openid-connect-basic-1_0.html">Basic authorization code flow</a>,
          requiring a <code translate="no" dir="ltr">POST</code> to the token endpoint to obtain the tokens. If the value is
          <code translate="no" dir="ltr">token id_<wbr>token</code> or <code translate="no" dir="ltr">id_<wbr>token token</code>, launches an
          <a href="https://openid.net/specs/openid-connect-implicit-1_0.html">Implicit flow</a>,
          requiring the use of JavaScript at the redirect URI to retrieve tokens from the
          <a href="https://datatracker.ietf.org/doc/html/rfc3986#section-3">URI <code translate="no" dir="ltr">#fragment</code> identifier</a>.</td>
      </tr>
      <tr id="redirect">
        <td><code translate="no" dir="ltr">redirect_<wbr>uri</code></td>
        <td>(Required)</td>
        <td>Determines where the response is sent. The value of this parameter must exactly match
          one of the authorized redirect values that you set in the
          Cloud Console
          <a href="https://console.developers.google.com/auth/clients">Clients page</a> (including the HTTP or HTTPS scheme,
          case, and trailing '/', if any).</td>
      </tr>
      <tr id="scope-param" tabindex="-1">
        <td><code translate="no" dir="ltr">scope</code></td>
        <td>(Required)</td>
        <td><p>The scope parameter must begin with the <code translate="no" dir="ltr">openid</code> value and then include
          the <code translate="no" dir="ltr">profile</code> value, the <code translate="no" dir="ltr">email</code> value, or both.</p>
          <p>If the <code translate="no" dir="ltr">profile</code> scope value is present, the ID token might (but is not
            guaranteed to) include the user's default <code translate="no" dir="ltr">profile</code> claims.</p>
          <p>If the <code translate="no" dir="ltr">email</code> scope value is present, the ID token includes
            <code translate="no" dir="ltr">email</code> and <code translate="no" dir="ltr">email_verified</code> claims.</p>
          <p>In addition to these OpenID-specific scopes, your scope argument can also include other
            scope values. All scope values must be space-separated. For example, if you wanted
            per-file access to a user's Google Drive, your scope parameter might be
            <code translate="no" dir="ltr">openid profile email https://www.googleapis.com/auth/drive.file</code>.</p>
          <p>For information about available scopes, see
            <a href="/identity/protocols/oauth2/scopes">OAuth 2.0 Scopes for Google APIs</a> or the
            documentation for the Google API you would like to use.</p></td>
      </tr>
      <tr id="state-param">
        <td><code translate="no" dir="ltr">state</code></td>
        <td>(Optional, but strongly recommended)</td>
        <td><p>An opaque string that is round-tripped in the protocol; that is to say, it is
          returned as a URI parameter in the Basic flow, and in the URI <code translate="no" dir="ltr">#fragment</code>
          identifier in the Implicit flow.</p>
          <p>The <code translate="no" dir="ltr">state</code> can be useful for correlating requests and responses.
            Because your <code translate="no" dir="ltr">redirect_uri</code> can be guessed, using a <code translate="no" dir="ltr">state</code> value
            can increase your assurance that an incoming connection is the result of an
            authentication request initiated by your app. If you
            <a href="#createxsrftoken">generate a random string</a> or encode the hash of some
            client state (e.g., a cookie) in this <code translate="no" dir="ltr">state</code> variable, you can validate
            the response to verify that the request and response originated in the same browser. This
            provides protection against attacks such as cross-site request forgery.</p></td>
      </tr>
</tbody>
</table>

* Authentication Request URI e.g.

```
https://accounts.google.com/o/oauth2/auth

response_type = code
client_id     = 224600073722-ek1qg5sheg9hpjjs1ee5gs5h5hmmgc.apps.googleusercontent.com
redirect_uri  = https://localhost:8080
scope         = email profile
state         = uwcw1EXNgewUY7z9jjCzlND528ljMq
```

##### (3) Response is sent to the `redirect_uri`
* On the server, you must confirm that the `state token` received from Google matches the `state token` you created before

* e.g. (`redirect_uri=https://localhost:8080/`)
```
https://localhost:8080/

state    = aWZp81zFC3m8yORikxDfyzlZPkjFtP
code     = ***
scope    = email profile https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email openid
authuser = 0
hd       = mycompany.jp
prompt   = none
``` 

* python code

```python
authorization_response = input("response decoded url:\n")

# input: https://localhost:8080/?state=aWZp81zFC3m8yORikxDfyzlZPkjFtP&code=4/0AUJR-x5igLWbC49F_21u-QSSW-WnCtNAi7XcV1XeWSdC4brH_K6SjGJWWwytPpk-qfcgiw&scope=email+profile+https://www.googleapis.com/auth/userinfo.profile+https://www.googleapis.com/auth/userinfo.email+openid&authuser=0&hd=mycompany.jp&prompt=none
```

##### (4) Exchange code for access token and ID token
* Authorization code:
    * a one-time authorization code that your server can exchange for an access token and ID token
* the request include these parameters

<table class="responsive">
    <thead>
      <tr>
        <th colspan="2">Fields</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code translate="no" dir="ltr">code</code></td>
        <td>The authorization code that is returned from
          <a href="#sendauthrequest">the initial request</a>.</td>
      </tr>
      <tr>
        <td><code translate="no" dir="ltr">client_<wbr>id</code></td>
        <td>The client ID that you obtain from the Cloud Console
          <a href="https://console.developers.google.com/auth/clients">Clients page</a>, as described in
          <a href="#getcredentials">Obtain OAuth 2.0 credentials</a>.</td>
      </tr>
      <tr>
        <td><code translate="no" dir="ltr">client_<wbr>secret</code></td>
        <td>The client secret that you obtain from the Cloud Console
          <a href="https://console.developers.google.com/auth/clients">Clients page</a>, as described in
          <a href="#getcredentials">Obtain OAuth 2.0 credentials</a>.</td>
      </tr>
      <tr>
        <td><code translate="no" dir="ltr">redirect_<wbr>uri</code></td>
        <td>An authorized redirect URI for the given <code translate="no" dir="ltr">client_<wbr>id</code> specified in the
          Cloud Console
          <a href="https://console.developers.google.com/auth/clients">Clients page</a>, as described in
          <a href="#setredirecturi">Set a redirect URI</a>.</td>
      </tr>
      <tr>
        <td><code translate="no" dir="ltr">grant_<wbr>type</code></td>
        <td>This field must contain a value of <code translate="no" dir="ltr">authorization_<wbr>code</code>,
          <a href="https://tools.ietf.org/html/rfc6749#section-4.1.3">
            as defined in the OAuth 2.0 specification</a>.</td>
      </tr>
    </tbody>
  </table>

* get the access token and id token (JWT)
<table class="responsive">
    <thead>
      <tr>
        <th colspan="2">Fields</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td><code translate="no" dir="ltr">access_<wbr>token</code></td>
        <td>A token that can be sent to a Google API.</td>
      </tr>
      <tr>
        <td><code translate="no" dir="ltr">expires_<wbr>in</code></td>
        <td>The remaining lifetime of the access token in seconds.</td>
      </tr>
      <tr>
        <td><code translate="no" dir="ltr">id_<wbr>token</code></td>
        <td>A <a href="https://tools.ietf.org/html/rfc7519">JWT</a> that contains
          identity information about the user that is digitally signed by Google.</td>
      </tr>
      <tr>
        <td><code translate="no" dir="ltr">scope</code></td>
        <td>The scopes of access granted by the <code translate="no" dir="ltr">access_<wbr>token</code> expressed as a list of
          space-delimited, case-sensitive strings.</td>
      </tr>
      <tr>
        <td><code translate="no" dir="ltr">token_<wbr>type</code></td>
        <td>Identifies the type of token returned. At this time, this field always has the value
          <a href="https://tools.ietf.org/html/rfc6750"><code translate="no" dir="ltr">Bearer</code></a>.
        </td>
      </tr>
      <tr>
        <td><code translate="no" dir="ltr">refresh_<wbr>token</code></td>
        <td>(optional)
          <p>This field is only present if the
            <a href="#access-type-param"><code translate="no" dir="ltr">access_type</code></a> parameter was set to
            <code translate="no" dir="ltr">offline</code> in the <a href="#sendauthrequest">authentication request</a>.
            For details, see <a href="#refresh-tokens">Refresh tokens</a>.</p></td>
      </tr>
    </tbody>
  </table>
 
* python code
```python
token = client.fetch_token(token_endpoint, authorization_response=authorization_response, redirect_uri="https://localhost:8080")
print('Access token:', token)

"""
Access token:
{
    "access_token": "***",
    "expires_in": 3588,
    "scope": "https://www.googleapis.com/auth/userinfo.email openid https://www.googleapis.com/auth/userinfo.profile",
    "token_type": "Bearer",
    "id_token": "***",
    "expires_at": 1749732094
}
"""
```

##### (5) Validate and Obtain user information from the ID token

* [validate `id_token`](https://developers.google.com/identity/openid-connect/openid-connect#validatinganidtoken) before using it


* [decode JTW `id_token`](https://fusionauth.io/dev-tools/jwt-decoder)

    * Header
    ```json
    {
    "alg": "RS256",
    "kid": "0d8a67399e7882acae7d7f68b2280256a796a582",
    "typ": "JWT"
    }
    ```

    * Payload
    ```json
    {
    "iss": "accounts.google.com",
    "azp": "224600073722-ek1qg5sheo1g9hpjjs1ee5gs5h5hmmgc.apps.googleusercontent.com",
    "aud": "224600073722-ek1qg5sheo1g9hpjjs1ee5gs5h5hmmgc.apps.googleusercontent.com",
    "sub": "107545311396834983429",
    "hd": "mycompany.jp",
    "email": "liam@mycompany.jp",
    "email_verified": true,
    "at_hash": "VZUjSnZPYwZv4mZDSgp7UA",
    "iat": 1749532922,
    "exp": 1749536522
    }
    ```

##### (6) My APP to authenticate the user

becacuse the user info is in the `id_token`

***

### Demo

```python
client_id = '***'
client_secret = '***'

# https://accounts.google.com/.well-known/openid-configuration
scope = 'email profile'
authorization_endpoint = 'https://accounts.google.com/o/oauth2/v2/auth'
token_endpoint = 'https://oauth2.googleapis.com/token'

# using requests implementation
from authlib.integrations.requests_client import OAuth2Session
client = OAuth2Session(client_id, client_secret, scope=scope)

# the uri is google OAuth2.0 service where to request token
uri, state = client.create_authorization_url(authorization_endpoint, redirect_uri="https://localhost:8080")

print(uri)

authorization_response = input("response decoded url:\n")

token = client.fetch_token(token_endpoint, authorization_response=authorization_response,redirect_uri="https://localhost:8080")

print('Access token:', token)

client = OAuth2Session(client_id, client_secret, token=token)
account_url = 'https://www.googleapis.com/auth/userinfo.email'
resp = client.get(account_url)
print(resp.content)
```
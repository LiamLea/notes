# OIDC

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [OIDC](#oidc)
    - [overview](#overview)
      - [1.token claims](#1token-claims)
      - [2.OIDC Token Validation Process](#2oidc-token-validation-process)
      - [3.how does OIDC work](#3how-does-oidc-work)

<!-- /code_chunk_output -->


### overview

#### 1.token claims

Mike (subject) sends a token issued by Google (issuer) to AWS (audience)

* **issuer** (work with **signature**)
    * indicate who sign the token and which public key should be used to verify
* **subject**
    * Who is making the request? (GitHub repository, branch, workflow)
* **audience**
    * Who is the intended audience? (AWS STS)


#### 2.OIDC Token Validation Process

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
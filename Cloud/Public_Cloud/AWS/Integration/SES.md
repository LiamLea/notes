# SES

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [SES](#ses)
    - [Overview](#overview)
      - [1.DomainKeys Identified Mail (DKIM)](#1domainkeys-identified-mail-dkim)
        - [(1) DKIM records](#1-dkim-records)
        - [(2) how does this verification work](#2-how-does-this-verification-work)
      - [2.Sender Policy Framework (SPF)](#2sender-policy-framework-spf)
        - [(1) SPF records](#1-spf-records)
      - [3.Custom MAIL FROM domain](#3custom-mail-from-domain)
        - [(1) what](#1-what)
        - [(2) why](#2-why)
        - [(3) example](#3-example)
      - [4. set to receive emails](#4-set-to-receive-emails)

<!-- /code_chunk_output -->


### Overview

#### 1.DomainKeys Identified Mail (DKIM) 

Verifies the content wasn’t changed + domain signature

##### (1) DKIM records
DKIM records are TXT DNS entries used to verify that an email really came from your domain

* e.g.
```
abcdefg12345._domainkey.yourdomain.com TXT v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...
```

##### (2) how does this verification work

* When you send an email through Amazon SES (or any mail service), SES digitally signs your message using a private key.
* The recipient’s mail server then uses the public key—published in your domain’s DNS as a DKIM record—to verify that:
    * The email was indeed authorized by your domain
    * The contents of the email haven’t been tampered with

#### 2.Sender Policy Framework (SPF)

Verifies the sending server is allowed

##### (1) SPF records

An SPF record is a DNS TXT record that tells the world:
> Which mail servers are allowed to send email on behalf of your domain.

* e.g.
```
mail.aiops.mycompany.com   TXT   "v=spf1 include:amazonses.com -all"
```

#### 3.Custom MAIL FROM domain
##### (1) what 
* When you send an email, two “from” addresses exist:
    * Header From (what humans see)
    ```sql
    From: support@aiops.mycompany.com
    ```
    * Envelope MAIL FROM (Return-Path, used for bounces)
    ```sql
    Return-Path: <010101abcd@amazonses.com>
    ```
* when set Custom MAIL FROM domain
```sql
Return-Path: <bounce+xyz@mail.aiops.mycompany.com>
```

##### (2) why
* To pass SPF alignment for DMARC

##### (3) example
```shell
# “If anyone tries to send mail to the address bounce@mail.aiops.mycompany.com, deliver that mail to Amazon SES feedback servers in the ap-northeast-1 region.”
mail.aiops.mycompany.com   MX   10 feedback-smtp.ap-northeast-1.amazonses.com

# SPF records
mail.aiops.mycompany.com   TXT   "v=spf1 include:amazonses.com -all"
```

#### 4. set to receive emails

set a MX record, e.g.:
```
aiops.mycompany.com   MX   10   inbound-smtp.ap-northeast-1.amazonaws.com
```
then sent email to: `aiops.mycompany.com`
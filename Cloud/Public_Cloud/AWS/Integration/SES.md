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
        - [(2) how does it work](#2-how-does-it-work)
      - [3.Custom MAIL FROM domain](#3custom-mail-from-domain)
        - [(1) what](#1-what)
        - [(2) why](#2-why)
        - [(3) example](#3-example)
      - [4. set to receive emails](#4-set-to-receive-emails)
      - [5. Configuration Set](#5-configuration-set)
        - [(1) example](#1-example)
      - [6. Bounce Rate & Suppression List](#6-bounce-rate--suppression-list)
        - [(1) Suppression List](#1-suppression-list)

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
* The recipient’s mail server 
  * Sees `d=mycompany.com; s=selector1` in the signature header
  * Does a DNS lookup for the public key: 
    * `selector1._domainkey.mycompany.com  TXT  "v=DKIM1; k=rsa; p=<public key>"`
  * then uses the public key to verify that:
    * The email was indeed authorized by your domain
    * The contents of the email haven’t been tampered with

#### 2.Sender Policy Framework (SPF)

* Verifies the sending server is allowed
* when use **Custom MAIL FROM** this should be set

##### (1) SPF records

An SPF record is a DNS TXT record that tells the world:
> Which mail servers are allowed to send email on behalf of your domain.

* e.g.
```
MX      mail.aiops.com       10 feedback-smtp.ap-northeast-1.amazonses.com
TXT     mail.aiops.com       "v=spf1 include:amazonses.com ~all"
```

##### (2) how does it work
* Recipient's server sees the **MAIL FROM** domain (`mycompany.com`)
* Looks up the SPF TXT record for that domain in DNS
  * `dig mycompany.com TXT`
* Checks whether the connecting server's IP is in the authorized list

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

#### 5. Configuration Set

A named policy attached to emails **at send time**. Controls IP pool, suppression, TLS, and event publishing for that sending stream.

SES records the config set name with each message ID. When a bounce/complaint arrives, SES traces it back to that message ID → looks up the config set → applies its rules.

`suppressed_reasons = []` — skip suppression list entirely, send regardless

##### (1) example

```hcl
# Transactional — order confirmations, OTPs
resource "aws_sesv2_configuration_set" "transactional" {
  configuration_set_name = "transactional-emails"

  delivery_options {
    tls_policy        = "REQUIRE"       # reject delivery if recipient server doesn't support TLS
    sending_pool_name = "transactional-pool"  # use IPs from this pool as the outgoing sender IP; isolated from marketing reputation — shared IPs are affected by other SES customers' spam complaints
  }

  suppression_options {
    suppressed_reasons = ["BOUNCE"]     # when an email hard bounces, add that address to the suppression list — future sends to it are blocked; complaints excluded (rare, worth investigating manually)
  }

  reputation_options {
    reputation_metrics_enabled = true   # expose bounce/complaint rates as CloudWatch metrics
  }
}

# Marketing — newsletters, promotions
resource "aws_sesv2_configuration_set" "marketing" {
  configuration_set_name = "marketing-emails"

  delivery_options {
    tls_policy        = "OPTIONAL"      # allow fallback to unencrypted to maximise deliverability
    sending_pool_name = "marketing-pool"  # isolated IPs — a bounce spike here won't affect transactional
  }

  suppression_options {
    suppressed_reasons = ["BOUNCE", "COMPLAINT"]  # auto-suppress both — large send volumes make manual review impractical
  }

  reputation_options {
    reputation_metrics_enabled = true
  }
}

# Forward bounce/complaint events to SNS so a Lambda can handle list hygiene
resource "aws_sesv2_configuration_set_event_destination" "marketing_sns" {
  configuration_set_name = "marketing-emails"
  event_destination_name = "sns-bounces"

  event_destination {
    enabled              = true
    matching_event_types = ["BOUNCE", "COMPLAINT"]  # only forward actionable events

    sns_destination {
      topic_arn = aws_sns_topic.marketing_events.arn
    }
  }
}
```

At send time:

```go
ses.SendEmail({ ConfigurationSetName: "transactional-emails", ... })
ses.SendEmail({ ConfigurationSetName: "marketing-emails", ... })
```

#### 6. Bounce Rate & Suppression List

Hard bounces can count toward enforcement metrics without appearing in the account-level suppression list — particularly bounces from SES's **global suppression list** (`bounceSubType: "Suppressed"`), which count toward your bounce rate but don't get added to your account-level list.

##### (1) Suppression List

Each suppressed address is stored with the reason (`BOUNCE` or `COMPLAINT`). At send time, SES checks if the stored reason matches the config set's `suppressed_reasons` — only matching reasons are blocked.

```sh
# inspect why an address is suppressed
aws sesv2 get-suppressed-destination --email-address customer@example.com
```

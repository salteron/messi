Your task is to create a prototype microservice that emulates sending messages
to popular messengers (Viber, Telegram, WhatsApp).

The application should have the following functionality:
* Receive messages via API and send them to messengers (with user identifiers
  specified for each messenger).
* Ability to schedule message delivery by date/time.
* In case of unsuccessful message delivery, retry a certain number of times, but
  this should not affect the delivery of other messages.
* Prevent multiple sending of the same message (with identical content) to the
  same recipient.
* Ability to send one message to multiple recipients across multiple messengers
  within one request.

**Important**: It is necessary to emulate message sending; direct integration
with messengers is not required.

Request parameters should undergo validation (validation requirements are at
your discretion).

The task should be implemented in Ruby on Rails and sent to us along with a
README, which should contain deployment/launch instructions and API request
descriptions. The use of additional gems and tools is at your discretion, but
the choice must be justified in the README.

## ChatToJSON

A simple app that allows the user to type a message in a chat text view and when the "Generate JSON" button is pressed, a second scrollable text view will display a JSON payload with special contents extracted from the chat message.

Special content:
- Mentions: Words that are prefixed with an "@" and can contain alphanumeric characters as well as an underscore, e.g. @github
- Emoticons: Emoticons are words no longer than 15 alphanumeric characters contained in parentheses, e.g. (laughing)
- Links: Only http/https links will be picked up. In the JSON payload, each link detected will have the title as well, in addition to the link URL path.

The project is a solution to a test assignment formulated in [TASK.md](./TASK.md).

# Requirements

- [docker](https://www.docker.io/)
- [docker-compose](https://docs.docker.com/compose/)

# Run tests
`$ make compose-test`

# Run server
`$ make compose-web`

# API

The description is available in the Swagger file `swagger.yaml`. It can be opened using the [online editor](https://editor.swagger.io/).

##### Example
```
curl --request POST \
  --url http://localhost:3000/messages \
  --header 'content-type: application/json' \
  --data '{
	"text": "Hello, World!",
	"recipients": [
		{
			"messenger": "telegram",
			"messenger_user_id": "@trump"
		}
	]
}'
```

# Gems and Tools

Message sending is performed in the background to ensure application responsiveness. A separate job is created for each message recipient, ensuring independent delivery.

I utilize Sidekiq because it:
- parallelizes tasks onto threads, which is efficient for IO-heavy tasks like ours;
- implements requirements for task retry and deferred execution out of the box.

A database is integrated solely to satisfy the requirement of global uniqueness
for <text, recipient> pairs. Storing in `sidekiq.redis` is possible but not as
efficient and reliable.

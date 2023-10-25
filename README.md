Проект является решением тестового задания, сформулированного в
[TASK.md](./TASK.md).

# Requirements

- [docker](https://www.docker.io/)
- [docker-compose](https://docs.docker.com/compose/)

# Run tests
`$ make compose-test`

# Run server
`$ make compose-web`

# API

Описание на swagger в `swagger.yaml`. Можно открыть при помощи
[онлайн-редактора](https://editor.swagger.io/).

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

# Гемы и инструменты

Отправка сообщений осуществляется в фоне, чтобы обеспечить отзывчивость
приложения. Для каждого получателя сообщения ставится отдельный джоб, что
обеспечивает независимую доставку.

Заиспользован sidekiq, т.к.
- параллелит задачи на потоки, что эффективно в случае IO-heavy (как в нашем
  случае) задач;
- из коробки реализует требования по ретраю и отложенному выполнению задач.

Исключительно для удовлетворения требования глобальной уникальности
<текст, получатель> подключена база данных. Запоминать в `sidekiq.redis` можно,
но не так эффективно и надежно.

# Справочник API

Базовый URL: `http://localhost:8080`

## Пользователи и Аутентификация

### Регистрация пользователя

- **URL**: `/users/register`
- **Метод**: `POST`
- **Заголовки**: `Content-Type: application/json`
- **Тело запроса**:
  ```json
  {
    "username": "teacher1",
    "password": "password123",
    "name": "Иван Иванович",
    "role": "classTeacher"
  }
  ```
- **Доступные роли**:
  - `admin` - системный администратор
  - `schoolAdmin` - администрация школы
  - `classTeacher` - классный руководитель
  - `parent` - родитель учащегося
  - `student` - учащийся
- **Ответ при успехе (200)**:
  ```json
  {
    "id": "uuid-пользователя",
    "username": "teacher1",
    "name": "Иван Иванович",
    "role": "classTeacher"
  }
  ```

### Вход в систему (Login)

- **URL**: `/users/login`
- **Метод**: `POST`
- **Заголовки**: `Content-Type: application/json`
- **Тело запроса**:
  ```json
  {
    "username": "teacher1",
    "password": "password123"
  }
  ```
- **Ответ при успехе (200)**:
  ```json
  {
    "token": "jwt-token",
    "userId": "uuid-пользователя",
    "username": "teacher1",
    "role": "classTeacher"
  }
  ```

### Получить информацию о пользователе

- **URL**: `/users/{id}`
- **Метод**: `GET`
- **Параметры пути**:
  - `id` (string) - UUID пользователя
- **Ответ при успехе (200)**:
  ```json
  {
    "id": "uuid-пользователя",
    "username": "teacher1",
    "name": "Иван Иванович",
    "role": "classTeacher"
  }
  ```

### Получить всех пользователей

- **URL**: `/users/`
- **Метод**: `GET`
- **Ответ при успехе (200)**:
  ```json
  [
    {
      "id": "uuid-пользователя-1",
      "username": "teacher1",
      "name": "Иван Иванович",
      "role": "classTeacher"
    },
    {
      "id": "uuid-пользователя-2",
      "username": "parent1",
      "name": "Петр Петрович",
      "role": "parent"
    }
  ]
  ```

### Обновить пользователя

- **URL**: `/users/{id}`
- **Метод**: `PUT`

### Удалить пользователя

- **URL**: `/users/{id}`
- **Метод**: `DELETE`

---

## Записки (Notes)

### Создать записку

- **URL**: `/notes/`
- **Метод**: `POST`
- **Заголовки**: `Content-Type: application/json`

### Получить записки пользователя

- **URL**: `/notes/user/{userId}`
- **Метод**: `GET`

### Отметить записку как прочитанную

- **URL**: `/notes/{id}/read`
- **Метод**: `PUT`

---

## Обработка ошибок

Все ошибки возвращаются в формате:

```json
{
  "error": "Описание ошибки",
  "code": "ERROR_CODE"
}
```

## CORS

Сервер поддерживает CORS запросы. Все кроссдоменные запросы обрабатываются корректно.

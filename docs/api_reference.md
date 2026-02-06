# Справочник API

Базовый URL: `http://localhost:8080`

## Основные эндпоинты

| Метод  | URL                | Описание                   |
| :----- | :----------------- | :------------------------- |
| POST   | `/users/register`  | Регистрация                |
| POST   | `/users/invite`    | Создать приглашение        |
| POST   | `/users/login`     | Вход                       |
| GET    | `/users/`          | Получить всех              |
| GET    | `/users/{id}`      | Получить одного            |
| PATCH  | `/users/{id}/role` | Изменить роль пользователя |
| PUT    | `/users/{id}`      | Обновить                   |
| DELETE | `/users/{id}`      | Удалить                    |

## Пользователи и Аутентификация

### Регистрация пользователя

- **URL**: `/users/register`
- **Метод**: `POST`
- **Заголовки**: `Content-Type: application/json`
- **Тело запроса (вариант 1: обычная регистрация)**:
  ```json
  {
    "username": "teacher1",
    "password": "password123",
    "name": "Иван Иванович",
    "role": "classTeacher"
  }
  ```
- **Тело запроса (вариант 2: по приглашению)**:
  ```json
  {
    "username": "student1",
    "password": "password123",
    "name": "Петр Петров",
    "inviteToken": "d4e5f6g7-h8i9-j0k1-l2m3-n4o5p6q7r8s9"
  }
  ```
- **Доступные роли**:
  - `admin` - системный администратор
  - `schoolAdmin` - администрация школы
  - `classTeacher` - классный руководитель
  - `parent` - родитель учащегося
  - `student` - учащийся
- **Ответ при успехе (201)**:
  ```json
  {
    "id": "uuid-пользователя",
    "username": "teacher1",
    "name": "Иван Иванович",
    "role": "classTeacher"
  }
  ```

### Создание приглашения

- **URL**: `/users/invite`
- **Метод**: `POST`
- **Доступ**: только `admin`, `schoolAdmin`, `classTeacher`
- **Тело запроса**:
  ```json
  {
    "role": "student",
    "senderRole": "classTeacher"
  }
  ```
  _(Примечание: `senderRole` используется для симуляции проверки прав в текущей версии API)_
- **Ответ при успехе (201)**:
  ```json
  {
    "token": "d4e5f6g7-h8i9-j0k1-l2m3-n4o5p6q7r8s9",
    "role": "student",
    "isUsed": false,
    "link": "http://localhost:8080/users/register?inviteToken=d4e5f6g7-h8i9-j0k1-l2m3-n4o5p6q7r8s9"
  }
  ```

### Изменение роли пользователя

- **URL**: `/users/{id}/role`
- **Метод**: `PATCH`
- **Доступ**: только `admin`, `schoolAdmin`, `classTeacher`
- **Тело запроса**:
  ```json
  {
    "role": "schoolAdmin",
    "senderRole": "admin"
  }
  ```
  _(Примечание: `senderRole` используется для симуляции проверки прав в текущей версии API)_
- **Ответ при успехе (200)**:
  ```json
  {
    "id": "uuid-пользователя",
    "username": "teacher1",
    "name": "Иван Иванович",
    "role": "schoolAdmin"
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

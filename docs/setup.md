# Установка и запуск проекта

## Требования

- **Dart SDK** 3.0.0 или выше ([скачать](https://dart.dev/get-dart))
- **Git** (опционально)

### Проверка установки Dart

```bash
dart --version
```

## Быстрый старт

### 1. Установка зависимостей

```bash
dart pub get
```

### 2. Генерация кода

```bash
dart run build_runner build
```

Генерирует файлы `*.g.dart` для JSON сериализации.

### 3. Запуск сервера

```bash
dart bin/server.dart
```

Сервер будет доступен на `http://localhost:8080`

## Запуск с собственным портом

```bash
PORT=9000 dart bin/server.dart
```

## Проверка работы

```bash
curl http://localhost:8080/users/
```

Должен вернуть пустой массив `[]`

## Переменные окружения

Создайте файл `.env` в корне проекта:

```bash
PORT=8080
MONGO_URL=mongodb://localhost:27017/electronic_documents
LOG_LEVEL=INFO
```

### Основные переменные

| Переменная  | По умолчанию     | Описание                  |
| ----------- | ---------------- | ------------------------- |
| `PORT`      | 8080             | Порт сервера              |
| `MONGO_URL` | (не установлена) | URL подключения к MongoDB |
| `LOG_LEVEL` | INFO             | Уровень логирования       |

## Разработка

### Анализ кода

```bash
dart analyze
```

### Форматирование кода

```bash
dart format lib bin
```

### Регенерация кода при разработке

```bash
dart run build_runner watch
```

### Запуск тестов

```bash
dart test
```

## Решение проблем

### "Could not find package..."

Выполните `dart pub get`

### Ошибка при генерации кода JSON

```bash
rm -rf .dart_tool
dart pub get
dart run build_runner build --delete-conflicting-outputs
```

### Порт уже занят

Используйте другой порт через переменную окружения `PORT`

## Docker

```bash
docker build -t electronic-doc-backend .
docker run -p 8080:8080 -e PORT=8080 electronic-doc-backend
```

## Дальнейшее развитие

После успешного запуска:

1. Прочитайте [архитектуру](./architecture.md)
2. Изучите [справочник API](./api_reference.md)
3. Начните разработку

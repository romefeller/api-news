# API-News

API-News is a service that provides news-related endpoints, fetching and displaying news articles based on specific criteria from GApiNews. This is only for educational purposes.

## Routes

### 1. Fetch All News Articles

- **Endpoint:** `/`
- **Method:** `GET`
- **Route Name:** `AllNewsR`

Fetches all the news articles available with a cache of 10.

### 2. Fetch N Latest News Articles

- **Endpoint:** `/latest/<qty>/`
- **Method:** `GET`
- **Route Name:** `NnewsR`
- **Parameters:**
  - `<qty>`: An integer specifying the number of the latest news articles to get.

Fetches and displays the specified number of latest news articles with cache.

### 3. Search Articles by Title

- **Endpoint:** `/news/title/<keyword>/search/`
- **Method:** `GET`
- **Route Name:** `TitleSearchR`
- **Parameters:**
  - `<keyword>`: A string keyword to search articles based on their title.

Searches and displays news articles where the title contains the specified keyword with cache.

### 4. Search Articles by Content

- **Endpoint:** `/news/content/<keyword>/search`
- **Method:** `GET`
- **Route Name:** `ContentSearchR`
- **Parameters:**
  - `<keyword>`: A string keyword to search articles based on their content.

Searches and displays news articles where the content contains the specified keyword with cache.

## Usage

To fetch the latest 5 news articles:

```http
GET /news/5/

```curl
curl http://localhost:300/news/5

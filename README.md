# AI Support Gateway

An Elixir-based API gateway that routes customer support conversations to different AI language models based on company-specific configurations and requirements. The gateway uses OAuth 2.0 with implicit flow for authentication.

## Features

- OAuth 2.0 implicit flow authentication
- Company-specific configurations
- Dynamic AI model routing based on conversation context
- Support for multiple AI language models
- Docker and docker-compose support
- RESTful API endpoints

## Prerequisites

- Docker and docker-compose
- Elixir 1.15 or later (for local development)
- PostgreSQL (provided via Docker)

## Getting Started

1. Clone the repository:
```bash
git clone <repository-url>
cd ai-support-gateway
```

2. Start the application using Docker Compose:
```bash
docker-compose up --build
```

The API will be available at `http://localhost:4000`.

## API Endpoints

### OAuth 2.0 Endpoints

- `GET /api/oauth/authorize` - OAuth 2.0 authorization endpoint (implicit flow)
- `POST /api/oauth/token` - OAuth 2.0 token endpoint

### Company Configuration Endpoints

- `GET /api/company_configs` - List all company configurations
- `POST /api/company_configs` - Create a new company configuration
- `GET /api/company_configs/:id` - Get a specific company configuration
- `PUT /api/company_configs/:id` - Update a company configuration
- `DELETE /api/company_configs/:id` - Delete a company configuration

### Conversation Endpoints

- `POST /api/conversations` - Create a new conversation
- `GET /api/conversations/:id` - Get a specific conversation
- `GET /api/conversations` - List conversations

## Company Configuration Example

```json
{
  "company_config": {
    "name": "Example Corp",
    "api_key": "your-api-key",
    "default_model": "gpt-4",
    "allowed_models": ["gpt-4", "gpt-3.5-turbo", "claude-3"],
    "max_tokens": 2000,
    "temperature": 0.7,
    "routing_rules": [
      {
        "condition": {
          "contains_keywords": ["technical", "code", "programming"]
        },
        "model": "gpt-4"
      },
      {
        "condition": {
          "sentiment": "negative"
        },
        "model": "claude-3"
      }
    ]
  }
}
```

## OAuth 2.0 Implicit Flow

1. Redirect users to:
```
GET /api/oauth/authorize?
  response_type=token&
  client_id=YOUR_CLIENT_ID&
  redirect_uri=YOUR_REDIRECT_URI
```

2. After successful authentication, users will be redirected to:
```
YOUR_REDIRECT_URI#access_token=ACCESS_TOKEN&token_type=Bearer&expires_in=86400
```

## Development

1. Install dependencies:
```bash
mix deps.get
```

2. Create and migrate the database:
```bash
mix ecto.setup
```

3. Start the Phoenix server:
```bash
mix phx.server
```

## Testing

Run the test suite:
```bash
mix test
```

## License

This project is licensed under the MIT License - see the LICENSE file for details. 
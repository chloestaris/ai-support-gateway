defmodule AiSupportGatewayWeb.Schemas do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule CompanyConfig do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "CompanyConfig",
      description: "A company configuration for AI model routing",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Company config ID"},
        name: %Schema{type: :string, description: "Company name"},
        api_key: %Schema{type: :string, description: "API key for authentication"},
        default_model: %Schema{type: :string, description: "Default AI model to use"},
        allowed_models: %Schema{type: :array, items: %Schema{type: :string}, description: "List of allowed AI models"},
        max_tokens: %Schema{type: :integer, description: "Maximum tokens for AI responses"},
        temperature: %Schema{type: :number, format: :float, description: "Temperature parameter for AI models"},
        routing_rules: %Schema{
          type: :array,
          items: %Schema{
            type: :object,
            properties: %{
              condition: %Schema{
                type: :object,
                properties: %{
                  contains_keywords: %Schema{type: :array, items: %Schema{type: :string}},
                  sentiment: %Schema{type: :string},
                  language: %Schema{type: :string}
                }
              },
              model: %Schema{type: :string}
            }
          },
          description: "Rules for routing conversations to specific models"
        },
        active: %Schema{type: :boolean, description: "Whether the configuration is active"}
      },
      required: [:name, :api_key, :default_model, :allowed_models]
    })
  end

  defmodule Conversation do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Conversation",
      description: "A customer support conversation",
      type: :object,
      properties: %{
        text: %Schema{type: :string, description: "Conversation text"},
        sentiment: %Schema{type: :string, description: "Detected sentiment"},
        detected_language: %Schema{type: :string, description: "Detected language"},
        api_key: %Schema{type: :string, description: "Company API key for authentication"}
      },
      required: [:text, :api_key]
    })
  end

  defmodule ConversationResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "ConversationResponse",
      description: "Response from the AI model",
      type: :object,
      properties: %{
        model: %Schema{type: :string, description: "AI model used"},
        response: %Schema{type: :string, description: "AI model response"},
        conversation_id: %Schema{type: :string, format: :uuid, description: "Unique conversation ID"},
        metadata: %Schema{
          type: :object,
          properties: %{
            max_tokens: %Schema{type: :integer},
            temperature: %Schema{type: :number, format: :float}
          }
        }
      },
      required: [:model, :response, :conversation_id]
    })
  end

  defmodule TokenResponse do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "TokenResponse",
      description: "OAuth token response",
      type: :object,
      properties: %{
        access_token: %Schema{type: :string, description: "JWT access token"},
        token_type: %Schema{type: :string, description: "Token type (Bearer)"},
        expires_in: %Schema{type: :integer, description: "Token expiration time in seconds"}
      },
      required: [:access_token, :token_type, :expires_in]
    })
  end

  defmodule Error do
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Error",
      description: "Error response",
      type: :object,
      properties: %{
        error: %Schema{type: :string, description: "Error message"}
      },
      required: [:error]
    })
  end
end 
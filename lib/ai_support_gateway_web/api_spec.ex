defmodule AiSupportGatewayWeb.ApiSpec do
  alias OpenApiSpex.{Components, Info, OpenApi, Operation, Paths, Server}
  alias AiSupportGatewayWeb.{Endpoint, Router}
  alias AiSupportGatewayWeb.Schemas.{CompanyConfig, Conversation, ConversationResponse, TokenResponse, Error}

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "AI Support Gateway",
        version: "1.0",
        description: "API for routing customer support conversations to different AI models"
      },
      paths: paths(),
      components: %Components{
        schemas: %{},
        securitySchemes: %{
          "bearer" => %OpenApiSpex.SecurityScheme{
            type: "http",
            scheme: "bearer",
            bearerFormat: "JWT",
            description: "Enter the token you received from the auth endpoint"
          }
        }
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end

  defp paths do
    %{
      "/api/health" => %OpenApiSpex.PathItem{
        get: %OpenApiSpex.Operation{
          tags: ["Health"],
          summary: "Health check endpoint",
          description: "Returns the health status of the API",
          operationId: "AiSupportGatewayWeb.HealthController.health",
          responses: %{
            200 => Operation.response("Health check successful", description: "Health check passed")
          }
        }
      },
      "/api/oauth/authorize" => %{
        get: %OpenApiSpex.Operation{
          tags: ["OAuth"],
          summary: "OAuth 2.0 authorization endpoint (implicit flow)",
          parameters: [
            %{
              name: :client_id,
              in: :query,
              required: true,
              schema: %OpenApiSpex.Schema{type: :string}
            },
            %{
              name: :redirect_uri,
              in: :query,
              required: true,
              schema: %OpenApiSpex.Schema{type: :string}
            },
            %{
              name: :response_type,
              in: :query,
              required: true,
              schema: %OpenApiSpex.Schema{type: :string, enum: ["token"]}
            }
          ],
          responses: %{
            302 => {"Redirect to client with token", %OpenApiSpex.Response{
              description: "Successful authorization, redirecting with access token"
            }}
          }
        }
      },
      "/api/oauth/token" => %{
        post: %OpenApiSpex.Operation{
          tags: ["OAuth"],
          summary: "OAuth 2.0 token endpoint",
          requestBody: %OpenApiSpex.RequestBody{
            required: true,
            content: %{
              "application/json" => %OpenApiSpex.MediaType{
                schema: %OpenApiSpex.Schema{
                  type: :object,
                  properties: %{
                    grant_type: %OpenApiSpex.Schema{type: :string, enum: ["password"]},
                    username: %OpenApiSpex.Schema{type: :string},
                    password: %OpenApiSpex.Schema{type: :string}
                  },
                  required: [:grant_type, :username, :password]
                }
              }
            }
          },
          responses: %{
            200 => {"Token response", %OpenApiSpex.Response{
              description: "Successfully generated access token",
              content: {"application/json", TokenResponse}
            }},
            401 => {"Unauthorized", %OpenApiSpex.Response{
              description: "Authentication failed",
              content: {"application/json", Error}
            }}
          }
        }
      },
      "/api/company_configs" => %{
        get: %OpenApiSpex.Operation{
          tags: ["Company Configurations"],
          summary: "List all company configurations",
          security: [%{"bearer_auth" => []}],
          responses: %{
            200 => {"Company configs response", %OpenApiSpex.Response{
              description: "Successfully retrieved company configurations",
              content: {"application/json", %OpenApiSpex.Schema{
                type: :object,
                properties: %{
                  data: %OpenApiSpex.Schema{
                    type: :array,
                    items: CompanyConfig
                  }
                }
              }}
            }}
          }
        },
        post: %OpenApiSpex.Operation{
          tags: ["Company Configurations"],
          summary: "Create a new company configuration",
          security: [%{"bearer_auth" => []}],
          requestBody: %OpenApiSpex.RequestBody{
            required: true,
            content: %{
              "application/json" => %OpenApiSpex.MediaType{
                schema: %OpenApiSpex.Schema{
                  type: :object,
                  properties: %{
                    company_config: CompanyConfig
                  },
                  required: [:company_config]
                }
              }
            }
          },
          responses: %{
            201 => {"Company config created", %OpenApiSpex.Response{
              description: "Company configuration successfully created",
              content: {"application/json", %OpenApiSpex.Schema{
                type: :object,
                properties: %{
                  data: CompanyConfig
                }
              }}
            }},
            422 => {"Validation errors", %OpenApiSpex.Response{
              description: "Invalid request parameters",
              content: {"application/json", Error}
            }}
          }
        }
      },
      "/api/conversations" => %{
        post: %OpenApiSpex.Operation{
          tags: ["Conversations"],
          summary: "Create a new conversation",
          requestBody: %OpenApiSpex.RequestBody{
            required: true,
            content: %{
              "application/json" => %OpenApiSpex.MediaType{
                schema: Conversation
              }
            }
          },
          responses: %{
            200 => {"Conversation response", %OpenApiSpex.Response{
              description: "Conversation successfully created",
              content: {"application/json", ConversationResponse}
            }},
            401 => {"Unauthorized", %OpenApiSpex.Response{
              description: "Authentication failed",
              content: {"application/json", Error}
            }}
          }
        },
        get: %OpenApiSpex.Operation{
          tags: ["Conversations"],
          summary: "List conversations",
          security: [%{"bearer_auth" => []}],
          responses: %{
            200 => {"Conversations list", %OpenApiSpex.Response{
              description: "Successfully retrieved conversations",
              content: {"application/json", %OpenApiSpex.Schema{
                type: :object,
                properties: %{
                  conversations: %OpenApiSpex.Schema{
                    type: :array,
                    items: ConversationResponse
                  }
                }
              }}
            }}
          }
        }
      }
    }
  end
end 
FROM hexpm/elixir:1.15.7-erlang-26.1.2-alpine-3.18.4 AS build

# Install build dependencies
RUN apk add --no-cache build-base git python3 curl nodejs npm

WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

# Copy config files
COPY config config

# Compile dependencies
RUN mix deps.compile

# Copy assets
COPY assets assets
WORKDIR /app/assets
RUN npm install
WORKDIR /app

# Set production environment
ENV MIX_ENV=prod

# Compile and digest assets
RUN mix assets.deploy

# Copy all application files
COPY lib lib
COPY priv priv

# Compile application
RUN mix compile

# Build release
COPY rel rel
RUN mix release

# Start a new build stage
FROM alpine:3.18.4

RUN apk add --no-cache libstdc++ openssl ncurses-libs

WORKDIR /app

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/ai_support_gateway ./

ENV HOME=/app

CMD ["bin/ai_support_gateway", "start"] 
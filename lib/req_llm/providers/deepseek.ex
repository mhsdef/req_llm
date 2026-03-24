defmodule ReqLLM.Providers.Deepseek do
  @moduledoc """
  DeepSeek AI provider – OpenAI-compatible Chat Completions API.

  ## Implementation

  Uses built-in OpenAI-style encoding/decoding defaults.
  DeepSeek is fully OpenAI-compatible, so no custom request/response handling is needed.

  ## Authentication

  Requires a DeepSeek API key from https://platform.deepseek.com/

  ## Configuration

      # Add to .env file (automatically loaded)
      DEEPSEEK_API_KEY=your-api-key

  ## Examples

      # Basic usage
      ReqLLM.generate_text(%{provider: :deepseek, id: "deepseek-chat"}, "Hello!")

      # With custom parameters
      ReqLLM.generate_text(%{provider: :deepseek, id: "deepseek-reasoner"}, "Write a function",
        temperature: 0.2,
        max_tokens: 2000
      )

      # Streaming
      ReqLLM.stream_text(%{provider: :deepseek, id: "deepseek-chat"}, "Tell me a story")
      |> Enum.each(&IO.write/1)

  ## Models

  DeepSeek offers several models including:

  - `deepseek-chat` - General purpose conversational model
  - `deepseek-reasoner` - Reasoning and problem-solving

  See https://platform.deepseek.com/docs for full model documentation.
  """

  use ReqLLM.Provider,
    id: :deepseek,
    default_base_url: "https://api.deepseek.com",
    default_env_key: "DEEPSEEK_API_KEY"

  use ReqLLM.Provider.Defaults

  @impl ReqLLM.Provider
  def prepare_request(operation, _model_spec, _input, _opts)
      when operation in [:embedding, :transcription, :speech] do
    supported_operations = [:chat, :object]

    {:error,
     ReqLLM.Error.Invalid.Parameter.exception(
       parameter:
         "operation: #{inspect(operation)} not supported by #{inspect(__MODULE__)}. Supported operations: #{inspect(supported_operations)}"
     )}
  end

  def prepare_request(operation, model_spec, input, opts) do
    ReqLLM.Provider.Defaults.prepare_request(__MODULE__, operation, model_spec, input, opts)
  end

  @provider_schema []
end

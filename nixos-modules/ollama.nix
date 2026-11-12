{
  services.ollama = {
    enable = true;
    user = null; # DynamicUser
    environmentVariables.OLLAMA_CONTEXT_LENGTH="32768";
  };
}

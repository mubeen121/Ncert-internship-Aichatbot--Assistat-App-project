/// ============================================================
///  API CONFIGURATION
/// ============================================================
/// This app uses Groq (https://groq.com) to power the assistant.
/// Groq runs open models (Llama, Gemma, etc.) on custom hardware,
/// so responses come back extremely fast, and it has a generous
/// free tier.
///
/// HOW TO GET YOUR FREE API KEY:
///   1. Go to https://console.groq.com
///   2. Sign in (free, no card required)
///   3. Go to "API Keys" -> "Create API Key"
///   4. Copy the key and paste it below, replacing the placeholder.
///
/// NOTE: Never commit your real key to a public GitHub repo.
/// ============================================================

class ApiConfig {
  // 👇 PASTE YOUR FREE GROQ API KEY HERE
  static const String groqApiKey = "your api key here";

  // Free-tier Groq model. Other good options:
  //   "llama-3.1-8b-instant"   (fastest)
  //   "gemma2-9b-it"
  static const String model = "llama-3.3-70b-versatile";

  static const String endpoint =
      "https://api.groq.com/openai/v1/chat/completions";
}

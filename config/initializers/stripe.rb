Rails.application.credentials.dig(:stripe, :secret_key)
Stripe.api_version = "2023-08-16" # stripe API Versioningを参照
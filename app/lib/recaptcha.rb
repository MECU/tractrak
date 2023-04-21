module Recaptcha
  # {
  #   "success": true,
  #   "challenge_ts": "2022-02-28T15:14:30.096Z",
  #   "hostname": "example.com",
  #   "error-codes": [],
  #   "action": "login",
  #   "cdata": "sessionid-123456789"
  # }
  def verify_recaptcha(response)
    body = { secret: ENV['CLOUDFLARE_TURNSTILE'], response: }
    res = HTTParty.post('https://challenges.cloudflare.com/turnstile/v0/siteverify', body:)

    return false unless res.success?
    return true if res.parsed_response['success']

    flash[:recaptcha_error] = true
    false
  end
end
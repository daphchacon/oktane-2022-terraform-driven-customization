# Deploy post-login action
resource "auth0_action" "my_action" {
  name    = "Test Post-Login Action"
  runtime = "node16"
  deploy  = true
  # Require code to have been transpiled by using `actions_out`
  code = file("actions_out/postLogin.js")

  supported_triggers {
    id      = "post-login"
    version = "v3"
  }

  dependencies {
    name    = "lodash"
    version = "latest"
  }

  dependencies {
    name    = "request"
    version = "latest"
  }

  secrets {
    name  = "FOO"
    value = "Foo"
  }

  secrets {
    name  = "BAR"
    value = "Bar"
  }
}

resource "auth0_resource_server" "sample_resource_server" {
  name       = "Sample Resource Server"
  identifier = "https://api.example.com"

  scopes {
    value       = "create:foo"
    description = "Create foos"
  }

  scopes {
    value       = "delete:foo"
    description = "Delete foos"
  }
}

resource "auth0_role" "foo_maker" {
  name        = "Foo Maker"
  description = "Can Create Foos"

  permissions {
    resource_server_identifier = auth0_resource_server.sample_resource_server.identifier
    name                       = "create:foo"
  }
}

resource "auth0_role" "foo_fighter" {
  name        = "Foo Fighter"
  description = "Can Delete Foos"

  permissions {
    resource_server_identifier = auth0_resource_server.sample_resource_server.identifier
    name                       = "delete:foo"
  }
}

resource "auth0_user" "user1" {
  connection_name = "Username-Password-Authentication"
  username        = format("fighter_%s", uuid())
  email           = "user1@example.com"
  password        = "passpass$12$12"
  email_verified  = true
  roles           = [auth0_role.foo_fighter.id]
}

output "fighter_1" {
  value = auth0_user.user1.id
}

resource "auth0_user" "user2" {
  connection_name = "Username-Password-Authentication"
  username        = format("maker_%s", uuid())
  email           = "user2@example.com"
  password        = "passpass$12$12"
  email_verified  = true
  roles           = [auth0_role.foo_maker.id]
}

output "maker_1" {
  value = auth0_user.user2.id
}

resource "auth0_user" "user3" {
  connection_name = "Username-Password-Authentication"
  username        = format("blocked_%s", uuid())
  email           = "user3@example.com"
  password        = "passpass$12$12"
  email_verified  = true
  blocked         = true
  roles           = [auth0_role.foo_fighter.id]
}

output "blocked_1" {
  value = auth0_user.user3.id
}

resource "auth0_user" "user4" {
  connection_name = "Username-Password-Authentication"
  username        = format("unverified_%s", uuid())
  email           = "user4@example.com"
  password        = "passpass$12$12"
  email_verified  = false
  roles           = [auth0_role.foo_fighter.id, auth0_role.foo_maker.id]
}

output "unverified_1" {
  value = auth0_user.user4.id
}

resource "auth0_user" "user5" {
  connection_name = "Username-Password-Authentication"
  username        = format("noperm_%s", uuid())
  email           = "user5@example.com"
  password        = "passpass$12$12"
  email_verified  = true
  roles           = []
}

output "noperms_1" {
  value = auth0_user.user5.id
}

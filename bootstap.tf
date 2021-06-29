/*
 * Provider info
 */
provider "cloudflare" {
  account_id = var.cloudflare_account_id
  api_key    = var.cloudflare_token
  email      = var.cloudflare_email
}

provider "digitalocean" {
  token = var.do_token
}

provider "random" {
}

/*
 * Variables!
 */
# Cloudflare
variable "cloudflare_zone" {
  description = "The Cloudflare Zone to use."
  type        = string
}

variable "cloudflare_zone_id" {
  description = "The Cloudflare UUID for the Zone to use."
  type        = string
}

variable "cloudflare_account_id" {
  description = "The Cloudflare UUID for the Account the Zone lives in."
  type        = string
  sensitive   = true
}

variable "cloudflare_email" {
  description = "The Cloudflare user."
  type        = string
  sensitive   = true
}

variable "cloudflare_token" {
  description = "The Cloudflare user's API token."
  type        = string
}

# Digital Ocean
variable "do_token" {
  description = "API token for Digtal Ocean user"
  type        = string
}

variable "do_key_name" {
  type        = string
}

variable "do_key_path" {
  type        = string
}

# cloud-init 
variable "mysql_user_password" {
  description = "Password for the ghost DB MySQL user"
  type        = string
}

variable "mysql_password" {
  description = "Password for the root user of the MySQL container"
  type = string
}
/*
 * Provider required source info
 */

terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    random = {
      source = "hashicorp/random"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
#!/usr/bin/env sh

########################################################################
# Hurricane Electric hook script for acme.sh
#
# Environment variables:
#
#  - $HE_Username  (your dns.he.net username)
#  - $HE_Password  (your dns.he.net password)
#
# Author: Ondrej Simek <me@ondrejsimek.com>
# Git repo: https://github.com/angel333/acme.sh
# Updated based on yoursunny work

#-- dns_he_add() - Add TXT record --------------------------------------
# Usage: dns_he_add _acme-challenge.subdomain.domain.com "XyZ123..."

dns_he_add() {
  _txt_value=$2
  _info "Using DNS-01 Hurricane Electric hook"

  HE_Username="${HE_Username:-$(_readaccountconf_mutable HE_Username)}"
  HE_Password="${HE_Password:-$(_readaccountconf_mutable HE_Password)}"
  if [ -z "$HE_Username" ] || [ -z "$HE_Password" ]; then
    HE_Username=
    HE_Password=
    _err "No auth details provided. Please set user credentials using the \$HE_Username and \$HE_Password environment variables."
    return 1
  fi
  _saveaccountconf_mutable HE_Username "$HE_Username"
  _saveaccountconf_mutable HE_Password "$HE_Password"

  username_encoded="$(printf "%s" "${HE_Username}" | _url_encode)"
  password_encoded="$(printf "%s" "${HE_Password}" | _url_encode)"
  body="hostname=${username_encoded}&password=${password_encoded}&txt=$_txt_value"
  response="$(_post "$body" "https://dyn.dns.he.net/nic/update")"
  exit_code="$?"
  if [ "$exit_code" -eq 0 ]; then
    _info "TXT record added successfully."
  else
    _err "Couldn't add the TXT record."
  fi
  _debug2 response "$response"
  return "$exit_code"
}

#-- dns_he_rm() - Remove TXT record ------------------------------------
# Usage: dns_he_rm _acme-challenge.subdomain.domain.com "XyZ123..."

dns_he_rm() {
  _txt_value=$2
  _info "Using DNS-01 Hurricane Electric hook"

  HE_Username="${HE_Username:-$(_readaccountconf_mutable HE_Username)}"
  HE_Password="${HE_Password:-$(_readaccountconf_mutable HE_Password)}"
  if [ -z "$HE_Username" ] || [ -z "$HE_Password" ]; then
    HE_Username=
    HE_Password=
    _err "No auth details provided. Please set user credentials using the \$HE_Username and \$HE_Password environment variables."
    return 1
  fi
  _saveaccountconf_mutable HE_Username "$HE_Username"
  _saveaccountconf_mutable HE_Password "$HE_Password"

  username_encoded="$(printf "%s" "${HE_Username}" | _url_encode)"
  password_encoded="$(printf "%s" "${HE_Password}" | _url_encode)"
  body="hostname=${username_encoded}&password=${password_encoded}&txt=."
  response="$(_post "$body" "https://dyn.dns.he.net/nic/update")"
  exit_code="$?"
  if [ "$exit_code" -eq 0 ]; then
    _info "TXT record added successfully."
  else
    _err "Couldn't add the TXT record."
  fi
  _debug2 response "$response"
  return "$exit_code"
}
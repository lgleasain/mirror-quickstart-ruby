require 'yaml'

# The functions in this file are called by those in oauth_utils.rb. This
# separates the OAuth2 portion of the code from the app-specific portion
# that decides where and how user credentials should be stored. This
# example uses an SQLite database; your application may have other needs
# (another database, an ORM like ActiveRecord, Redis, etc.)
#
# Feel to modify these functions to fit your needs or rewrite them entirely.

##
# Retrieved stored credentials for the provided user ID.
#
# @param [String] user_id
#   User's ID.
# @return [Signet::OAuth2::Client]
#   Stored OAuth 2.0 credentials if found, nil otherwise.
def get_stored_credentials_ar(user_id)
  row = Credential.where(user_id: user_id).last
  if row
    hash = YAML::load(row.credentials)
    Signet::OAuth2::Client.new(hash)
  else
    nil
  end
end

##
# Gets an array containing the IDs of all users who have credentials in the
# database.
#
# @return [Array]
#   An array containing user IDs.
def list_stored_user_ids_ar
  Credential.all.map {|credential| credential.user_id}
end

##
# Store OAuth 2.0 credentials in the application's database.
#
# @param [String] user_id
#   User's ID.
# @param [Signet::OAuth2::Client] credentials
#   OAuth 2.0 credentials to store.
def store_credentials_ar(user_id, credentials)
  hash = {
    access_token: credentials.access_token,
    refresh_token: credentials.refresh_token
  }
  credential = Credential.where(user_id: user_id).first_or_create(user_id: user_id,
                                                    credentials: hash.to_yaml)
  credential.save!
  get_stored_credentials_ar(user_id)
end


require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Clarity < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://api.clarity.fm',
        :authorize_url => 'https://clarity.fm/oauth/authorize',
        :token_url => 'https://clarity.fm/oauth/authorize'
      }

      def request_phase
        super
      end

      uid { raw_info['id'].to_s }

      info do
        {
          'nickname' => raw_info['nickname'],
          'name' => "#{raw_info['first_name']} #{raw_info['last_name']}",
          'image_url' => raw_info['image_url'],
          'urls' => {
            'profile' => "https://clarity.fm/#{raw_info['nickname']}"
          },
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      def raw_info
        access_token.options[:mode] = :query
        access_token.options[:param_name] = "oauth_token"
        @raw_info ||= access_token.get('/1/members/current').parsed
      end
    end
  end
end

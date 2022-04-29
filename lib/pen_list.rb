# frozen_string_literal: true

require_relative "pen_list/version"
require 'rack/attack'
require 'rails/railtie'

module PenList
  class Error < StandardError; end

  class Railtie < Rails::Railtie
    initializer "[Pen List] Rack-Attack setup", after: :add_routing_paths do |app|

      app.reload_routes!
      SAFE_PREFIXES = app.routes.routes.map {|r| r.path.spec.to_s.split('(')[0].split('/')[1]}.uniq.compact.to_set - %w(auth rails assets cable *path)

      Rack::Attack.safelist("[Pen List] logged in users and defined paths are safe") do |req|
        SAFE_PREFIXES.include?(req.path.split('/')[1]) ||
          req.session[:user] ||
          req.session[:current_user_id]
      end

      Rack::Attack.blocklist('[Pen List] Fail2Ban for common pen testing requests') do |req|
        Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes) do
          path = req.path.downcase
          path.include?('/etc/passwd') ||
            path.include?('wp-login') ||
            path.include?('cgi-bin') ||
            path.include?('servlet') ||
            path.include?('php') ||
            path.include?('admin') ||
            path.include?('.git') ||
            path.end_with?('.jsp') ||
            path.end_with?('.env') ||
            path.end_with?('.exe') ||
            path.end_with?('.txt') ||
            path.end_with?('.xml') ||
            path.end_with?('.sql') ||
            path.start_with?('/.') ||
            path.start_with?('/_') ||
            req.get? && path == '/auth/google_oauth2'
        end
      end
    end
  end
end

# frozen_string_literal: true

require_relative "pen_list/version"
require 'rack/attack'
require 'rails/railtie'

module PenList
  class Error < StandardError; end

  class Railtie < Rails::Railtie
    initializer "[Pen List] Rack-Attack setup", after: :add_routing_paths do |app|

      app.reload_routes!
      SAFE_PREFIXES = app.routes.routes.map {|r| r.path.spec.to_s.split('(')[0].split('/')[1]}.uniq.compact.to_set - %w(auth cable *path admin)

      Rack::Attack.safelist("[Pen List] logged in users and defined paths are safe") do |req|
        SAFE_PREFIXES.include?(req.path.split('/')[1]) ||
          req.session[:user] ||
          req.session[:current_user_id] # || don't forget the OR when adding more conditions
      end

      Rack::Attack.blocklist('[Pen List] Fail2Ban for common pen testing requests') do |req|
        Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 5.minutes) do
          path = req.path.downcase
          path.include?('/etc/passwd') ||
            path.include?('/bc/') ||
            path.include?('/bk/') ||
            path.include?('/data/') ||
            path.include?('/dist/') ||
            path.include?('/feed/') ||
            path.include?('/js/') ||
            path.include?('/resources/') ||
            path.include?('/static/') ||

            path.include?('/blog') ||
            path.include?('/api') ||

            path.include?('admin') ||
            path.include?('ajax') ||
            path.include?('backup') ||
            path.include?('catalog') ||
            path.include?('cgi-bin') ||
            path.include?('credentials') ||
            path.include?('config') ||
            path.include?('etc') ||
            path.include?('exporttool') ||
            path.include?('fatmous') ||
            path.include?('getkdata') ||
            path.include?('git') ||
            path.include?('login_index') ||
            path.include?('login.htm') ||
            path.include?('management') ||
            path.include?('meta-inf') ||
            path.include?('old') ||
            path.include?('php') ||
            path.include?('public') ||
            path.include?('security/login') ||
            path.include?('server-status') ||
            path.include?('servlet') ||
            path.include?('telerik') ||
            path.include?('test_404_page') ||
            path.include?('the_ins_ru') ||
            path.include?('wordpress') ||
            path.include?('wp-content') ||
            path.include?('wp-include') ||
            path.include?('wp-json') ||

            path.end_with?('.cfc') ||
            path.end_with?('.do') ||
            path.end_with?('.env') ||
            path.end_with?('.exe') ||
            path.end_with?('.html') ||
            path.end_with?('.gz') ||
            path.end_with?('.jsp') ||
            path.end_with?('.sql') ||
            path.end_with?('.txt') ||
            path.end_with?('.xml') ||

            path.start_with?('/.') ||
            path.start_with?('/_') ||

            req.get? && path == '/auth/google_oauth2' ||
            req.post? && path == '/' # || don't forget the OR when adding more conditions
        end
      end
    end
  end
end

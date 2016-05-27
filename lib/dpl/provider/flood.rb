require 'net/http'
require "uri"

module DPL
  class Provider
    class Flood < Provider

      FLOOD_REPEAT_URL = "https://api.flood.io/floods/:flood_id/webhook"

      def check_app
        error "must supply flood_id option or FLOOD_ID environment variable" if !options[:flood_id] && !context.env['FLOOD_ID']
      end

      def deploy
        context.fold("Preparing deploy") { check_app }
        context.fold("Scheduling Load Test") { repeat_flood }
      end

      def repeat_flood
        # flood_id (required) the ID of the Flood to repeat
        flood_id = options[:flood_id]
        # grid (optional) use a specific grid UUID to launch the test in instead of a region
        grid = options[:grid]
        # region (optional) target region to launch the test in
        region = options[:region]

        params = {}
        params[:region] = region if region
        params[:grid] = grid if grid

        url = FLOOD_REPEAT_URL.gsub(':flood_id', flood_id)
        uri = URI.parse(url)
        uri.query = URI.encode_www_form(params) unless params.empty?

        context.shell "curl -X POST #{uri.to_s}"
      end
    end
  end
end

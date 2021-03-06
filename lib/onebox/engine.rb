module Onebox
  module Engine
    def self.included(object)
      object.extend(ClassMethods)
    end

    def self.engines
      constants.select do |constant|
        constant.to_s =~ /Onebox$/
      end.map(&method(:const_get))
    end

    attr_reader :url
    attr_reader :cache
    attr_reader :timeout
    attr_reader :view

    def initialize(link, cache = nil, timeout = nil)
      @url = link
      @cache = cache || Onebox.defaults.cache
      @timeout = timeout || Onebox.defaults.timeout
      @view = View.new(self.class.template_name, true)
    end

    def to_html
      view.to_html(record)
    end

    private

    def record
      if cache.key?(url)
        cache.fetch(url)
      else
        cache.store(url, data)
      end
    end

    # raises error if not defined in onebox engine
    # in each onebox, uses either Nokogiri or OpenGraph to get raw HTML from url
    def raw
      raise NoMethodError, "Engines need to implement this method"
    end

    # raises error if not defined in onebox engine
    # in each onebox, returns hash of desired onebox content
    def data
      raise NoMethodError, "Engines need this method defined"
    end

    def link
      @url
    end

    module ClassMethods
      def ===(object)
        if object.kind_of?(String)
          !!(object =~ class_variable_get(:@@matcher))
        else
          super
        end
      end

      def matches(&block)
        class_variable_set :@@matcher, Hexpress.new(&block).to_r
      end

      # calculates handlebars template name for onebox using name of engine
      def template_name
        name.split("::").last.downcase.gsub(/onebox/, "")
      end
    end
  end
end

require_relative "engine/open_graph"
require_relative "engine/html"
require_relative "engine/json"
require_relative "engine/amazon_onebox"
require_relative "engine/bliptv_onebox"
require_relative "engine/clikthrough_onebox"
require_relative "engine/college_humor_onebox"
require_relative "engine/dailymotion_onebox"
require_relative "engine/dotsub_onebox"
require_relative "engine/flickr_onebox"
require_relative "engine/funny_or_die_onebox"
require_relative "engine/github_blob_onebox"
require_relative "engine/github_commit_onebox"
require_relative "engine/github_gist_onebox"
require_relative "engine/github_pullrequest_onebox"
require_relative "engine/google_play_app_onebox"
require_relative "engine/hulu_onebox"
require_relative "engine/imgur_image_onebox"
require_relative "engine/itunes_onebox"
require_relative "engine/kinomap_onebox"
require_relative "engine/nfb_onebox"
require_relative "engine/qik_onebox"
require_relative "engine/revision3_onebox"
require_relative "engine/slideshare_onebox"
require_relative "engine/smug_mug_onebox"
require_relative "engine/sound_cloud_onebox"
require_relative "engine/spotify_onebox"
require_relative "engine/stack_exchange_onebox"
require_relative "engine/ted_onebox"
require_relative "engine/twitter_onebox"
require_relative "engine/viddler_onebox"
require_relative "engine/vimeo_onebox"
require_relative "engine/wikipedia_onebox"
require_relative "engine/yfrog_onebox"

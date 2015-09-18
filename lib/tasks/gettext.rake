begin
  require "fast_gettext"
  require "gettext_i18n_rails"
  require "gettext_i18n_rails/tasks"
  require "gettext_i18n_rails_js/tasks"
  require File.expand_path("../../../lib/foreman/gettext/support.rb", __FILE__)

  namespace :gettext do
    # redefine locale path to be taken from current directory (for plugins)
    def locale_path
      path = FastGettext.translation_repositories[text_domain].instance_variable_get(:@options)[:path] rescue nil
      path || "locale"
    end

    # redefine file globs for Foreman
    def files_to_translate
      Dir.glob("{app,lib,config,locale}/**/*.{rb,erb,haml,slim,rhtml,js,rabl}")
    end
  end

  desc 'Extract plugin strings - called via rake plugin:gettext[plugin_name]'
  task 'plugin:gettext', :engine do |t, args|
    @engine_name = args[:engine]
    @engine = "#{@engine_name.camelize}::Engine".constantize
    @engine_root = @engine.root

    namespace :gettext do
      def locale_path
        "#{@engine_root}/locale"
      end

      def files_to_translate
        Dir.glob("#{@engine.root}/{app,db,lib,config,locale}/**/*.{rb,erb,haml,slim,rhtml,js}")
      end

      def text_domain
        "#{@engine_name}"
      end
    end

    Foreman::Gettext::Support.add_text_domain @engine_name, "#{@engine_root}/locale"

    Rake::Task['gettext:find'].invoke
  end
rescue LoadError
  # gettext unavailable
  # this can happen as gettext is a development-only dependency used in
  # gettext_i18n_rails*/tasks for extraction, but not generally runtime
end

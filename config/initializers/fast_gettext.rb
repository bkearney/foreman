require 'fast_gettext'
require 'gettext_i18n_rails'

locale_dir = File.join(File.dirname(__FILE__), '..', '..', 'locale')

FastGettext.add_text_domain 'foreman', :path => locale_dir, :type => :po
FastGettext.default_available_locales = ['en','ja', 'fr'] #all you want to allow
FastGettext.default_text_domain = 'foreman'

module FastGettext
        module Translation

        alias :old_ :_

        def _(key)
            "X" + old_(key) + "X"
        end
    end
end

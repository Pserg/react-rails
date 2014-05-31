require 'execjs'
require 'react/source'
require 'react/cjsx/template'
require 'rails'

module React
  module CJSX
    def self.context
      # lazily loaded during first request and reloaded every time when in dev or test
      unless @context && ::Rails.env.production?
        contents =
          # search for transformer file using sprockets - allows user to override
          # this file in his own application
          File.read(::Rails.application.assets.resolve('CJSXTransformer.js'))

        @context = ExecJS.compile(contents)
      end

      @context
    end

    def self.transform(code)
      context.call('CJSXTransformer.transform', code)
    end
  end
end

module ActiveRecord
  class Errors
    begin
      @@default_error_messages.update( {
        :inclusion => "不在允許的範圍內。",
        :exclusion => "當前的值不允許被使用。",
        :invalid => "是不合法的。",
        :confirmation => "與確認的值不同。",
        :accepted => "必須被接受。",
        :empty => "不得留空。",
        :blank => "不得留空。",
        :too_long => "長度過長。最多只能輸入 %d 個字。",
        :too_short => "長度過短。最少要輸入 %d 個字。",
        :wrong_length => "長度不正確，應為 %d 個字。",
        :taken => "已被使用過。",
        :not_a_number => "必須為一個數字。",
      })
    end
  end
end

module ActionView #nodoc
  module Helpers
    module ActiveRecordHelper
      def error_messages_for(object_name, options = {})
        options = options.symbolize_keys
        object = instance_variable_get("@#{object_name}")
        unless !object or object.errors.empty?
          content_tag("div",
            content_tag(
              options[:header_tag] || "h2",
              "共計 #{object.errors.count} 個地方需要修正。"
            ) +
            content_tag("p", "需要修正的地方如下：") +
            content_tag("ul", object.errors.full_messages.collect {|msg|
              content_tag("li", msg)
            }),
            "id" => options[:id] || "errorExplanation", 
            "class" => options[:class] || "errorExplanation"
          )
        end
      end
    end
  end
end

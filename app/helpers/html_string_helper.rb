# module HtmlStringHelper
  class String

    def bold
      "<strong>#{self}</strong>"
    end
    alias :strong :bold

    def italic
      "<em>#{self}</em>"
    end
    alias :em :italic

  end
# end#/HtmlStringHelper

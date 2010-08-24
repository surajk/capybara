module Capybara
  class Node
    module Matchers

      ##
      #
      # Checks if a given XPath expression is on the page or current node.
      #
      #     page.has_xpath?('.//p[@id="foo"]')
      #
      # By default it will check if the expression occurs at least once,
      # but a different number can be specified.
      #
      #     page.has_xpath?('.//p[@id="foo"]', :count => 4)
      #
      # This will check if the expression occurs exactly 4 times.
      #
      # It also accepts all options that {Capybara::Node::Finders#all} accepts,
      # such as :text and :visible.
      #
      #     page.has_xpath?('.//li', :text => 'Horse', :visible => true)
      #
      # has_xpath? can also accept XPath expressions generate by the
      # XPath gem:
      #
      #     xpath = XPath.generate { |x| x.descendant(:p) }
      #     page.has_xpath?(xpath)
      #
      # @param [String] path                      An XPath expression
      # @param options                            (see Capybara::Node::Finders#all)
      # @option options [Integer] :count (nil)    Number of times the expression should occur
      # @return [Boolean]                         If the expression exists
      #
      def has_xpath?(path, options={})
        wait_conditionally_until do
          results = all(:xpath, path, options)

          if options[:count]
            results.size == options[:count]
          else
            results.size > 0
          end
        end
      rescue Capybara::TimeoutError
        return false
      end

      ##
      #
      # Checks if a given XPath expression is not on the page or current node.
      # Usage is identical to Capybara::Node::Matchers#has_xpath?
      #
      # @param (see Capybara::Node::Finders#has_xpath?)
      # @return [Boolean]
      #
      def has_no_xpath?(path, options={})
        wait_conditionally_until do
          results = all(:xpath, path, options)

          if options[:count]
            results.size != options[:count]
          else
            results.empty?
          end
        end
      rescue Capybara::TimeoutError
        return false
      end

      ##
      #
      # Checks if a given CSS selector is on the page or current node.
      #
      #     page.has_css?('p#foo')
      #
      # By default it will check if the selector occurs at least once,
      # but a different number can be specified.
      #
      #     page.has_css?('p#foo', :count => 4)
      #
      # This will check if the selector occurs exactly 4 times.
      #
      # It also accepts all options that {Capybara::Node::Finders#all} accepts,
      # such as :text and :visible.
      #
      #     page.has_css?('li', :text => 'Horse', :visible => true)
      #
      # @param [String] path                      A CSS selector
      # @param options                            (see Capybara::Node::Finders#all)
      # @option options [Integer] :count (nil)    Number of times the selector should occur
      # @return [Boolean]                         If the selector exists
      #
      def has_css?(path, options={})
        has_xpath?(XPath::HTML.from_css(path), options)
      end

      ##
      #
      # Checks if a given CSS selector is not on the page or current node.
      # Usage is identical to Capybara::Node::Matchers#has_css?
      #
      # @param (see Capybara::Node::Finders#has_css?)
      # @return [Boolean]
      #
      def has_no_css?(path, options={})
        has_no_xpath?(XPath::HTML.from_css(path), options)
      end

      ##
      #
      # Checks if the page or current node has the given text content,
      # ignoring any HTML tags and normalizing whitespace.
      #
      # @param [String] content       The text to check for
      # @return [Boolean]             Whether it exists
      #
      def has_content?(content)
        has_xpath?(XPath::HTML.content(content))
      end

      ##
      #
      # Checks if the page or current node does not have the given text
      # content, ignoring any HTML tags and normalizing whitespace.
      #
      # @param [String] content       The text to check for
      # @return [Boolean]             Whether it exists
      #
      def has_no_content?(content)
        has_no_xpath?(XPath::HTML.content(content))
      end

      ##
      #
      # Checks if the page or current node has a link with the given
      # text or id.
      #
      # @param [String] locator      The text or id of a link to check for
      # @return [Boolean]            Whether it exists
      #
      def has_link?(locator)
        has_xpath?(XPath::HTML.link(locator))
      end

      ##
      #
      # Checks if the page or current node has no link with the given
      # text or id.
      #
      # @param [String] locator      The text or id of a link to check for
      # @return [Boolean]            Whether it doesn't exist
      #
      def has_no_link?(locator)
        has_no_xpath?(XPath::HTML.link(locator))
      end

      ##
      #
      # Checks if the page or current node has a button with the given
      # text, value or id.
      #
      # @param [String] locator      The text, value or id of a button to check for
      # @return [Boolean]            Whether it exists
      #
      def has_button?(locator)
        has_xpath?(XPath::HTML.button(locator))
      end

      ##
      #
      # Checks if the page or current node has no button with the given
      # text, value or id.
      #
      # @param [String] locator      The text, value or id of a button to check for
      # @return [Boolean]            Whether it doesn't exist
      #
      def has_no_button?(locator)
        has_no_xpath?(XPath::HTML.button(locator))
      end

      ##
      #
      # Checks if the page or current node has a form field with the given
      # label, name or id.
      #
      # For text fields and other textual fields, such as textareas and
      # HTML5 email/url/etc. fields, it's possible to specify a :with
      # option to specify the text the field should contain:
      #
      #     page.has_field?('Name', :with => 'Jonas')
      #
      # @param [String] locator           The label, name or id of a field to check for
      # @option options [String] :with    The text content of the field
      # @return [Boolean]                 Whether it exists
      #
      def has_field?(locator, options={})
        has_xpath?(XPath::HTML.field(locator, options))
      end

      ##
      #
      # Checks if the page or current node has no form field with the given
      # label, name or id. See {Capybara::Node::Matchers#has_field?}.
      #
      # @param [String] locator           The label, name or id of a field to check for
      # @option options [String] :with    The text content of the field
      # @return [Boolean]                 Whether it doesn't exist
      #
      def has_no_field?(locator, options={})
        has_no_xpath?(XPath::HTML.field(locator, options))
      end

      ##
      #
      # Checks if the page or current node has a radio button or
      # checkbox with the given label, value or id, that is currently
      # checked.
      #
      # @param [String] locator           The label, name or id of a checked field
      # @return [Boolean]                 Whether it exists
      #
      def has_checked_field?(locator)
        has_xpath?(XPath::HTML.field(locator, :checked => true))
      end

      ##
      #
      # Checks if the page or current node has a radio button or
      # checkbox with the given label, value or id, that is currently
      # unchecked.
      #
      # @param [String] locator           The label, name or id of an unchecked field
      # @return [Boolean]                 Whether it exists
      #
      def has_unchecked_field?(locator)
        has_xpath?(XPath::HTML.field(locator, :unchecked => true))
      end

      ##
      #
      # Checks if the page or current node has a select field with the
      # given label, name or id.
      #
      # It can be specified which option should currently be selected:
      #
      #     page.has_select?('Language', :selected => 'German')
      #
      # For multiple select boxes, several options may be specified:
      #
      #     page.has_select?('Language', :selected => ['English', 'German'])
      #
      # It's also possible to check if a given set of options exists for
      # this select box:
      #
      #     page.has_select?('Language', :options => ['English', 'German'])
      #
      # @param [String] locator                      The label, name or id of a select box
      # @option options [Array] :options             Options which should be contained in this select box
      # @option options [String, Array] :selected    Options which should be selected
      # @return [Boolean]                            Whether it exists
      #
      def has_select?(locator, options={})
        has_xpath?(XPath::HTML.select(locator, options))
      end

      ##
      #
      # Checks if the page or current node has no select field with the
      # given label, name or id. See {Capybara::Node::Matchers#has_select?}.
      #
      # @param (see Capybara::Node::Matchers#has_select?)
      # @return [Boolean]     Whether it doesn't exist
      #
      def has_no_select?(locator, options={})
        has_no_xpath?(XPath::HTML.select(locator, options))
      end

      ##
      #
      # Checks if the page or current node has a table with the given id
      # or caption.
      #
      # If the options :rows is given, it will check that the table contains
      # the rows and columns given:
      #
      #    page.has_table?('People', :rows => [['Jonas', '24'], ['Peter', '32']])
      #
      # Note that this option is quite strict, the order needs to be correct
      # and the text needs to match exactly.
      #
      # @param [String] locator                        The id or caption of a table
      # @option options [Array[Array[String]]] :rows   A set of rows the table should contain
      # @return [Boolean]                              Whether it exist
      #
      def has_table?(locator, options={})
        has_xpath?(XPath::HTML.table(locator, options))
      end

      ##
      #
      # Checks if the page or current node has no table with the given id
      # or caption. See {Capybara::Note::Matchers#has_table?}.
      #
      # @param (see Capybara::Node::Matchers#has_table?)
      # @return [Boolean]       Whether it doesn't exist
      #
      def has_no_table?(locator, options={})
        has_no_xpath?(XPath::HTML.table(locator, options))
      end
    end
  end
end

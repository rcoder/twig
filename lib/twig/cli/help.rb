class Twig
  module Cli
    # Handles printing help output for `twig help`.
    module Help
      def self.console_width
        80
      end

      def self.intro
        version_string = "Twig v#{Twig::VERSION}"

        intro = Help.paragraph(%{
          Twig is your personal Git branch assistant. It's a command-line tool
          for listing your most recent branches, and for remembering branch
          details for you, like issue tracker ids and todos. It also supports
          subcommands, like automatically fetching statuses from your issue
          tracking system.
        })

        intro = <<-BANNER.gsub(/^[ ]+/, '')

          #{'=' * version_string.size}
          #{version_string}
          #{'=' * version_string.size}

          #{intro}

          #{Twig::HOMEPAGE}
        BANNER

        intro + ' ' # Force extra blank line
      end

      def self.description(text, options = {})
        defaults = {
          :add_blank_line => false,
          :width => 40
        }
        options = defaults.merge(options)

        width = options[:width]
        words = text.gsub(/\n?\s+/, ' ').strip.split(' ')
        lines = []

        # Split words into lines
        while words.any?
          current_word      = words.shift
          current_word_size = Display.unformat_string(current_word).size
          last_line         = lines.last
          last_line_size    = last_line && Display.unformat_string(last_line).size

          if last_line_size && (last_line_size + current_word_size + 1 <= width)
            last_line << ' ' << current_word
          elsif current_word_size >= width
            lines << current_word[0...width]
            words.unshift(current_word[width..-1])
          else
            lines << current_word
          end
        end

        lines << ' ' if options[:add_blank_line]
        lines
      end

      def self.description_for_custom_property(option_parser, desc_lines, options = {})
        options[:trailing] ||= "\n"
        indent = '      '
        left_column_width = 29

        help_desc = desc_lines.inject('') do |desc, (left_column, right_column)|
          desc + indent +
          sprintf("%-#{left_column_width}s", left_column) + right_column + "\n"
        end

        Help.print_section(option_parser, help_desc, :trailing => options[:trailing])
      end

      def self.line_for_custom_property?(line)
        is_custom_property_except = (
          line.include?('--except-') &&
          !line.include?('--except-branch') &&
          !line.include?('--except-property') &&
          !line.include?('--except-PROPERTY')
        )
        is_custom_property_only = (
          line.include?('--only-') &&
          !line.include?('--only-branch') &&
          !line.include?('--only-property') &&
          !line.include?('--only-PROPERTY')
        )
        is_custom_property_width = (
          line =~ /--.+-width/ &&
          !line.include?('--branch-width') &&
          !line.include?('--PROPERTY-width')
        )

        is_custom_property_except ||
        is_custom_property_only ||
        is_custom_property_width
      end

      def self.paragraph(text)
        Help.description(text, :width => console_width).join("\n")
      end

      def self.print_line(option_parser, text)
        # Prints a single line of text without line breaks.
        option_parser.separator(text)
      end

      def self.print_paragraph(option_parser, text, separator_options = {})
        # Prints a long chunk of text with automatic word wrapping and a leading
        # line break.

        separator_options[:trailing] ||= ''
        Help.print_section(option_parser, Help.paragraph(text), separator_options)
      end

      def self.print_section(option_parser, text, options = {})
        # Prints text with leading and trailing line breaks.

        options[:trailing] ||= ''
        option_parser.separator "\n#{text}#{options[:trailing]}"
      end

      def self.subcommand_descriptions
        descs = {
          'checkout-child'  => 'Checks out a branch\'s child branch, if any.',
          'checkout-parent' => 'Checks out a branch\'s parent branch.',
          'create-branch'   => 'Creates a branch and sets its `diff-branch` property to the previous branch name.',
          'diff'            => 'Shows the diff between a branch and its parent branch (`diff-branch`).',
          'gh-open'         => 'Opens a browser window for the current GitHub repository.',
          'gh-open-issue'   => 'Opens a browser window for a branch\'s GitHub issue, if any.',
          'gh-update'       => 'Updates each branch with the latest issue status on GitHub.',
          'help'            => 'Provides help for Twig and its subcommands.',
          'init'            => 'Runs all Twig setup commands.',
          'init-completion' => 'Initializes tab completion for Twig. Runs as part of `twig init`.',
          'init-config'     => 'Creates a default `~/.twigconfig` file. Runs as part of `twig init`.',
          'rebase'          => 'Rebases a branch onto its parent branch (`diff-branch`).'
        }

        line_prefix    = '- '
        gutter_width   = 2 # Space between columns
        names          = descs.keys.sort
        max_name_width = names.map { |name| name.length }.max
        names_width    = max_name_width + gutter_width
        descs_width    = Help.console_width - line_prefix.length - names_width
        desc_indent    = ' ' * (names_width + line_prefix.length)

        names.map do |name|
          line_prefix +
          sprintf("%-#{names_width}s", name) +
          Help.description(descs[name], :width => descs_width).join("\n" + desc_indent)
        end
      end

      def self.header(option_parser, text, separator_options = {}, header_options = {})
        separator_options[:trailing] ||= "\n\n"
        header_options[:underline]   ||= '='

        Help.print_section(
          option_parser,
          text + "\n" + (header_options[:underline] * text.size),
          separator_options
        )
      end

      def self.subheader(option_parser, text, separator_options = {})
        header(option_parser, text, separator_options, :underline => '-')
      end
    end
  end
end

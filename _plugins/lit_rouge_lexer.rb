require 'rouge'

class LitLexer < Rouge::RegexLexer
  title 'Lit'
  desc "The Lit programming language (lit-lang.org)"
  tag 'lit'
  filenames '*.lit'
  mimetypes 'text/x-lit', 'application/x-lit'


  def self.detect?(text)
    return true if text.shebang? 'lit'
  end

  def self.keywords
    @keywords ||= Set.new %w[let var if else elsif do then while until loop return match break next and or fn type variant module new try]
  end

  state :root do
    decimal = %r/[\d]+(?:_\d+)*/
    exp = %r/e[+-]?\d+/i
    rule %r/#{decimal}(?:\.#{decimal}#{exp}?|#{exp})/, Num::Float
    rule decimal, Num::Integer

    # TODO: handle ! and ? on identifiers

    rule %r/\b(type)(\s+)(\w+)(\s*)({)/ do
      groups Keyword::Declaration, Text::Whitespace, Name::Class, Text::Whitespace, Punctuation
    end

    rule %r/\s+/, Text::Whitespace
    rule %r/"/, Literal::String::Double, :double_q_string
    rule %r/'.*'/, Literal::String::Single
    rule %r/:\w+/, Literal::String::Symbol
    rule %r/\w+:/, Literal::String::Symbol

    rule %r/#=/, Comment::Multiline, :multiline_comment
    rule %r/#.*$/, Comment::Single

    rule %r/\b(true|false|nil)\b/, Keyword::Pseudo

    rule %r/\b(print|println|open|typeof|readln|error|self|it|its)\b/, Name::Builtin

    rule %r/\+|\-|\*|\/|%|=|==|!=|<|>|<=|>=|\|>/, Operator
    rule %r/[\(\)\{\}\[\],;]/, Punctuation

    rule %r/\bfn\b/, Keyword::Declaration, :function_def
    rule %r/\w+\s*(?=\()/ do |m|
      token Name::Function
    end

    rule %r/\w+/ do |m|
      if self.class.keywords.include?(m[0])
        token Keyword
      else
        token Name
      end
    end
  end

  state :double_q_string do
    rule %r/[{]/, Str::Interpol, :string_interpolation
    # TODO:  Escape sequences

    rule %r/[^\\"{]+/m, Literal::String::Double
    rule %r/[\\{]/, Literal::String::Double
    rule %r/"/, Literal::String::Double, :pop!
  end

  state :single_q_string do
    rule %r/'/, Str::Single, :pop!
  end

  state :multiline_comment do
    rule %r/#=/, Comment::Multiline, :multiline_comment
    rule %r/[^#=]+/, Comment::Multiline
    rule %r/=#/, Comment::Multiline, :pop!
  end

  state :string_interpolation do
    rule %r/}/, Str::Interpol, :pop!
    mixin :root
  end

  state :function_def do
    rule %r/\s+/, Text::Whitespace
    rule %r/\bdo\b/ do
      token Keyword
      pop!
    end
    rule %r/\w/, Name::Function
    rule %r/(\{)/ do
      token Punctuation
      pop!
    end
  end
end

module Halunke
  class SourceCodePosition
    def initialize(ts, te)
      @ts = ts
      @te = te
    end

    def reveal(source, error_mode)
      ts = @ts
      te = @te
      ellipsis = false

      line, line_number = source.lines.each_with_index.find do |candidate, _line_number|
        if ts < candidate.length
          (te = candidate.length - 2) && (ellipsis = true) if te > candidate.length
          true
        else
          ts -= candidate.length
          te -= candidate.length
          false
        end
      end

      prefix = error_mode == :repl ? ">> " : "#{line_number + 1} | "

      output = []
      output << "#{prefix}#{line.rstrip}#{ellipsis ? '...' : ''}\n" if error_mode == :file
      output << " " * (ts + prefix.length) + "^" * (te - ts + 1) + "\n\n"
      output
    end
  end

  class NullSourceCodePosition
    def initialize
    end

    def reveal(source, error_mode)
      "(Can't find the source code position, sorry)"
    end
  end
end

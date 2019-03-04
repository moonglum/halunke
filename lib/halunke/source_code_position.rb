module Halunke
  class SourceCodePosition
    def initialize(ts, te)
      @ts = ts
      @te = te
    end

    def reveal(source, error_mode)
      line, line_number = source.lines.each_with_index do |candidate, candidate_line_number|
        break candidate, candidate_line_number if @ts < candidate.length

        @ts -= candidate.length
        @te -= candidate.length
      end

      if @te > line.length
        @te = line.length - 2
        ellipsis = '...'
      end

      prefix = error_mode == :repl ? ">> " : "#{line_number + 1} | "

      output = []
      output << [prefix, line.rstrip, ellipsis].join("") if error_mode == :file
      output << " " * (@ts + prefix.length) + "^" * (@te - @ts + 1)
      output << "\n"

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

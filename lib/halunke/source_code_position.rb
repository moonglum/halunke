module Halunke
  class SourceCodePosition
    def initialize(ts, te)
      @ts = ts
      @te = te
    end
  end

  class NullSourceCodePosition
    def initialize
    end
  end
end

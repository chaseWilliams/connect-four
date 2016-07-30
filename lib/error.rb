module GameErrors
  class BadMethodError < NameError
    def to_s
      'Given method does not exist' + backtrace.join("\n")
    end
  end

  class BadParam < RuntimeError
    def to_s
      'Given params were nil' + backtrace.join("\n")
    end
  end
end


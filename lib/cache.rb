module Cache
  class << self
    def self.save data
      File.write 'tmp.json', data.to_json
    end

    def self.current
      File.read 'tmp.json'
    end
  end
end
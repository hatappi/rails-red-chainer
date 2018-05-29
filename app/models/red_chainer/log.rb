module RedChainer
  class Log < Struct.new(:epoch, :iteration, :main_loss, :main_accuracy, :elapsed_time)
    def self.parse(row)
      self.new(row['epoch'],
               row['iteration'],
               row['main/loss'],
               row['main/accuracy'],
               row['elapsed_time'])
    end

    def self.load_from_log(file_path)
      h = File.open(file_path) do |j|
  			JSON.load(j)
      end
      h.map { |row| parse(row) }
    end
  end
end

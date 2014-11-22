require 'serialport'

module Lita
  module Handlers
    class Suddenly < Handler
      route /^temp$/, :suddenly_death

      def suddenly_death(response)
        sp = SerialPort.new('/dev/tty.usbmodem1.1', 9600, 8, 1, 0) 
        sp.puts "1"
        line = sp.gets # read
        response.reply line
      end
    end
    Lita.register_handler(Suddenly)
  end
end

require 'serialport'

module Lita
  module Handlers
    class Suddenly < Handler
      route /^temp$/, :temparature
      route /^start temp$/, :reminder
      route /^light status$/, :light_status
      route /^light on$/, :light_on
      route /^light off$/, :light_off

      def temparature(response)
        sp = SerialPort.new('/dev/tty.usbmodem1.1', 9600, 8, 1, 0) 
        sp.puts "t"
        line = sp.gets # read
        response.reply line
      end

      def light_status(response)
        sp = SerialPort.new('/dev/tty.usbmodem1.1', 9600, 8, 1, 0) 
        sp.puts "l"
        line = sp.gets # read
        response.reply line
      end

      def light_on(response)
        sp = SerialPort.new('/dev/tty.usbmodem1.1', 9600, 8, 1, 0) 
        sp.puts "1"
        response.reply "light on"
      end

      def light_off(response)
        sp = SerialPort.new('/dev/tty.usbmodem1.1', 9600, 8, 1, 0) 
        sp.puts "0"
        response.reply "light off"
      end

      def reminder(response)
        every(10) do |timer|
          sp = SerialPort.new('/dev/tty.usbmodem1.1', 9600, 8, 1, 0) 
          sp.puts "t"
          line = sp.gets # read
          response.reply line + "by timer"
        end
      end
    end
    Lita.register_handler(Suddenly)
  end
end

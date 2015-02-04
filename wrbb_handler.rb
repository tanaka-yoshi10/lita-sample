require 'serialport'

module Lita
  module Handlers
    class WrbbHandler < Handler
      DEVICE = '/dev/ttyACM0'
      route /^temp$/, :temparature
      route /^start temp$/, :reminder
      route /^light status$/, :light_status
      route /^light on$/, :light_on
      route /^light off$/, :light_off
      route /^tap on$/, :tap_on
      route /^tap off$/, :tap_off

      def openWrbb
        sp = SerialPort.new(DEVICE, 9600, 8, 1, 0) 
        yield sp
      end

      def temparature(response)
        line = openWrbb do |sp|
          sp.puts "t"
          sp.gets
        end
        response.reply line
      end

      def light_status(response)
        line = openWrbb do |sp|
          sp.puts "l"
          sp.gets
        end
        response.reply line
      end

      def light_on(response)
        openWrbb {|sp| sp.puts "1"}
        response.reply "light on"
      end

      def light_off(response)
        openWrbb {|sp| sp.puts "0"}
        response.reply "light off"
      end

      def tap_on(response)
        openWrbb {|sp| sp.puts "w1,97,26,26,8,8,8,8,8,18,8,18,8,18,8,18,8,8,8,8,8,30,26,26,8,8,8,8,8,18,8,18,8,18,8,18,8,8,8,8,8,28,26,26,9,8,8,8,8,18,8,18,8,18,8,18,8,8,8,8,8,0W"}
        response.reply "tap on"
      end

      def tap_off(response)
        openWrbb {|sp| sp.puts "w26,26,8,8,8,18,8,8,8,8,8,18,8,8,8,18,8,18,8,30,26,26,8,8,8,18,8,8,8,8,8,18,8,8,8,18,8,18,8,28,26,26,8,8,8,18,8,8,8,8,8,18,8,8,8,18,8,18,8,28,26,26,8,8,8,18,8,8,8,8,8,18,8,8,8,18,8,18,8,111,1,172,26,26,8,8,8,18,8,8,8,8,8,18,8,8,8,18,8,18,8,28,26,26,8,8,8,18,8,8,8,8,8,18,8,8,8,18,8,18,8,0W"}
        response.reply "tap off"
      end

      def reminder(response)
        every(10) do |timer|
          line = openWrbb do |sp|
            sp.puts "t"
            sp.gets
          end
          response.reply line + "by timer"
        end
      end
    end
    Lita.register_handler(WrbbHandler)
  end
end

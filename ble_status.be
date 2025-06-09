# This code adds a status line on the right top of the web interface
# to indicate the BLE support of the device.
# It checks if the device supports BLE and displays the status accordingly.
# The status can be "MI32", "BLE", or "None".
# The code is designed to be used with Tasmota firmware > 14.6.0.2
# Created by @Flobul on 2025-09-06
# Modified by @Flobul on 2025-09-06
# Version 0.1.0

class BleStatus : Driver
    var ble_status
    
    def init()
        self.ble_status = self.check_ble_support()
    end

    def check_ble_support()
        try
            try
                import MI32
                MI32.devices()
                return "MI32"
            except .. 
                var status = tasmota.cmd("Status 4", true)
                if status != nil && status.contains("StatusMEM")
                    var features = status["StatusMEM"]["Features"]
                    if size(features) >= 10 && features[9][0] == '4'
                        return "BLE"
                    end
                end
            end
        except .. as e
            print("Error:", e)
        end
        return "None"
    end

    def web_status_line_right()
        import webserver
        webserver.content_send(format(
            '<span style="margin:2px;cursor:default;padding:1px 2px;border-radius:5px;border-style:solid;border-width:1px">%s</span>',
            self.ble_status == "None" ? "No BLE" : self.ble_status
        ))
    end
end

ble_status = BleStatus()
tasmota.add_driver(ble_status)
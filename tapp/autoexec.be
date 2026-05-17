# rm BLE_Status.tapp; zip -j -0 BLE_Status.tapp tapp/autoexec.be tapp/ble_status.be tapp/manifest.json
do
  import introspect
  var ble_status = introspect.module('ble_status', true)
  tasmota.add_extension(ble_status)
end

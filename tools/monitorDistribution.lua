bigChance1 = 0
bigChance2 = 0
bigChance3 = 0
total = 0

function printInfo()
   emu.drawString(12, 12, "1: " .. string.format("%.2f", bigChance1 / total))
   emu.drawString(12, 21, "2: " .. string.format("%.2f", bigChance2 / total))
   emu.drawString(12, 30, "3: " .. string.format("%.2f", bigChance3 / total))
end

function incrementInfo()
  total = total+1
  chance = emu.read(0x35, emu.memType.nesMemory, false)
  if chance < 0x30 then
     bigChance1 = bigChance1+1
  end
  if chance < 0x70 then
     bigChance2 = bigChance2+1
  end
  if chance < 0xb0 then
     bigChance3 = bigChance3+1
  end
  printInfo()
end

emu.addMemoryCallback(incrementInfo, emu.callbackType.exec, 0xDE01)
emu.addEventCallback(printInfo, emu.eventType.endFrame);

--Display a startup message
emu.displayMessage("Script", "Monitoring big chances")
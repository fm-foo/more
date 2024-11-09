-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore v0.60 register "pooladd"
function onInit()
  CustomDiceManager.add_roll_type("pooladd", performAction, onLanded, true, "all");
end

function performAction(draginfo, rActor, sParams)
  local sDice, sDesc = string.match(sParams, "([^%s]+)%s*(.*)");
  local aDice, nMod = StringManager.convertStringToDice(sDice);
    DicePool.addSlotAsDice(sDesc, aDice);
	local rMessage = ChatManager.createBaseMessage(nil, nil);
	rMessage.text = rMessage.text .. "Dice added to the pool: " .. sDesc; 
	Comm.deliverChatMessage(rMessage);
	
end


function onLanded(rSource, rTarget, rRoll)
end


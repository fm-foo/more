-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "chatimage";

-- MoreCore v0.60 
function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
end

function performAction(draginfo, rActor, sParams)
Debug.console("performAction: ", draginfo, rActor, sParams);
							
							local chattoken = sParams;
							local chattoken = (chattoken:gsub(' ', ''));
							local msg = {font = "msgfont", icon = chattoken};
							Comm.deliverChatMessage(msg);
  end   




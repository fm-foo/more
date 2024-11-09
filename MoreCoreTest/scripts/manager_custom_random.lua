-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "rngroll";

-- MoreCore v0.60 
function onInit()
  aStats = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  sResults = nil;
  math.randomseed(os.time());
   CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
 
end

function performAction(draginfo, rActor, sParams)
--Debug.console("performAction: ", draginfo, rActor, sParams);

  if sParams == "?" or string.lower(sParams) == "help" then
    createHelpMessage();    
  else
    local rRoll = createRoll(sParams);
	local sDice, sNum, sDesc = string.match(sParams, "(d%d+)x(%d+)%s*(.*)");
	rRoll.sDice = sDice;
	rRoll.sDesc = sDesc;
	rRoll.sNum = sNum;
--	Debug.chat("performAction: rRoll ", rRoll, sParams, sDice);
    ActionsManager.performAction(draginfo, rActor, rRoll);
  end   

end



function onLanded(rSource, rTarget, rRoll)
-- Debug.chat("onLanded: ", rSource, rTarget, rRoll);

	for k,v in ipairs(rRoll.aDice) do

		if rRoll.aDice[k].result == 1 then
		CustomDiceRNGRoll.aStats[1] = CustomDiceRNGRoll.aStats[1]+1;
		elseif rRoll.aDice[k].result == 2 then
		CustomDiceRNGRoll.aStats[2] = CustomDiceRNGRoll.aStats[2]+1;
		elseif rRoll.aDice[k].result == 3 then
		CustomDiceRNGRoll.aStats[3] = CustomDiceRNGRoll.aStats[3]+1;
		elseif rRoll.aDice[k].result == 4 then
		CustomDiceRNGRoll.aStats[4] = CustomDiceRNGRoll.aStats[4]+1;
		elseif rRoll.aDice[k].result == 5 then
		CustomDiceRNGRoll.aStats[5] = CustomDiceRNGRoll.aStats[5]+1;
		elseif rRoll.aDice[k].result == 6 then
		CustomDiceRNGRoll.aStats[6] = CustomDiceRNGRoll.aStats[6]+1;
		elseif rRoll.aDice[k].result == 7 then
		CustomDiceRNGRoll.aStats[7] = CustomDiceRNGRoll.aStats[7]+1;
		elseif rRoll.aDice[k].result == 8 then
		CustomDiceRNGRoll.aStats[8] = CustomDiceRNGRoll.aStats[8]+1;
		elseif rRoll.aDice[k].result == 9 then
		CustomDiceRNGRoll.aStats[9] = CustomDiceRNGRoll.aStats[9]+1;
		elseif rRoll.aDice[k].result == 10 then
		CustomDiceRNGRoll.aStats[10] = CustomDiceRNGRoll.aStats[10]+1;
		elseif rRoll.aDice[k].result == 11 then
		CustomDiceRNGRoll.aStats[11] = CustomDiceRNGRoll.aStats[11]+1;
		elseif rRoll.aDice[k].result == 12 then
		CustomDiceRNGRoll.aStats[12] = CustomDiceRNGRoll.aStats[12]+1;
		elseif rRoll.aDice[k].result == 13 then
		CustomDiceRNGRoll.aStats[13] = CustomDiceRNGRoll.aStats[13]+1;
		elseif rRoll.aDice[k].result == 14 then
		CustomDiceRNGRoll.aStats[14] = CustomDiceRNGRoll.aStats[14]+1;
		elseif rRoll.aDice[k].result == 15 then
		CustomDiceRNGRoll.aStats[15] = CustomDiceRNGRoll.aStats[15]+1;
		elseif rRoll.aDice[k].result == 16 then
		CustomDiceRNGRoll.aStats[16] = CustomDiceRNGRoll.aStats[16]+1;
		elseif rRoll.aDice[k].result == 17 then
		CustomDiceRNGRoll.aStats[17] = CustomDiceRNGRoll.aStats[17]+1;
		elseif rRoll.aDice[k].result == 18 then
		CustomDiceRNGRoll.aStats[18] = CustomDiceRNGRoll.aStats[18]+1;
		elseif rRoll.aDice[k].result == 19 then
		CustomDiceRNGRoll.aStats[19] = CustomDiceRNGRoll.aStats[19]+1;
		elseif rRoll.aDice[k].result == 20 then
		CustomDiceRNGRoll.aStats[20] = CustomDiceRNGRoll.aStats[20]+1;
		end
		CustomDiceRNGRoll.aStats[21] = CustomDiceRNGRoll.aStats[21]+1;
	end
	

  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  rMessage = createChatMessage(rSource, rRoll);
  rMessage.type = "dice";
  Comm.deliverChatMessage(rMessage);
end


---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sParams)
  local rRoll = { };
  Debug.chat("sParams: ", sParams);
	local sDice, sNum, sDesc = string.match(sParams, "(d%d+)x(%d+)%s*(.*)");
	rRoll.sNum = sNum;
	if sDice then 
		rRoll.aDice = {sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice, sDice};
	end
  rRoll.sType = sCmd;
  rRoll.nMod = 0;
  rRoll.sDesc = sDesc;
  rRoll.nTarget = 0;
--- rRoll.sUser = User.getUsername();

 
  local nStart, nEnd, sTarget, sDescriptionParam = string.find(sParams, "([%d]+)%s*(.*)");
--Debug.console("createRoll: ",nStart, nEnd, sTarget, sDescriptionParam);
--Debug.console("createRoll: ",rRoll);
 
  return rRoll;
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
 
    rMessage.dicedisplay = 0; -- display total
    local nVal = rRoll.aDice.result;
	

for k, v in ipairs(CustomDiceRNGRoll.aStats) do
	if v > 0 and k < 21 then 
	--	Debug.chat(k,v, math.floor(v/CustomDiceRNGRoll.aStats[21]*100) .. "%");
		rMessage.text = rMessage.text .. "\n#" .. k .. " Rolled: " .. v .. " Occurrence: " .. math.floor(v/CustomDiceRNGRoll.aStats[21]*100) .. "%"
	end
end

	if sResults then 
		sResults = sResults .. ", " .. rRoll.aDice[1].result .. ", " .. rRoll.aDice[2].result .. ", " .. rRoll.aDice[3].result .. ", " .. rRoll.aDice[4].result .. ", " .. rRoll.aDice[5].result .. ", " .. rRoll.aDice[6].result .. ", " .. rRoll.aDice[7].result .. ", " .. rRoll.aDice[8].result .. ", " .. rRoll.aDice[9].result .. ", " .. rRoll.aDice[10].result .. ", " .. rRoll.aDice[11].result .. ", " .. rRoll.aDice[12].result .. ", " .. rRoll.aDice[13].result .. ", " .. rRoll.aDice[14].result .. ", " .. rRoll.aDice[15].result .. ", " .. rRoll.aDice[16].result .. ", " .. rRoll.aDice[17].result .. ", " .. rRoll.aDice[18].result .. ", " .. rRoll.aDice[19].result .. ", " .. rRoll.aDice[20].result;
	else sResults = rRoll.aDice[1].result .. ", " .. rRoll.aDice[2].result .. ", " .. rRoll.aDice[3].result .. ", " .. rRoll.aDice[4].result .. ", " .. rRoll.aDice[5].result .. ", " .. rRoll.aDice[6].result .. ", " .. rRoll.aDice[7].result .. ", " .. rRoll.aDice[8].result .. ", " .. rRoll.aDice[9].result .. ", " .. rRoll.aDice[10].result .. ", " .. rRoll.aDice[11].result .. ", " .. rRoll.aDice[12].result .. ", " .. rRoll.aDice[13].result .. ", " .. rRoll.aDice[14].result .. ", " .. rRoll.aDice[15].result .. ", " .. rRoll.aDice[16].result .. ", " .. rRoll.aDice[17].result .. ", " .. rRoll.aDice[18].result .. ", " .. rRoll.aDice[19].result .. ", " .. rRoll.aDice[20].result;
	end
	
	if CustomDiceRNGRoll.aStats[21] < tonumber(rRoll.sNum) then
		Debug.chat("Roll Again!");
		Comm.activateSlashCommand("rngroll", rRoll.sDice .. "x" .. tonumber(rRoll.sNum));
		else
		Debug.chat("Stop Rolling!");
	--	Debug.chat("sResults", sResults);
		
		
		
		nTotal = 0;
			for k, v in ipairs(CustomDiceRNGRoll.aStats) do
				if k < 21 then
					nTotal = (k*v) + nTotal;
				end
			end
					-- Debug.chat("Rolls: ", CustomDiceRNGRoll.aStats[21], " Total: ", nTotal, " Average: ", nTotal/CustomDiceRNGRoll.aStats[21], "\nActual Rolls: ", sResults);
					rMessage.text=rMessage.text .. "\nTotal Number of Rolls: " .. CustomDiceRNGRoll.aStats[21] .. "\nSum of all Rolls: " .. nTotal .. "\nAverage of all Rolls: " .. nTotal/CustomDiceRNGRoll.aStats[21] .. "\nActual Rolls in Order:\n" .. sResults;
			  aStats = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
			  sResults = nil;
		end
	
 
  return rMessage;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()  
  local rMessage = ChatManager.createBaseMessage(nil, nil);
  rMessage.text = rMessage.text .. "Usage: /"..sCmd.." <target> <message>\n"; 
  rMessage.text = rMessage.text .. "The \"/"..sCmd.."\" command is used to roll 3d10, ordering the results as m, C & M. "; 
  rMessage.text = rMessage.text .. "C accepts modifiers from the Modifier box. An optional target number can be provided which will be compared to C. A double or triple 1 is a fumble and a double or triple 10 is a critical success. "; 
  rMessage.text = rMessage.text .. "The result, along with a message is output to the chat window."; 
  Comm.deliverChatMessage(rMessage);
end

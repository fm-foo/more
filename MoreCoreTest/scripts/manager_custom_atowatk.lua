-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "atkatow";

OOB_MSGTYPE_UPDATENODE = "updatenode";

nMarginOfSuccess = 0;
nDiceExplode = 0;

-- MoreCore v0.60 
function onInit()
--  Debug.console("10:onInit");
--  OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYHRFC, handleApplyHRFC);
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
  OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_UPDATENODE, handleUpdateNode);
  
end

function handleUpdateNode(msgOOB)
  local sAttackMoS = msgOOB.sAttackMoS;
  local nMOS = msgOOB.nMOS;

  Debug.console("handleUpdateNode", sAttackMoS, nMOS);

  applyNodeUpdate(sAttackMoS, nMOS);
end

function applyNodeUpdate (sAttackMoS, nMOS)
--	Use Five field in CT Node to hold MoS
	DB.getChild(sAttackMoS,"five").setValue(nMOS);
	local nMarginOfSuccess = DB.getChild(sAttackMoS,"five").getValue();
	Debug.console("MoS: ",nMarginOfSuccess);
end

function performAction(draginfo, rActor, sParams)
--  Debug.console("16:performAction");
  local sDice, sOp, sSave, sDesc = sParams:match("([^%s]+)([<>])(%d+)%s*(.*)")
	Debug.console("performAction: ", rActor);
--  Debug.console("17:performAction");
--  local sDice, sDesc = string.match(sParams, "([^%s]+)%s*(.*)");
--  Debug.console("19:performAction");
  if sDice == nil or not StringManager.isDiceString(sDice) then
--  Debug.console("21:performAction");
    ChatManager.SystemMessage("Usage: /"..sCmd.." [dice+modifier] [description]");
    return;
  else
    local rRoll = createRoll(sDice, sDesc);
	rRoll.sOp = sOp;
	rRoll.sSave = tonumber(sSave);
--	Debug.chat("sOp: ", sOp, " sSave: ", sSave);
--  Debug.console("26:performAction");
--	Debug.console("performAction: rRoll ", rRoll);
    ActionsManager.performAction(draginfo, rActor, rRoll);
  end 

	
	
end

function getDieMax(sType)
--  Debug.console("31:getDieMax");
--	Debug.console("getDieMax: ", sType);
  local sDie = string.match(sType, "d(%d+)");
	tempmax = tonumber(sDie)  max = tempmax;
  return max;  
end

function initLastDice(aDice)
--  Debug.console("39:initLastDice");
  aSavedDice = {};
  for i , v in ipairs (aDice) do
    aSavedDice[i] = { type=v.type, result=0, exploded=true };
  end
  return aSavedDice;
end

function onLanded(rSource, rTarget, rRoll)
  Debug.console("onLanded: ", rSource, rTarget, rRoll);
--  Debug.console("49:onLanded");

--  Global values to aid exploding dice functionality

  if nDiceExplode == 0 then	
	rSourceReal = rSource;
	rTargetReal = rTarget;
	Debug.console("Source: ",rSourceReal);
	Debug.console("Target: ",rTargetReal);
  end
  
  local sAttackMoS = rSourceReal.sCTNode;
 
 
  local nTotal;
  local nHit = 0;

  if rSourceReal ~= nil and rTargetReal ~= nil then
	nEffectRollMod = EffectManager.CombatEffectsModifier(rSourceReal, rTargetReal);
	Debug.console("Effect Function Mod = ",nEffectRollMod);
  end

 
  if nTotal == nil then nTotal = rRoll.nMod; end
  
  local aDice = rRoll.aDice;

  -- get sSaved dice
  local aSavedDice = nil;
  Debug.console("aSavedDice: ",rRoll.aSavedDice);
  if rRoll.aSavedDice then
    aSavedDice = Json.parse(rRoll.aSavedDice);
  else
    aSavedDice = initLastDice(aDice);
  end

  local aRerollDice = {};
  local j = 1; -- reRoll dice index
  local k = 1; -- aDice index

  for i , v in ipairs (aSavedDice) do
--    Debug.console("onLanded: last dice ", i, v);
 	nTotal = nTotal + v.result;
   if v.exploded then
      w = aDice[k]; 
      k = k + 1; -- move on to next die for next time around
      v.result = v.result + w.result;
      if w.result == getDieMax(w.type) and aDice[1].result == 6 then
        aRerollDice[j] = w.type;
        j = j + 1;
        v.exploded = true;
      else
        v.exploded = false;
      end
    end
  end

    for _,v in ipairs(rRoll.aDice) do
	nTotal = nTotal + v.result;
	end
	
  rRoll.aSavedDice = Json.stringify(aSavedDice);

-- Debug.console("aRerollDice: ",#aRerollDice, aRerollDice);
  if #aRerollDice > 0 then
    rRoll.aDice = aRerollDice;
	Debug.console("ReRoll: ",rRoll.aDice);
--	if #aRerollDice == 1 then
--		rReRollSource = rSource;
--		rReRollTarget = rTarget;
--	end
    ActionsManager.performAction(draginfo, rActor, rRoll);
	nDiceExplode = nDiceExplode + 1;
    return;
  else
    rRoll.aDice = aSavedDice;
  end

--  if rSource ~= nil then
--	rSource = rSource;
-- elseif rReRollSource ~= nil then
--	rSource = rReRollSource;
--  end

  local rMessage = ActionsManager.createActionMessage(rSourceReal, rRoll);

--	Debug.chat("nTotal: ", nTotal);
--  Debug.chat("rRoll.sOp: ", rRoll.sOp);
--	Debug.chat("rRoll.sSave: ", rRoll.sSave);

 	Debug.console("rRoll.aOp: ", rRoll.aOp);

	Debug.console("rRoll.nMod 1a: ", rRoll.nMod);

	Debug.console("Dice 1: ", rRoll.aDice[1]);
	Debug.console("Dice 2: ", rRoll.aDice[2]);
	Debug.console("nTotal: ", nTotal);

	
--	local nAddMod = 0;
--	local nEffectMod = 0;
--	local sAddMod = "";
--	local sAttackNodeEffect = rSource.sCTNode;
	
--	Debug.console("rSource = ",rSource);
--	Debug.console("rTarget = ",rTarget);
--	Debug.console("Node = ",sAttackNodeEffect);

--	INITIAL EFFECT TEST

--	local sEffects = DB.getChild(sAttackNodeEffect,"effects");
--	Debug.console("Node Label = ",sEffects);
	

--	ADDITIONAL EFFECT TEST

--	for k, v in pairs(sEffects.getChildren()) do
--	for _,v in pairs(DB.getChildren(SNodeEffect, "effects")) do
--		local sLabel = DB.getValue(v,"label");
--		Debug.console("Effect Label = ",sLabel);
--		if string.match(sLabel,"ATK") then
--			sAddMod = string.sub(sLabel, -2, -1);
--			Debug.console("Attack modifier = ", sAddMod);
--			nAddMod = nAddMod + sAddMod;
--			Debug.console("modifier-effect = ",nAddMod);
--		end
--	end

--	nAddMod = nAddMod + sAddMod;
	rRoll.nMod = rRoll.nMod + nEffectRollMod;
	nTotal = nTotal + nEffectRollMod;
	nHit = nTotal - rRoll.nMod;
	local nMOS = nTotal - tonumber(rRoll.sSave);
	
	
	-- Store Margin Of Success value for later use

    local msgOOB = {};
    msgOOB.type = OOB_MSGTYPE_UPDATENODE;
  
    msgOOB.nMOS = nMOS;
    msgOOB.sAttackMoS = sAttackMoS;

    Comm.deliverOOBMessage(msgOOB, "");
    
	if nHit == 2 then
		Debug.console("Dice: ", nHit);
		sSaveResult = "Fumble";
	elseif nHit > 12 then
		Debug.console("Dice: ", nHit);
		sSaveResult = "Critical Hit";
		sMOS = tostring(nMOS); 
	elseif nTotal < tonumber(rRoll.sSave) then
		Debug.console("Failed: ", nTotal);
		sSaveResult = "Missed";
	elseif nTotal >= tonumber(rRoll.sSave) then
		Debug.console("Success: ", nTotal);
		sSaveResult = "Hit";
		sMOS = tostring(nMOS); 
	end
	
--	Debug.console("sSaveResult: ", sSaveResult);
--	Debug.console("rTarget: ", rTarget);

--	if rTargetReal ~= nil then
		sSaveResult = sSaveResult .. "\nMargin of Success = " .. nMOS .. "\nvs "..rTargetReal.sName;
--	elseif rReRollTarget ~= nil then
--		sSaveResult = sSaveResult .. "\nMargin of Success = " .. nMOS .. "\nvs "..rReRollTarget.sName;
--	end

--	CRIT/FUMBLE ADDITON

-- HANDLE FUMBLE/CRIT HOUSE RULES
--	local sOptionHRFC = OptionsManager.getOption("HRFC");
--	if sSaveResult == "Fumble" and ((sOptionHRFC == "both") or (sOptionHRFC == "fumble")) then
	if nHit == 2 then
--		notifyApplyHRFC("Fumble");
		TableManager.processTableRoll("", "Fumble");
	end
--	if sSaveResult == "Critical Hit" and ((sOptionHRFC == "both") or (sOptionHRFC == "criticalhit")) then
	if nHit > 12 then
--		notifyApplyHRFC("Critical Hit");
		TableManager.processTableRoll("", "Critical Hit");
	end


--[[	if nTotal < tonumber(rRoll.sSave) then
--		Debug.console("Failed: ", nTotal);
		sSaveResult = "Failure";
	elseif nTotal >= tonumber(rRoll.sSave) then
--			Debug.console("Success: ", nTotal);
			sSaveResult = "Success";
		end
	elseif rRoll.sOp == "<" then
	if nTotal > tonumber(rRoll.sSave) then
--		Debug.console("Failed: ", nTotal);
		sSaveResult = "Failure";
	elseif nTotal <= tonumber(rRoll.sSave) then
--			Debug.console("Success: ", nTotal);
			sSaveResult = "Success";
		end
	end
]]--
--	Debug.chat("sSaveResult: ", sSaveResult);
  rMessage = createChatMessage(rSourceReal, rRoll);
--	Debug.chat("rMessage: ", rMessage);
--	Debug.chat("Msg: ", rMessage.text);
  rMessage.text = rRoll.sDesc .. ", " .. sSaveResult;
  rMessage.type = "dice";
  Comm.deliverChatMessage(rMessage);
end


---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sDice, sDesc)
--  Debug.console("104:createRoll");

  local aDice, nMod = StringManager.convertStringToDice(sDice);

  local rRoll = { };
  rRoll.aDice = aDice;
  rRoll.sType = sCmd;
  rRoll.nMod = nMod;
  rRoll.sDesc = sDesc;
  rRoll.nTarget = 0;
  rRoll.nCount = 3;
--- rRoll.sUser = User.getUsername();

--Debug.console("createRoll: ",rRoll);
  
  return rRoll;
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll)  
--  Debug.console("126:createChatMessage");
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  
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

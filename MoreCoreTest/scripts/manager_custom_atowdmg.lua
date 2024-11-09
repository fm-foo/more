-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local sCmd = "btdamage";


OOB_MSGTYPE_APPLYDAMAGE = "applydamage";

-- MoreCore v0.60 
function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
  OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYDAMAGE, handleApplyDamage);
end

function performAction(draginfo, rActor, sParams)
Debug.console("performAction: ", draginfo, sParams);
Debug.console("performAction: ", rActor);
  local sDice, sDesc = string.match(sParams, "([^%s]+)%s*(.*)");
  sWeaponName = sDesc;
  if not sParams or sParams == "" then 
    sParams = "1d6";
  end

  if sParams == "?" or string.lower(sParams) == "help" then
    createHelpMessage();    
  else
    local rRoll = createRoll(sParams);
    ActionsManager.performAction(draginfo, rActor, rRoll);
  end   

end


function onLanded(rSource, rTarget, rRoll)
Debug.console("onLanded: ", rSource, rTarget, rRoll);
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
  
  local sTargetNode = DB.getPath(rTarget.sCreatureNode);
  local sAttackMoS = rSource.sCTNode;
  
--  local sWeaponNode = DB.getNodeName(SDamageNode);
  Debug.console("Roll Node: ",sTargetNode);
 -- Debug.console("Weapon Node: ",sWeaponNode);
  rRoll = getDiceResults(rRoll);
  
 		local sSaveResult = ""
		local sHitLocation = "torso";
		local nDamageMultiplier = 1;
--		local nLocationd1 = tonumber(rRoll.aDice[1]);
--		local nLocationd2 = tonumber(rRoll.aDice[2]);
		local nTorso = math.random(6);
		local nLegs = math.random(6);
		nLocation = rRoll.aTotal;
		if nLocation == 2 or nLocation == 12 then
			sSaveResult = sSaveResult .. "\r[Location] Head";
			sHitLocation = "head";
			nDamageMultiplier = 2
		elseif nLocation == 3 then
			sSaveResult = sSaveResult .. "\r[Location] Left Foot";
			sHitLocation = "foot";
			nDamageMultiplier = 0.25
		elseif nLocation == 4 then
			sSaveResult = sSaveResult .. "\r[Location] Left Hand";
			sHitLocation = "hand";
			nDamageMultiplier = 0.25
		elseif nLocation == 5 then
			sSaveResult = sSaveResult .. "\r[Location] Left Arm";
			sHitLocation = "arm";
			nDamageMultiplier = 0.5
		elseif nLocation == 6 or nLocation == 8 then
			if nTorso > 4 then
				sSaveResult = sSaveResult .. "\r[Location] Torso (Abdomen)"
			else
				sSaveResult = sSaveResult .. "\r[Location] Torso (Chest)"
			end
		elseif nLocation == 7 then
			sHitLocation = "leg";
			nDamageMultiplier = 0.75;
			if nLegs > 3 then
				sSaveResult = sSaveResult .. "\r[Location] Right Leg"
			else
				sSaveResult = sSaveResult .. "\r[Location] Left Leg"
			end
		elseif nLocation == 9 then
			sSaveResult = sSaveResult .. "\r[Location] Right Arm";
			sHitLocation = "arm";
			nDamageMultiplier = 0.5
		elseif nLocation == 10 then
			sSaveResult = sSaveResult .. "\r[Location] Right Hand";
			sHitLocation = "hand";
			nDamageMultiplier = 0.25
		elseif nLocation == 11 then
			sSaveResult = sSaveResult .. "\r[Location] Right Foot";
			sHitLocation = "foot";
			nDamageMultiplier = 0.25
		end

	local nMarginOfSuccess = DB.getChild(sAttackMoS,"five").getValue();
	Debug.console("MoS: ",nMarginOfSuccess);

	local nDamageResult = DamageCalculator(rSource, rTarget, sHitLocation, nDamageMultiplier, nMarginOfSuccess);	
	Debug.console("Dmg Value = ",nDamageResult);
--	Debug.console("sSaveResult: ", sSaveResult);
--	Debug.console("rTarget: ", rTarget);

	sendApplyDamage(rTarget, nDamageResult);

	if rTarget ~= nil then
		sSaveResult = sSaveResult .. "\nvs "..rTarget.sName;
	end

  rMessage = createChatMessage(rSource, rRoll);
--	Debug.chat("rMessage: ", rMessage);
--	Debug.chat("Msg: ", rRoll.sDesc);
  rMessage.text = rRoll.sDesc .. ", " .. sSaveResult .. " \nDamage multiplier = " .. tostring(nDamageMultiplier) .. " \nDamage applied = " .. tostring(nDamageResult);
  rMessage.type = "damage";
  Comm.deliverChatMessage(rMessage);
 
  
--  rMessage = createChatMessage(rSource, rRoll, rTarget);
--  rMessage.type = "damage";
--  Comm.deliverChatMessage(rMessage);
end


---
--- This function creates the roll object based on the parameters sent in
---
function createRoll(sParams)
  local rRoll = {};
  rRoll.sType = sCmd;
  rRoll.nMod = 0;
--- rRoll.sUser = User.getUsername();
  rRoll.aDice = {};
  rRoll.aDropped = {};

  local nStart, nEnd, sDicePattern, sDescriptionParam = string.find(sParams, "([^%s]+)%s*(.*)");
  rRoll.sDesc = sDescriptionParam;

  -- Now we check that we have a properly formatted parameter, or we set the sDesc for the roll with a message.
  if not sDicePattern:match("(%d+)d([%dF]*)") then
    rRoll.sDesc = "Parameters not in correct format. Should be in the format of \"#d#+#\" ";
    return rRoll;
  end

  local sDice, sDesc = string.match(sParams, "([^%s]+)%s*(.*)");
	
  local aDice, nMod = StringManager.convertStringToDice(sDice);
  local aRulesetDice = Interface.getDice();
  local aFinalDice = {};
  local aNonStandardResults = {};
  for k,v in ipairs(aDice) do
    if StringManager.contains(aRulesetDice, v) then
      table.insert(aFinalDice, v);
    elseif v:sub(1,1) == "-" and StringManager.contains(aRulesetDice, v:sub(2)) then
      table.insert(aFinalDice, v);
    else
      local sSign, sDieSides = v:match("^([%-%+]?)[dD]([%dF]+)");
      if sDieSides then
        local nResult;
        if sDieSides == "F" then
          local nRandom = math.random(3);
          if nRandom == 1 then
            nResult = -1;
          elseif nRandom == 3 then
            nResult = 1;
          end
        else
          local nDieSides = tonumber(sDieSides) or 0;
          nResult = math.random(nDieSides);
        end
        nMod = nMod + nResult;
        table.insert(aNonStandardResults, string.format(" [%s=%d]", v, nResult));
       
      end
    end
  end


  if sDesc ~= "" then
  sDesc = rRoll.sDesc;
  else
    sDesc = sDice;
  end
  if #aNonStandardResults > 0 then
    sDesc = sDesc .. table.concat(aNonStandardResults, "");
  end
  
	local rRoll = { sType = sCmd, sDesc = sDesc, aDice = aFinalDice, nMod = nMod };
	return(rRoll);

 
end

---
--- This function first sorts the dice rolls in ascending order, then it splits
--- the dice results into kept and dropped dice, and stores them as rRoll.aDice
--- and rRoll.aDropped.
---
function getDiceResults(rRoll)
nTotal = 0;
--	Debug.console("GDR-nTotal: ",nTotal);

 
    for _,v in ipairs(rRoll.aDice) do
	nTotal = nTotal + v.result;
	end
	nTotal = nTotal + rRoll.nMod;
  rRoll.aTotal = nTotal;


  return rRoll;
end

---
--- This function creates a chat message that displays the results.
---
function createChatMessage(rSource, rRoll, rTarget)  
  local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

  
  return rMessage;
end

---
--- This function creates the help text message for output.
---
function createHelpMessage()  
  local rMessage = ChatManager.createBaseMessage(nil, nil);
  rMessage.text = rMessage.text .. "The \"/"..sCmd.."\" command is used to roll a set of dice, removing a number of the lowest results.\n"; 
  rMessage.text = rMessage.text .. "You can specify the number of dice to roll, the type of dice, and the number of results to be dropped "; 
  rMessage.text = rMessage.text .. "by supplying the \"/rolld\" command with parameters in the format of \"#d#x#\", where the first # is the "; 
  rMessage.text = rMessage.text .. "number of dice to be rolled, the second number is the number of dice sides, and the number following the "; 
  rMessage.text = rMessage.text .. "x being the number of results to be dropped.\n"; 
  rMessage.text = rMessage.text .. "If no parameters are supplied, the default parameters of \"4d6x1\" are used."; 
  Comm.deliverChatMessage(rMessage);
end

function applyDamage(rTarget, nDamage)
  local myTargetWounds;
  local myTargetFatigue;

  
  if rTarget ~= nil and rTarget.sCTNode ~= nil then
    myTargetWounds = tonumber(DB.getValue(rTarget.sCTNode .. ".wounds"));
    myTargetFatigue = tonumber(DB.getValue(rTarget.sCTNode .. ".four"));
    Debug.console("myTargetWounds: ", myTargetWounds);
    Debug.console("myTargetFatigue: ", myTargetFatigue);
 
    local myTargetNewWounds = myTargetWounds + nDamage;
    Debug.console("myTargetNewWounds: ", myTargetNewWounds);
    local myTarget = rTarget.sCTNode .. ".wounds";
    Debug.console("myTarget: ", myTarget);
    DB.setValue(myTarget, "number", myTargetNewWounds );

	if tonumber(nDamage) > 0 then
		local myTargetNewFatigue = myTargetFatigue + 1
		local myTargetFat = rTarget.sCTNode .. ".four";
		Debug.console("myTargetFat: ", myTargetFat);
		DB.setValue(myTargetFat, "number", myTargetNewFatigue );
	end
  
  end;
end

function sendApplyDamage(rTarget, nDamage)
Debug.console("sendApplyDamage", rTarget, sDamage);
  if not rTarget then
    return;
  end
  
  local msgOOB = {};
  msgOOB.type = OOB_MSGTYPE_APPLYDAMAGE;
  
  msgOOB.nDamage = nDamage;

  local sTargetType, sTargetNode = ActorManager.getTypeAndNodeName(rTarget);
  msgOOB.sTargetType = sTargetType;
  msgOOB.sTargetNode = sTargetNode;

  Comm.deliverOOBMessage(msgOOB, "");
end

function handleApplyDamage(msgOOB)
  local rTarget = ActorManager.resolveActor(msgOOB.sTargetNode);
  local nDamage = msgOOB.nDamage;

  Debug.console("handleApplyDamage", rTarget, nDamage);

  applyDamage(rTarget, nDamage);
end

function DamageCalculator(rAttacker, rTarget, sDamageLocation, nMultiplier, nMarginOfSuccess)

	Debug.console("Weapon Used: ",sWeaponName);
	local sAttackerType = rAttacker.sType;
	if sAttackerType == "pc" then
		sAttackNode = DB.getChild(rAttacker.sCreatureNode,"clilist5");
	else
		sAttackNode = DB.getChild(rAttacker.sCreatureNode,"clilist2");
	end
		
	local sDefendNode = rTarget.sCreatureNode;
	local sArmourNode = "";
	local nWeaponDamage = 0;
	local nDamageType = 0;
	local nPenValue = 0;
	local nArmValue = 0;
	Debug.console("Attack",sAttackNode);
	Debug.console("defender: ",sDefendNode);

	for k, v in pairs(sAttackNode.getChildren()) do
		local sName = DB.getValue(v,"name");
		Debug.console("Weapon Name = ",sName);
		if sName == sWeaponName then
			nWeaponDamage = DB.getValue(v,"p1");
			nDamageType = DB.getValue(v,"p2");
			nPenValue = DB.getValue(v,"p3");
			Debug.console("Weapon Factors = ",nWeaponDamage, nDamageType, nPenValue);
		end
	end

	if nDamageType == 1 then
		sArmourNode = sDamageLocation .. "m";
	elseif nDamageType == 2 then
		sArmourNode = sDamageLocation .. "b";
	elseif nDamageType == 3 then
		sArmourNode = sDamageLocation .. "e";
	elseif nDamageType == 4 then
		sArmourNode = sDamageLocation .. "x";
	end
	
	sDefendNode = rTarget.sCreatureNode;
	Debug.console("Defend Node: ",sDefendNode);
 
	local sDefArmourNode = sDefendNode .. "." .. sArmourNode;
	Debug.console("Def ARm Node: ",sDefArmourNode);
	nArmValue = DB.getChild(sDefendNode,sArmourNode).getValue();
	Debug.console("Def Arm Value: ",nArmValue);

	local nArmEffectiveness = nPenValue - nArmValue;
	Debug.console("ArmEffect: ",nArmEffectiveness);
	
	local nMOSvalue = math.floor(nMarginOfSuccess/4);
	
	if nArmEffectiveness >= 0 then
		nWeaponDamage = (nWeaponDamage + nMOSvalue) * nMultiplier;
		Debug.console("Weapon high: ",nWeaponDamage);
	else
		nWeaponDamage = (nWeaponDamage + nMOSvalue + nArmEffectiveness) * nMultiplier
		Debug.console("Weapon low: ",nWeaponDamage);
	end
	nWeaponDamage = math.floor(nWeaponDamage + 0.5);
	
	if nWeaponDamage < 0 then
		nWeaponDamage = 0;
	end
	Debug.console("Final Damage: ",nWeaponDamage);
	return(nWeaponDamage);
end


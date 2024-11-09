-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- MoreCore v0.60 register "tmod"

local sCmd = "tmod";

function onInit()
  CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all");
	CustomDiceManager.add_roll_type(sCmd, performAction, onLanded, true, "all", nil, nil, onDiceTotal)
end

function performAction(draginfo, rActor, sParams)
-- Debug.console("performAction: ", draginfo, rActor, sParams);

	local rRoll = {};
	rRoll.sType = sCmd;
	rRoll.nMod = 0;
--	Debug.chat("sParams: ", sParams);
--	Debug.chat("ActorManager: ", ActorManager.getCTNode(rActor));
--	Debug.chat("ActorManager: ", ActorManager.getActor(rActor));
--	Debug.chat("ActorManager: ", ActorManager.getTypeAndNodeName(rActor));
--	Debug.chat("ActorManager: ", ActorManager.getType(rActor));
	local sTModcost, sTModname, sDataPath = sParams:match("(%-?%d+)%s*(.*)|(.*)");
--	Debug.chat("sTModcost: ", sTModcost, " sTModname: ", sTModname, " sDataPath: ", sDataPath);
--	Debug.chat("rActor: ", rActor);
	local nodeWin = rActor.sCreatureNode;
--	Debug.chat("nodeWin: ", nodeWin, " sTModname: ", sTModname);
	local sName = rActor.sName;
	local sModDesc, nMod = ModifierStack.getStack(true);
--		Debug.chat("sModDesc: ", sModDesc);
--		Debug.chat("nMod: ", nMod);
	local nTotalCost = tonumber(sTModcost) + nMod;
--		Debug.chat("nTotalCost: ", nTotalCost);

	rRoll.sDesc = sTModname;
	rRoll.nTotalCost = nTotalCost;
	rRoll.sModDesc = sModDesc;
--	Debug.chat("rRoll: ", rRoll);
--	Debug.chat("whereami: ", window.getClass());

--	Debug.console("performAction: ", rRoll);
 
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
    rMessage.dicedisplay = 0; -- display total


--	local nSpellMax = tonumber(DB.getValue(nodeWin .. ".wounds"));
----	Debug.chat("nSpellMax: ", nSpellMax);
----	Debug.chat("nodeWin: ", nodeWin);

		nTModVal = DB.getValue(sDataPath);
	--	Debug.chat("PC nTModVal: ", nTModVal);
	
		rMessage.text = sName .. " uses " .. rMessage.text .. " " .. rRoll.sModDesc .. " (cost " .. nTotalCost .. ")";
		nTModVal = nTModVal + nTotalCost;
--	--	Debug.chat("nTModVal: ", tonumber(nTModVal)); 

		DB.setValue(sDataPath, "number", tonumber(nTModVal));
	--	Debug.chat("PC nTModVal SET: ", nTModVal);

--		DB.setValue(nodeWin .. ".wounds", "number", tonumber(nTModVal));

	rMessage.text = rMessage.text .. rRoll.sModDesc;
	Comm.deliverChatMessage(rMessage);
	end   


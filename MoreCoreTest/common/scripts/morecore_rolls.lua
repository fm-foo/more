--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

function onClickDown()
  local sIcon = getStringValue();
  
  setIcon("down");  

  return true;
end

function onHoverUpdate()
  updateDisplay();
end

function onClickRelease()

  updateDisplay();
  
  sIcon = "button_link";
  local sCurrentId = User.getCurrentIdentity();
--  Debug.console("sCurrentId1: ", sCurrentId);




--  Debug.console("portrait_token: ", sIcon);
--  Debug.console("sCurrentId: ", sCurrentId);


  local cli_rollsWindowDBNode = window.getDatabaseNode();
  local cli_refAPath = DB.getPath(cli_rollsWindowDBNode)

-- Debug.chat("cli_rollsWindowDBNode: ", cli_rollsWindowDBNode);
-- Debug.chat("cli_rollsWindowDBNode: ", cli_refAPath);
  
  local cli_rollsListDBNode = window.getDatabaseNode().getParent();
  local charSheetDBNode = window.getDatabaseNode().getParent().getParent();
  local rActor = ActorManager.resolveActor(charSheetDBNode);
--  Debug.console("rActorMCR: ", rActor);
  local nodeWin = cli_rollsWindowDBNode;
--  Debug.console("nodeWin: ", nodeWin);
  local myCliName = nodeWin.getChild("name").getValue();
--  Debug.console("myCliName: ", myCliName);
    local sRollP1 = nodeWin.getChild("p1").getValue();

  if nodeWin.getChild("clichatcommand")  == nil then
--    Debug.console("No command");
    local sMydesc = nodeWin.getChild("name").getValue();
--    Debug.console("sMydesc: ", sMydesc);
    local sRollName = nodeWin.getChild("name").getValue();
--    Debug.console("sRollName: ", sRollName);
    local msg = {font = "msgfont", icon = sIcon };
    msg.text = rActor.sName .. " uses " .. sRollName;
--    Debug.console("msg: ", msg.text);
--	Debug.console(msg.text);
    Comm.deliverChatMessage(msg);

  else

--	Debug.chat("cli_rollsWindowDBNode: ", cli_rollsWindowDBNode);
--	Debug.chat("cli_refAPath: ", cli_refAPath);

    if User.getCurrentIdentity() then
        local sCurrentId = User.getCurrentIdentity();
    else
--		Debug.chat("rActor: ", rActor.sCreatureNode);
        sCurrentId = string.match(rActor.sCreatureNode, "%.(.*)");
    end


	if nodeWin.getChild("parameter_consumable_enabled") then 
		local sRollName = nodeWin.getChild("name").getValue();
		sConsumable = nodeWin.getChild("parameter_consumable_enabled").getValue();
		if sConsumable == 1 then
			nConsumable = nodeWin.getChild("number_uses_current").getValue();
			local msg = {font = "msgfont", icon = "portrait_" .. sCurrentId .. "_chat"};

				if nConsumable > 1 then
					nodeWin.getChild("number_uses_current").setValue(nConsumable-1);
					msg.text = rActor.sName .. " consumes one use of " .. sRollName ..".";
					Comm.deliverChatMessage(msg);
				elseif nConsumable == 1 then
					nodeWin.getChild("number_uses_current").setValue(nConsumable-1);
					msg.text = rActor.sName .. " consumes the last use of " .. sRollName ..".";
					Comm.deliverChatMessage(msg);
				else
					msg.text = rActor.sName .. " has no uses of " .. sRollName .." remaining.";
					Comm.deliverChatMessage(msg);
				return
				end
		end
	end
		

    local command = nodeWin.getChild("clichatcommand").getValue();


	local formulaEnabled = nodeWin.getChild("parameter_formula_enabled").getValue();	
	if( formulaEnabled == 1 ) then
--		command = ParameterManager.updateMath1(nodeWin);
--		command = ParameterManager.updateMath2(nodeWin);
--		command = ParameterManager.updateMath3(nodeWin);
		command = ParameterManager.updateCommand(nodeWin);

		end
	
--    Debug.console("command: ", command);

    if command ~= "" then

      local myCliCommand = nodeWin.getChild("clichatcommand").getValue();
--      Debug.console("myCliCommand: ", myCliCommand);

      local nStart,nEnd,sCommand,sParams = string.find(command, '^/([^%s]+)%s*(.*)');

      local sMydesc = nodeWin.getChild("name").getValue();
--      Debug.console("sMydesc: ", sMydesc);

      if sCommand == "rollon" then
        sParams = sParams;
--        Debug.console("Rollon!: ", sParams);
      elseif sCommand == "tmod" then
--		Debug.chat("Pool data here: ", cli_refAPath);
		cli_refAData = DB.getValue(cli_rollsWindowDBNode, "refa_path", 0); 
--		Debug.chat("Pool data value: ", cli_refAData);

		sNewValue = DB.getChild(window.getDatabaseNode(), cli_refAData);
--		Debug.chat("newValue: ", sNewValue);
--		Debug.chat("finalpath: ", DB.getPath(sNewValue));
--		Debug.chat("finalValue: ", DB.getValue(DB.getPath(sNewValue), 0));

        sParams = sParams .." " .. sMydesc .. "|" .. DB.getPath(sNewValue);
--        Debug.console("Rollon!: ", sParams);
      else
        sParams = sParams .." "..sMydesc;
--        Debug.console("Other!: ", sParams);
      end


--      Debug.console("sCommand3: ",sCommand, sParams);
      local sRollName = nodeWin.getChild("name").getValue();
--      Debug.console("sRollName: ", sRollName);
      local msg = {font = "msgfont", icon = sIcon };
      msg.text = rActor.sName .. " uses " .. sRollName;

--      Debug.console("launching command: ", sCommand, nil, rActor, sParams);

      if CustomDiceManager.rollRegistered(sCommand) then
        CustomDiceManager.performAction(sCommand, nil, rActor, sParams);
      else
--        Debug.console("launching command: ", sCommand, sParams);
        if sCommand == "die" then
		local sDice, sDesc = string.match(sParams, "%s*(%S+)%s*(.*)");
			local rRoll;
			if Interface.getVersion() < 4 then
				local aDice, nMod = StringManager.convertStringToDice(sDice);
				rRoll = { sType = "dice", sDesc = sDesc, aDice = aDice, nMod = nMod };
			else
				rRoll = { sType = "dice", sDesc = sDesc, aDice = { expr = sDice }, nMod = 0 };
			end
			ActionsManager.performAction(draginfo, nil, rRoll);

        elseif sCommand == 'successes' and CountSuccesses then
          CountSuccesses.processRoll(sCommand, sParams);
        elseif sCommand == 'cstun' and CStun then
          CStun.processRoll(sCommand, sParams);
        elseif sCommand == 'ckill' and CKill then
          CKill.processRoll(sCommand, sParams);
        elseif sCommand == 'rollunder' and RollUnder then
          RollUnder.processRoll(sCommand, sParams);
        elseif sCommand == 'rollunderdmod' and RollUnderDMod then
          RollUnder.processRoll(sCommand, sParams);
        elseif sCommand == 'rollundersmod' and RollUnderSMod then
          RollUnder.processRoll(sCommand, sParams);
        elseif sCommand == 'rollover' and RollOver then
          RollOver.processRoll(sCommand, sParams);
        elseif sCommand == 'conan' and Conan then
          Conan.processRoll(sCommand, sParams);
        elseif sCommand == 'coriolis' and Coriolis then
          Coriolis.processRoll(sCommand, sParams);
        elseif sCommand == 'sfdice' and SuccessFail then
          SuccessFail.processRoll(sCommand, sParams);

        elseif sCommand == 'mod' then
--          Debug.console("Modifier!", sCommand);
--          Debug.console("Modifier!!", sParams);
          ChatManager.processMod(sCommand, sParams);
        elseif sCommand == 'rollon' then
--          Debug.console("Rollon!", sCommand);
--          Debug.console("Rollon!!", sParams);
          TableManager.processTableRoll(sCommand, sParams);
        elseif sCommand == 'woddice' and WODdice then
          WODdice.processRoll(sCommand, sParams);
        elseif sCommand == 'rnk' and DiceMechanicsManager then
          DiceMechanicsManager.onRollAndKeepSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'rnkd' and DiceMechanicsManager then
          DiceMechanicsManager.onRollAndKeepDamageSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'rnkdk' and DiceMechanicsManager then
          DiceMechanicsManager.onRollAndKeepDamageKatanaSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'rnke' and DiceMechanicsManager then
          DiceMechanicsManager.onRollAndKeepEmphasisSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'edie' and DiceMechanicsManager then
          DiceMechanicsManager.onExplodingDiceSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'edies' and DiceMechanicsManager then
          DiceMechanicsManager.onExplodingDiceSuccessesSlashCommand(sCommand, sParams .. " " .. rActor.sName);
        elseif sCommand == 'spell' then
          local msg = {font = "msgfont", icon = "spell" };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'cleric' then
          local msg = {font = "msgfont", icon = "cleric" };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'wizard' then
          local msg = {font = "msgfont", icon = "wizard" };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'fireball' then
          local msg = {font = "msgfont", icon = "fireball" };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'druid' then
          local msg = {font = "msgfont", icon = "druid" };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'rank' then
          local msg = {font = "msgfont", icon = "rank" };
          msg.text = rActor.sName .. " uses " .. sRollName .. " rank " .. sRollP1;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'bard' then
          local msg = {font = "msgfont", icon = "bard" };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'skull' then
          local msg = {font = "msgfont", icon = "skull" };
          msg.text = rActor.sName .. " casts " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'trait' then
          local msg = {font = "msgfont", icon = "trait" };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'mtrait' then
          local msg = {font = "msgfont", icon = "mtrait" };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'ability' then
          local msg = {font = "msgfont", icon = "ability"};
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'btalent' then
          local msg = {font = "msgfont", icon = "btalent" };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);
        elseif sCommand == 'btechnique' then
          local msg = {font = "msgfont", icon = "btechnique" };
          msg.text = rActor.sName .. " uses " .. sRollName;
--          Debug.console("msg: ", msg.text);
--          Debug.console(msg.text);
          Comm.deliverChatMessage(msg);


        end
      end

    elseif command == "" then
--      Debug.console("No command");
      local sMydesc = nodeWin.getChild("name").getValue();
--      Debug.console("sMydesc: ", sMydesc);
      local sRollName = nodeWin.getChild("name").getValue();
--      Debug.console("sRollName: ", sRollName);
      local msg = {font = "msgfont", icon = sIcon };
      msg.text = rActor.sName .. " uses " .. sRollName;
--      Debug.console("msg: ", msg.text);
--      Debug.console(msg.text);
      Comm.deliverChatMessage(msg);

    end
  end
end
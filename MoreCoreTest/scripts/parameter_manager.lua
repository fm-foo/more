
-- Called when the formula, or one of the parameters has been updated 
-- to update the clichatcommand
function updateCommand(nodeWin)
	if not nodeWin.getChild("tracker_enabled").getValue() == 1 then
		if not nodeWin.getChild("clichatcommand").getValue() then
			local formula = "";
			else
			local formula = nodeWin.getChild("clichatcommand").getValue();
			end
		end
	
    if( nodeWin ~= nil ) then
        local formulaEnabledNode = nodeWin.getChild("parameter_formula_enabled")
    
        if( formulaEnabledNode ~= nil ) then
            local formulaEnabled = nodeWin.getChild("parameter_formula_enabled").getValue();
            
            if( formulaEnabled == 1 ) then

                formula = nodeWin.getChild("parameter_formula").getValue();

                if( formula ~= "" ) then
					-- Get the 3 parameter numbers to use for substitution into the formula
--					Debug.chat("nodeWin: ", nodeWin);
					-- KEL
                    local param1 = DB.getValue(nodeWin, "p1", 0);
                    local param3 = DB.getValue(nodeWin, "p3", 0);
                    local param4 = DB.getValue(nodeWin, "trackersname", 0);
                    local param5 = DB.getValue(nodeWin, "number_trackers", 0);
					if formula:match("mythras") then
						local paramA = 0;
						local paramB = 0;
						local ref_pathANode = nodeWin.getChild("refa_path");
						if ref_pathANode then
							local reflA = ref_pathANode.getValue();
							local refgfA = nil;
							if reflA then
								if( string.sub(reflA,1,1) == "." ) then
									refgfA = nodeWin.getChild(reflA);
								else
									refgfA = DB.getChild(reflA,".");
								end
							end
							if refgfA and not (refgfA == "") then
								local valA = refgfA.getValue();
								if( valA ~= nil and (type(valA) == "string" or type(valA) == "number") ) then
									paramA = valA;
								end
							end
						end
						local ref_pathBNode = nodeWin.getChild("refb_path");
						if ref_pathBNode then
							local reflB = ref_pathBNode.getValue();
							local refgfB = nil;
							if reflB then
								if( string.sub(reflB,1,1) == "." ) then
									refgfB = nodeWin.getChild(reflB);
								else
									refgfB = DB.getChild(reflB,".");
								end
							end
							if refgfB and not (refgfB == "") then
								local valB = refgfB.getValue();
								if( valB ~= nil and (type(valB) == "string" or type(valB) == "number") ) then
									paramB = valB;
								end
							end
						end
						DB.setValue(nodeWin, "p2", "number", param1 + paramA + paramB);
					end
					if formula:match("topsecret") then
						local paramA = 0;
						local paramB = 0;
						local ref_pathANode = nodeWin.getChild("refa_path");
						if ref_pathANode then
							local reflA = ref_pathANode.getValue();
							local refgfA = nil;
							if reflA then
								if( string.sub(reflA,1,1) == "." ) then
									refgfA = nodeWin.getChild(reflA);
								else
									refgfA = DB.getChild(reflA,".");
								end
							end
							if refgfA and not (refgfA == "") then
								local valA = refgfA.getValue();
								if( valA ~= nil and (type(valA) == "string" or type(valA) == "number") ) then
									paramA = valA;
								end
							end
						end
						local ref_pathBNode = nodeWin.getChild("refb_path");
						if ref_pathBNode then
							local reflB = ref_pathBNode.getValue();
							local refgfB = nil;
							if reflB then
								if( string.sub(reflB,1,1) == "." ) then
									refgfB = nodeWin.getChild(reflB);
								else
									refgfB = DB.getChild(reflB,".");
								end
							end
							if refgfB and not (refgfB == "") then
								local valB = refgfB.getValue();
								if( valB ~= nil and (type(valB) == "string" or type(valB) == "number") ) then
									paramB = valB;
								end
							end
						end
						DB.setValue(nodeWin, "p2", "number", math.floor((paramA + paramB)/2));
					end

					if formula:match("tstertiary") then
						local paramA = 0;
						local paramB = 0;
						local ref_pathANode = nodeWin.getChild("refa_path");
						if ref_pathANode then
							local reflA = ref_pathANode.getValue();
							local refgfA = nil;
							if reflA then
								if( string.sub(reflA,1,1) == "." ) then
									refgfA = nodeWin.getChild(reflA);
								else
									refgfA = DB.getChild(reflA,".");
								end
							end
							if refgfA and not (refgfA == "") then
								local valA = refgfA.getValue();
								if( valA ~= nil and (type(valA) == "string" or type(valA) == "number") ) then
									paramA = valA;
								end
							end
						end
						local ref_pathBNode = nodeWin.getChild("refb_path");
						if ref_pathBNode then
							local reflB = ref_pathBNode.getValue();
							local refgfB = nil;
							if reflB then
								if( string.sub(reflB,1,1) == "." ) then
									refgfB = nodeWin.getChild(reflB);
								else
									refgfB = DB.getChild(reflB,".");
								end
							end
							if refgfB and not (refgfB == "") then
								local valB = refgfB.getValue();
								if( valB ~= nil and (type(valB) == "string" or type(valB) == "number") ) then
									paramB = valB;
								end
							end
						end
						DB.setValue(nodeWin, "p2", "number", paramA + paramB);
					end

					if formula:match("tsmove") then
						local paramA = 0;
						local paramB = 0;
						local paramC = 0;
						local ref_pathANode = nodeWin.getChild("refa_path");
						if ref_pathANode then
							local reflA = ref_pathANode.getValue();
							local refgfA = nil;
							if reflA then
								if( string.sub(reflA,1,1) == "." ) then
									refgfA = nodeWin.getChild(reflA);
								else
									refgfA = DB.getChild(reflA,".");
								end
							end
							if refgfA and not (refgfA == "") then
								local valA = refgfA.getValue();
								if( valA ~= nil and (type(valA) == "string" or type(valA) == "number") ) then
									paramA = valA;
								end
							end
						end
						local ref_pathBNode = nodeWin.getChild("refb_path");
						if ref_pathBNode then
							local reflB = ref_pathBNode.getValue();
							local refgfB = nil;
							if reflB then
								if( string.sub(reflB,1,1) == "." ) then
									refgfB = nodeWin.getChild(reflB);
								else
									refgfB = DB.getChild(reflB,".");
								end
							end
							if refgfB and not (refgfB == "") then
								local valB = refgfB.getValue();
								if( valB ~= nil and (type(valB) == "string" or type(valB) == "number") ) then
									paramB = valB;
								end
							end
						end
						local ref_pathCNode = nodeWin.getChild("refc_path");
						if ref_pathCNode then
							local reflC = ref_pathCNode.getValue();
							local refgfC = nil;
							if reflC then
								if( string.sub(reflC,1,1) == "." ) then
									refgfC = nodeWin.getChild(reflC);
								else
									refgfC = DB.getChild(reflC,".");
								end
							end
							if refgfC and not (refgfC == "") then
								local valC = refgfC.getValue();
								if( valC ~= nil and (type(valC) == "string" or type(valC) == "number") ) then
									paramB = valC;
								end
							end
						end
						DB.setValue(nodeWin, "p2", "number", paramA + paramB + paramC);
					end

					if formula:match("tslife") then
						local paramA = 0;
						local paramB = 0;
						local ref_pathANode = nodeWin.getChild("refa_path");
						if ref_pathANode then
							local reflA = ref_pathANode.getValue();
							local refgfA = nil;
							if reflA then
								if( string.sub(reflA,1,1) == "." ) then
									refgfA = nodeWin.getChild(reflA);
								else
									refgfA = DB.getChild(reflA,".");
								end
							end
							if refgfA and not (refgfA == "") then
								local valA = refgfA.getValue();
								if( valA ~= nil and (type(valA) == "string" or type(valA) == "number") ) then
									paramA = valA;
								end
							end
						end
						local ref_pathBNode = nodeWin.getChild("refb_path");
						if ref_pathBNode then
							local reflB = ref_pathBNode.getValue();
							local refgfB = nil;
							if reflB then
								if( string.sub(reflB,1,1) == "." ) then
									refgfB = nodeWin.getChild(reflB);
								else
									refgfB = DB.getChild(reflB,".");
								end
							end
							if refgfB and not (refgfB == "") then
								local valB = refgfB.getValue();
								if( valB ~= nil and (type(valB) == "string" or type(valB) == "number") ) then
									paramB = valB;
								end
							end
						end
						DB.setValue(nodeWin, "p2", "number", math.ceil((paramA + paramB)/10));
					end
					
                    local param2 = DB.getValue(nodeWin, "p2", 0);
					-- END
					
                    if( param1 ~= "" ) then
                        formula = string.gsub(formula, "[(]p1[)]", param1);
                    end
                    
                    if( param2 ~= "" ) then
                        formula = string.gsub(formula, "[(]p2[)]", param2);
                    end

                    if( param3 ~= "" ) then
                        formula = string.gsub(formula, "[(]p3[)]", param3);
                    end

                    if( param4 ~= "" ) then
                        formula = string.gsub(formula, "[(]p4[)]", param4);
                    end

                    if( param5 ~= "" ) then
                        formula = string.gsub(formula, "[(]number_trackers[)]", param5);
                    end

					-- If the Grouped Rolls Extension is installed, allow lookup of an attribute value from the parent of the list 
					local attriblist = nodeWin.getParent();
					local category = attriblist.getParent();
--					local cat_stat = category.getChild("category_stat");
--					if( cat_stat ~= nil ) then
						--Debug.chat("Stat: ", cat_stat.getPath(), cat_stat.getValue() );
--						formula = string.gsub(formula, "[(]att[)]", cat_stat.getValue());
--					end

					-- If reference rolls Extension is installed, allow lookup of the parameters off a referenced roll
					formula = replaceRefValue( nodeWin, formula, "a", "refa_path" );
					formula = replaceRefValue( nodeWin, formula, "b", "refb_path" );
					formula = replaceRefValue( nodeWin, formula, "c", "refc_path" );

					--- Added by Frostbyte
					--- If the formula has brackets "[" it will try to do the math between the brackets
					--- This only supports add and subtract. It is possible to make this data structure
					--- more complete by doing division and multiplication, but not requested right now
					--- and more importantly I only had a few hours I could give to this.
					--Debug.console("Update before replace: ",formula);

					if string.match(formula,"[\[]") and string.match(formula,"[\]]") then
						--Debug.console("I haz bracket");
						local bStartRec = true;
						local sFormulaReplace = "";
						local sStringToCalc = "";
						local nToReplace = 0;
						for i=1, string.len(formula) do
							local ch = string.sub(formula,i,i);
							--Debug.console("add: ", ch);
							if ch == "[" then
								bStartRec = false;
								sFormulaReplace = sFormulaReplace .. "DiceReplaceHere";
							elseif ch == "]" then
								bStartRec = true;
							else
								if bStartRec then
									sFormulaReplace = sFormulaReplace .. ch;
								else
									sStringToCalc = sStringToCalc .. ch;
								end
							end
						end
						--Debug.console("sFormulaReplace: ",sFormulaReplace ,"sStringToCalc: ",sStringToCalc);

						sSTCValue1, sSTCValue2 = sStringToCalc:match("(.+)[+-/%*](.+)");
				--		Debug.chat("sSTCValue1: ", sSTCValue1);
				--		Debug.chat("sSTCValue2: ", sSTCValue2);
						sSTSCOp = sStringToCalc:match(".+([+-/%*]).+");
				--		Debug.chat("sSTSCOp: ", sSTSCOp);
						local sSTCValue3;
						if sSTSCOp == "+" then
							sSTCValue3 = tonumber(sSTCValue1) + tonumber(sSTCValue2);
						elseif sSTSCOp == "-" then
							sSTCValue3 = tonumber(sSTCValue1) - tonumber(sSTCValue2);
						elseif sSTSCOp == "/" then
							sSTCValue3 = tonumber(sSTCValue1) / tonumber(sSTCValue2);
						elseif sSTSCOp == "*" then
							sSTCValue3 = tonumber(sSTCValue1) * tonumber(sSTCValue2);
						end
							
				--		Debug.chat("sSTCValue3: ", sSTCValue3);
						
						


						local sFormulaReplace = sFormulaReplace:gsub("DiceReplaceHere",sSTCValue3);
						formula = sFormulaReplace;

					else
						--Debug.console("I No haz bracket");
					end
					--Debug.console("Update after replace: ",formula);
					--- End Frostbyte edit

--					Debug.chat("formula: ", formula);
					myClichatcommand = nodeWin.getChild("clichatcommand");
--					Debug.chat("clichatcommand: ", clichatcommand);
                    nodeWin.getChild("clichatcommand").setValue(formula);
					
                end -- formula not empty
            end -- formula enabled
        end -- formulaEnabled node not nil
    end -- we weren't passed nil for nodeWin

	return formula;
end

function replaceRefValue( nodeWin, formula, refLetter, refChild )
	local ref_pathNode = nodeWin.getChild(refChild);
	if( ref_pathNode ~= nil ) then
		
		local ref1_path = ref_pathNode.getValue();
		-- KEL replaced ref_path with ref1_path . Typo?
		if( ref1_path ~= "" ) then 
		-- END
			
			local refgf = nil;
			local refp1 = nil;
			local refp2 = nil;
			local refp3 = nil;
			local refp4 = nil;
			local refp5 = nil;

			if( string.sub(ref1_path,1,1) == "." ) then
				refgf = nodeWin.getChild(ref1_path);
				refp1 = nodeWin.getChild(ref1_path .. ".p1");
				refp2 = nodeWin.getChild(ref1_path .. ".p2");
				refp3 = nodeWin.getChild(ref1_path .. ".p3");
				refp4 = nodeWin.getChild(ref1_path .. ".trackersname");
				refp5 = nodeWin.getChild(ref1_path .. ".number_trackers");
			else
				refgf = DB.getChild(ref1_path,".");
				refp1 = DB.getChild(ref1_path,"p1");
				refp2 = DB.getChild(ref1_path,"p2");
				refp3 = DB.getChild(ref1_path,"p3");
				refp4 = DB.getChild(ref1_path,"trackersname");
				refp5 = DB.getChild(ref1_path,"number_trackers");
			end

			if( refp1 == nil and refgf ~= nil and refgf ~= "" ) then
				local val = refgf.getValue();
				if( val ~= nil and (type(val) == "string" or type(val) == "number") ) then
					formula = string.gsub(formula, "[(]"..refLetter.."[)]", val);
				end
			end

			if( refp1 ~= nil ) then
				formula = string.gsub(formula, "[(]"..refLetter.."1[)]", refp1.getValue());
			end

			if( refp2 ~= nil ) then
				formula = string.gsub(formula, "[(]"..refLetter.."2[)]", refp2.getValue());
			end

			if( refp3 ~= nil ) then
				formula = string.gsub(formula, "[(]"..refLetter.."3[)]", refp3.getValue());
			end					

			if( refp4 ~= nil ) then
				formula = string.gsub(formula, "[(]"..refLetter.."4[)]", refp4.getValue());
			end					

			if( refp5 ~= nil ) then
				formula = string.gsub(formula, "[(]"..refLetter.."5[)]", refp5.getValue());
			end					
		end
	end

	return formula;
end
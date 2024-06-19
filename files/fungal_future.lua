function gui_fungal_shift_insert_future_shifts(i, mats)
	local arr = {}
	arr.flask = ""
	arr.number = i
	arr.from = {}
	for _,mat in ipairs(mats.from.materials) do
		table.insert(arr.from, mat)
		arr.to = mats.to.material
	end
	if mats.from.flask == true then arr.flask = "from" end
	if mats.to.flask == true then 
		arr.flask = "to" 
		arr.greedy_mat = mats.to.greedy_mat
		arr.grass_holy = mats.to.grass_holy
		arr.greedy_success = mats.to.greedy_success
	end
	return arr
end

function gui_fungal_shift_get_future_shifts()
	future_shifts = {}
	current_shifts = tonumber(GlobalsGetValue("fungal_shift_iteration", "0"))

	for i=current_shifts+1,maximum_shifts,1 do
		local seed_shifts = gui_fungal_shift_get_seed_shifts(i)
		future_shifts[i] = gui_fungal_shift_insert_future_shifts(i, seed_shifts)
		if seed_shifts.failed ~= nil then 
			future_shifts[i].failed = gui_fungal_shift_insert_future_shifts(i, seed_shifts.failed) 
		else
			future_shifts[i].failed = nil
			if seed_shifts.from.flask then
				future_shifts[i].if_fail = gui_fungal_shift_insert_future_shifts(i, gui_fungal_shift_get_seed_shifts(i, 1))
			end
		end
	end
end

function gui_fungal_shift_display_future_shifts(gui)
	local nextshifttext = _T.lamas_stats_fungal_next_shift
	
	if current_shifts < maximum_shifts then
		GuiText(gui, 0, 0, "---- " .. nextshifttext .. " ----",fungal_shift_scale)
	end

	for i=current_shifts+1,maximum_shifts,1 do
		GuiLayoutBeginHorizontal(gui,0,0,0,0,0)
		GuiText(gui, 0, 0, _T.lamas_stats_shift .. " " .. tostring(future_shifts[i].number) .. ": ", fungal_shift_scale)
		
		gui_fungal_shift_display_from(gui, future_shifts[i])
		gui_fungal_shift_display_to(gui, future_shifts[i])
		GuiLayoutEnd(gui)
		if i == current_shifts+1 and i < maximum_shifts then
			GuiLayoutBeginHorizontal(gui,0,0,0,0,0)
			GuiText(gui, 0, 0, "---- ",fungal_shift_scale) 
			GuiText(gui, GuiGetTextDimensions(gui, nextshifttext, fungal_shift_scale), 0, " ----",fungal_shift_scale)
			GuiLayoutEnd(gui)
		end
	end	
end
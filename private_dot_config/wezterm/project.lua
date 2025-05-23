local startup = function(env_var, projects_module, wezterm)
	local project = os.getenv(env_var)

	if project == nil then
		return
	end

	local status, project_module = pcall(function()
		return require(projects_module .. "." .. project)
		-- lua will automatically convert `projects.<project>` into `~/.config/wezterm/projects/<project>.lua`
		-- when processing this require statement
	end)
	if not status then
		-- in the failure case, project_module is the error message
		wezterm.log_error("Unable to import " .. project_module)
		return
	end
	local project_startup = project_module.startup

	if project_startup == nil or type(project_startup) ~= "function" then
		wezterm.log_error(
			"Project " .. project .. " has no exported 'startup' function (type is " .. type(project_startup) .. ")"
		)
		return
	end

	project_startup(wezterm)
end

return {
	startup = startup,
}
